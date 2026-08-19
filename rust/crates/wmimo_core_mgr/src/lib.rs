use parking_lot::Mutex;
use std::path::{Path, PathBuf};
use std::process::Stdio;
use std::sync::Arc;
use std::time::Duration;
use tokio::process::{Child, Command};
use tracing::{error, info, warn};
use wmimo_client::MihomoClient;
use wmimo_common::{Result, WmimoError};

#[derive(Clone)]
pub struct CoreManager {
    inner: Arc<Mutex<CoreState>>,
}

struct CoreState {
    child: Option<Child>,
    client: Option<MihomoClient>,
    core_path: PathBuf,
    work_dir: PathBuf,
    config_path: Option<PathBuf>,
}

impl CoreManager {
    pub fn new(core_path: impl Into<PathBuf>, work_dir: impl Into<PathBuf>) -> Self {
        Self {
            inner: Arc::new(Mutex::new(CoreState {
                child: None,
                client: None,
                core_path: core_path.into(),
                work_dir: work_dir.into(),
                config_path: None,
            })),
        }
    }

    /// 检查并确保工作目录与必要的 Geo 数据文件存在
    pub fn ensure_work_dir(&self) -> Result<()> {
        let work_dir = {
            let state = self.inner.lock();
            state.work_dir.clone()
        };
        std::fs::create_dir_all(&work_dir)
            .map_err(|e| WmimoError::Io(format!("创建核心工作目录失败: {}", e)))?;
        Ok(())
    }

    /// 启动 Mihomo 核心子进程
    pub async fn start(
        &self,
        config_path: &Path,
        control_port: u16,
        secret: &str,
    ) -> Result<MihomoClient> {
        let (core_path, work_dir) = {
            let mut state = self.inner.lock();
            if state.child.is_some() {
                info!("检测到旧的核心实例，先进行停止");
            }
            (state.core_path.clone(), state.work_dir.clone())
        };

        // 如果旧进程存在，先停止
        let _ = self.stop().await;

        if !core_path.exists() {
            return Err(WmimoError::NotFound(format!(
                "未找到 Mihomo 内核执行文件: {:?}",
                core_path
            )));
        }

        info!(
            "正在启动 Mihomo 核心: {:?} -d {:?} -f {:?}",
            core_path, work_dir, config_path
        );

        let mut cmd = Command::new(&core_path);
        cmd.arg("-d")
            .arg(&work_dir)
            .arg("-f")
            .arg(config_path)
            .stdout(Stdio::piped())
            .stderr(Stdio::piped());

        #[cfg(target_os = "windows")]
        {
            // Windows 下隐藏控制台黑框 (CREATE_NO_WINDOW = 0x08000000)
            const CREATE_NO_WINDOW: u32 = 0x08000000;
            cmd.creation_flags(CREATE_NO_WINDOW);
        }

        let child = cmd
            .spawn()
            .map_err(|e| WmimoError::Core(format!("启动核心进程失败: {}", e)))?;

        let client = MihomoClient::new("127.0.0.1", control_port, secret);

        {
            let mut state = self.inner.lock();
            state.child = Some(child);
            state.client = Some(client.clone());
            state.config_path = Some(config_path.to_path_buf());
        }

        // 等待核心 REST API 就绪
        self.wait_for_ready(&client, Duration::from_secs(10))
            .await?;
        info!("Mihomo 核心已成功就绪并开始运行！");

        Ok(client)
    }

    /// 等待核心 API 响应
    async fn wait_for_ready(&self, client: &MihomoClient, timeout: Duration) -> Result<()> {
        let start = std::time::Instant::now();
        while start.elapsed() < timeout {
            if let Ok(version) = client.get_version().await {
                info!("探测到 Mihomo 内核版本: {}", version);
                return Ok(());
            }
            tokio::time::sleep(Duration::from_millis(200)).await;
        }
        Err(WmimoError::Core("等待核心启动超时 (REST API 未响应)".to_string()))
    }

    /// 停止核心子进程
    pub async fn stop(&self) -> Result<()> {
        let mut child = {
            let mut state = self.inner.lock();
            state.client = None;
            state.child.take()
        };

        if let Some(mut child) = child {
            info!("正在终止 Mihomo 核心进程...");
            let _ = child.kill().await;
            let _ = child.wait().await;
            info!("Mihomo 核心进程已停止");
        }

        Ok(())
    }

    /// 检查核心是否在运行
    pub fn is_running(&self) -> bool {
        let mut state = self.inner.lock();
        if let Some(ref mut child) = state.child {
            match child.try_wait() {
                Ok(None) => true,
                _ => {
                    state.child = None;
                    state.client = None;
                    false
                }
            }
        } else {
            false
        }
    }

    /// 获取当前可用的 Client
    pub fn get_client(&self) -> Option<MihomoClient> {
        self.inner.lock().client.clone()
    }
}
