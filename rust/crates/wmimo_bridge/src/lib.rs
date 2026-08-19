use chrono::Utc;
use directories::ProjectDirs;
use parking_lot::RwLock;
use std::collections::HashMap;
use std::path::PathBuf;
use std::sync::Arc;
use tokio::sync::broadcast;
use tracing::info;
use uuid::Uuid;

use wmimo_common::{
    AppSetting, ConnectionSnapshot, LogMessage, ProfileItem, ProxyMode, ProxyNode,
    Result, ServiceStatus, TrafficData, TunnelState, WmimoError,
};
use wmimo_config_engine::ConfigEngine;
use wmimo_core_mgr::CoreManager;
use wmimo_firewall::FirewallManager;
use wmimo_sys_proxy::SysProxy;

/// Wmimo 全局核心控制器
pub struct WmimoController {
    app_dir: PathBuf,
    profiles_dir: PathBuf,
    work_dir: PathBuf,
    core_path: PathBuf,
    settings: RwLock<AppSetting>,
    status: RwLock<ServiceStatus>,
    profiles: RwLock<Vec<ProfileItem>>,
    core_mgr: CoreManager,
    config_engine: ConfigEngine,
    traffic_tx: broadcast::Sender<TrafficData>,
    logs_tx: broadcast::Sender<LogMessage>,
    status_tx: broadcast::Sender<ServiceStatus>,
}

impl WmimoController {
    /// 初始化控制器
    pub fn init() -> Result<Arc<Self>> {
        let dirs = ProjectDirs::from("com", "Wmimo", "WmimoApp")
            .ok_or_else(|| WmimoError::Custom("无法获取系统应用目录".to_string()))?;

        let app_dir = dirs.data_dir().to_path_buf();
        let profiles_dir = app_dir.join("profiles");
        let work_dir = app_dir.join("core_work");
        let _ = std::fs::create_dir_all(&profiles_dir);
        let _ = std::fs::create_dir_all(&work_dir);

        #[cfg(target_os = "windows")]
        let core_path = app_dir.join("mihomo.exe");
        #[cfg(not(target_os = "windows"))]
        let core_path = app_dir.join("mihomo");

        let (traffic_tx, _) = broadcast::channel(128);
        let (logs_tx, _) = broadcast::channel(256);
        let (status_tx, _) = broadcast::channel(32);

        let core_mgr = CoreManager::new(&core_path, &work_dir);
        let config_engine = ConfigEngine::new(&profiles_dir);

        let controller = Arc::new(Self {
            app_dir,
            profiles_dir,
            work_dir,
            core_path,
            settings: RwLock::new(AppSetting::default()),
            status: RwLock::new(ServiceStatus::default()),
            profiles: RwLock::new(Vec::new()),
            core_mgr,
            config_engine,
            traffic_tx,
            logs_tx,
            status_tx,
        });

        // 尝试加载持久化的配置和订阅列表
        controller.load_persisted_state();

        Ok(controller)
    }

    fn load_persisted_state(&self) {
        let settings_file = self.app_dir.join("settings.json");
        if settings_file.exists() {
            if let Ok(content) = std::fs::read_to_string(&settings_file) {
                if let Ok(setting) = serde_json::from_str::<AppSetting>(&content) {
                    *self.settings.write() = setting;
                }
            }
        }

        let profiles_meta_file = self.app_dir.join("profiles.json");
        if profiles_meta_file.exists() {
            if let Ok(content) = std::fs::read_to_string(&profiles_meta_file) {
                if let Ok(list) = serde_json::from_str::<Vec<ProfileItem>>(&content) {
                    *self.profiles.write() = list;
                }
            }
        }
    }

    fn save_persisted_state(&self) {
        let settings = self.settings.read().clone();
        if let Ok(s) = serde_json::to_string_pretty(&settings) {
            let _ = std::fs::write(self.app_dir.join("settings.json"), s);
        }

        let profiles = self.profiles.read().clone();
        if let Ok(s) = serde_json::to_string_pretty(&profiles) {
            let _ = std::fs::write(self.app_dir.join("profiles.json"), s);
        }
    }

    /// 启动代理服务
    pub async fn start_proxy(&self) -> Result<()> {
        info!("Wmimo 正在启动代理服务...");
        {
            let mut st = self.status.write();
            st.state = TunnelState::Connecting;
            let _ = self.status_tx.send(st.clone());
        }

        let current_profile = {
            let list = self.profiles.read();
            list.iter().find(|p| p.enabled).cloned()
        };

        let profile = current_profile.ok_or_else(|| {
            let mut st = self.status.write();
            st.state = TunnelState::Error;
            st.error = Some("未选择任何有效订阅配置".to_string());
            let _ = self.status_tx.send(st.clone());
            WmimoError::Config("请先添加并激活一个订阅配置文件".to_string())
        })?;

        let raw_yaml_path = self.profiles_dir.join(&profile.file_name);
        let raw_yaml = std::fs::read_to_string(&raw_yaml_path)
            .map_err(|e| WmimoError::Io(format!("读取配置失败: {}", e)))?;

        let setting = self.settings.read().clone();
        let final_yaml = ConfigEngine::build_final_config(&raw_yaml, &setting, None)?;

        let final_config_path = self.work_dir.join("config.yaml");
        std::fs::write(&final_config_path, final_yaml)
            .map_err(|e| WmimoError::Io(format!("写入最终配置失败: {}", e)))?;

        // 放行防火墙
        let _ = FirewallManager::add_app_rule(&self.core_path, "Wmimo-Core");
        let _ = FirewallManager::add_port_rules(
            &[setting.mixed_port, setting.control_port],
            "Wmimo-Ports",
        );

        // 启动核心
        let client = match self
            .core_mgr
            .start(&final_config_path, setting.control_port, &setting.secret)
            .await
        {
            Ok(c) => c,
            Err(e) => {
                let mut st = self.status.write();
                st.state = TunnelState::Error;
                st.error = Some(e.to_string());
                let _ = self.status_tx.send(st.clone());
                return Err(e);
            }
        };

        // 启动 WebSocket 数据流监听
        client.start_traffic_stream(self.traffic_tx.clone());
        client.start_logs_stream(self.logs_tx.clone(), &setting.log_level);

        // 设置系统代理 (如果开启)
        if setting.system_proxy && !setting.tun_mode {
            let _ = SysProxy::enable("127.0.0.1", setting.mixed_port, None);
        }

        {
            let mut st = self.status.write();
            st.state = TunnelState::Connected;
            st.current_profile_id = Some(profile.id);
            st.system_proxy_enabled = setting.system_proxy;
            st.tun_enabled = setting.tun_mode;
            st.error = None;
            let _ = self.status_tx.send(st.clone());
        }

        info!("Wmimo 代理服务已成功启动！");
        Ok(())
    }

    /// 停止代理服务
    pub async fn stop_proxy(&self) -> Result<()> {
        info!("Wmimo 正在停止代理服务...");
        {
            let mut st = self.status.write();
            st.state = TunnelState::Disconnecting;
            let _ = self.status_tx.send(st.clone());
        }

        // 恢复系统代理
        let _ = SysProxy::disable();

        // 停止核心子进程
        let _ = self.core_mgr.stop().await;

        {
            let mut st = self.status.write();
            st.state = TunnelState::Disconnected;
            st.system_proxy_enabled = false;
            st.traffic = TrafficData::default();
            st.error = None;
            let _ = self.status_tx.send(st.clone());
        }

        info!("Wmimo 代理服务已停止");
        Ok(())
    }

    /// 切换启停状态
    pub async fn toggle_proxy(&self) -> Result<ServiceStatus> {
        let is_running = self.status.read().state == TunnelState::Connected;
        if is_running {
            self.stop_proxy().await?;
        } else {
            self.start_proxy().await?;
        }
        Ok(self.status.read().clone())
    }

    /// 设置分流模式 (Rule / Global / Direct)
    pub async fn set_proxy_mode(&self, mode: ProxyMode) -> Result<()> {
        self.settings.write().mode = mode;
        self.save_persisted_state();

        if let Some(client) = self.core_mgr.get_client() {
            let _mode_str = match mode {
                ProxyMode::Rule => "rule",
                ProxyMode::Global => "global",
                ProxyMode::Direct => "direct",
            };
            let _ = client.reload_config(&self.work_dir.join("config.yaml").to_string_lossy()).await;
        }

        let mut st = self.status.write();
        st.mode = mode;
        let _ = self.status_tx.send(st.clone());
        Ok(())
    }

    /// 添加远程订阅
    pub async fn add_subscription(&self, name: &str, url: &str) -> Result<ProfileItem> {
        let (content, user_info) = ConfigEngine::fetch_subscription(url).await?;
        let id = Uuid::new_v4().to_string();
        let file_name = format!("{}.yaml", id);

        self.config_engine.save_config_file(&file_name, &content)?;

        let item = ProfileItem {
            id: id.clone(),
            name: name.to_string(),
            url: Some(url.to_string()),
            file_name,
            updated_at: Utc::now(),
            total_traffic: user_info.as_ref().map(|u| u.total),
            used_traffic: user_info.as_ref().map(|u| u.upload + u.download),
            expire_time: user_info.and_then(|u| u.expire),
            auto_update_interval_minutes: 1440,
            enabled: self.profiles.read().is_empty(),
        };

        self.profiles.write().push(item.clone());
        self.save_persisted_state();

        info!("成功添加订阅配置: {} ({})", name, id);
        Ok(item)
    }

    /// 获取所有代理节点与策略组
    pub async fn get_proxies(&self) -> Result<HashMap<String, ProxyNode>> {
        if let Some(client) = self.core_mgr.get_client() {
            client.get_proxies().await
        } else {
            Ok(HashMap::new())
        }
    }

    /// 切换策略组选中的节点
    pub async fn select_proxy(&self, group: &str, target: &str) -> Result<()> {
        if let Some(client) = self.core_mgr.get_client() {
            client.select_proxy(group, target).await
        } else {
            Err(WmimoError::Core("核心未在运行".to_string()))
        }
    }

    /// 节点测速
    pub async fn test_proxy_delay(&self, node_name: &str) -> Result<u16> {
        if let Some(client) = self.core_mgr.get_client() {
            client.test_proxy_delay(node_name, None, Some(5000)).await
        } else {
            Err(WmimoError::Core("核心未在运行".to_string()))
        }
    }

    /// 获取连接快照
    pub async fn get_connections(&self) -> Result<ConnectionSnapshot> {
        if let Some(client) = self.core_mgr.get_client() {
            client.get_connections().await
        } else {
            Ok(ConnectionSnapshot::default())
        }
    }

    /// 获取当前服务状态
    pub fn get_status(&self) -> ServiceStatus {
        self.status.read().clone()
    }

    /// 获取订阅列表
    pub fn list_profiles(&self) -> Vec<ProfileItem> {
        self.profiles.read().clone()
    }

    /// 激活指定订阅
    pub fn select_profile(&self, id: &str) -> Result<()> {
        let mut list = self.profiles.write();
        for item in list.iter_mut() {
            item.enabled = item.id == id;
        }
        self.save_persisted_state();
        Ok(())
    }

    /// 获取应用设置
    pub fn get_settings(&self) -> AppSetting {
        self.settings.read().clone()
    }

    /// 保存应用设置
    pub fn save_settings(&self, setting: AppSetting) -> Result<()> {
        *self.settings.write() = setting;
        self.save_persisted_state();
        Ok(())
    }

    /// 订阅实时流量广播接收器
    pub fn subscribe_traffic(&self) -> broadcast::Receiver<TrafficData> {
        self.traffic_tx.subscribe()
    }

    /// 订阅实时日志广播接收器
    pub fn subscribe_logs(&self) -> broadcast::Receiver<LogMessage> {
        self.logs_tx.subscribe()
    }

    /// 订阅状态变动广播接收器
    pub fn subscribe_status(&self) -> broadcast::Receiver<ServiceStatus> {
        self.status_tx.subscribe()
    }
}
