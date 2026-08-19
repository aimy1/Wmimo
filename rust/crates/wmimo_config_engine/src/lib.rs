use chrono::{DateTime, TimeZone, Utc};
use reqwest::header::{HeaderMap, HeaderValue, USER_AGENT};
use serde::{Deserialize, Serialize};
use serde_yaml::{Mapping, Value};
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use tracing::{error, info, warn};
use wmimo_common::{AppSetting, ProfileItem, ProxyMode, Result, WmimoError};

/// 订阅元信息（从 Header 解析）
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct SubscriptionUserInfo {
    pub upload: u64,
    pub download: u64,
    pub total: u64,
    pub expire: Option<DateTime<Utc>>,
}

pub struct ConfigEngine {
    profiles_dir: PathBuf,
}

impl ConfigEngine {
    pub fn new(profiles_dir: impl Into<PathBuf>) -> Self {
        let dir = profiles_dir.into();
        let _ = std::fs::create_dir_all(&dir);
        Self { profiles_dir: dir }
    }

    /// 从远程 URL 下载订阅配置与元数据
    pub async fn fetch_subscription(url: &str) -> Result<(String, Option<SubscriptionUserInfo>)> {
        info!("正在拉取订阅: {}", url);
        let client = reqwest::Client::builder()
            .timeout(std::time::Duration::from_secs(30))
            .build()
            .map_err(|e| WmimoError::Network(format!("创建 HTTP 客户端失败: {}", e)))?;

        let mut headers = HeaderMap::new();
        headers.insert(
            USER_AGENT,
            HeaderValue::from_static("clash.meta/v1.18.0 Mihomo/Wmimo"),
        );

        let response = client
            .get(url)
            .headers(headers)
            .send()
            .await
            .map_err(|e| WmimoError::Network(format!("请求订阅失败: {}", e)))?;

        if !response.status().is_success() {
            return Err(WmimoError::Network(format!(
                "订阅服务器返回错误状态码: {}",
                response.status()
            )));
        }

        // 解析 subscription-userinfo 头 (upload=123; download=456; total=789; expire=1735689600)
        let user_info = response
            .headers()
            .get("subscription-userinfo")
            .and_then(|h| h.to_str().ok())
            .map(Self::parse_subscription_userinfo);

        let content = response
            .text()
            .await
            .map_err(|e| WmimoError::Network(format!("读取订阅内容失败: {}", e)))?;

        Ok((content, user_info))
    }

    /// 解析 subscription-userinfo 头
    pub fn parse_subscription_userinfo(raw_header: &str) -> SubscriptionUserInfo {
        let mut info = SubscriptionUserInfo::default();
        for part in raw_header.split(';') {
            let part = part.trim();
            if let Some((k, v)) = part.split_once('=') {
                let k = k.trim().to_lowercase();
                let v = v.trim();
                match k.as_str() {
                    "upload" => info.upload = v.parse().unwrap_or(0),
                    "download" => info.download = v.parse().unwrap_or(0),
                    "total" => info.total = v.parse().unwrap_or(0),
                    "expire" => {
                        if let Ok(ts) = v.parse::<i64>() {
                            info.expire = Utc.timestamp_opt(ts, 0).single();
                        }
                    }
                    _ => {}
                }
            }
        }
        info
    }

    /// 将原始配置与应用全局设置 (Mixin / 补丁) 合并生成最终的 Mihomo 运行配置
    pub fn build_final_config(
        raw_yaml: &str,
        setting: &AppSetting,
        custom_rules: Option<&[String]>,
    ) -> Result<String> {
        let mut doc: Value = serde_yaml::from_str(raw_yaml).unwrap_or_else(|_| {
            let mut map = Mapping::new();
            map.insert(Value::String("proxies".to_string()), Value::Sequence(vec![]));
            Value::Mapping(map)
        });

        let map = doc.as_mapping_mut().ok_or_else(|| {
            WmimoError::Config("YAML 根节点必须为 Mapping 对象".to_string())
        })?;

        // 1. 注入基础网络与控制器端口
        map.insert(
            Value::String("mixed-port".to_string()),
            Value::Number(setting.mixed_port.into()),
        );
        map.insert(
            Value::String("allow-lan".to_string()),
            Value::Bool(setting.allow_lan),
        );
        map.insert(
            Value::String("mode".to_string()),
            Value::String(match setting.mode {
                ProxyMode::Rule => "rule".to_string(),
                ProxyMode::Global => "global".to_string(),
                ProxyMode::Direct => "direct".to_string(),
            }),
        );
        map.insert(
            Value::String("log-level".to_string()),
            Value::String(setting.log_level.clone()),
        );
        map.insert(
            Value::String("external-controller".to_string()),
            Value::String(format!("127.0.0.1:{}", setting.control_port)),
        );
        if !setting.secret.is_empty() {
            map.insert(
                Value::String("secret".to_string()),
                Value::String(setting.secret.clone()),
            );
        }

        // 2. 注入 TUN 虚拟网卡配置
        let mut tun_map = Mapping::new();
        tun_map.insert(
            Value::String("enable".to_string()),
            Value::Bool(setting.tun_mode),
        );
        tun_map.insert(
            Value::String("stack".to_string()),
            Value::String("mixed".to_string()),
        );
        tun_map.insert(
            Value::String("auto-route".to_string()),
            Value::Bool(true),
        );
        tun_map.insert(
            Value::String("auto-detect-interface".to_string()),
            Value::Bool(true),
        );
        tun_map.insert(
            Value::String("dns-hijack".to_string()),
            Value::Sequence(vec![
                Value::String("any:53".to_string()),
                Value::String("tcp://any:53".to_string()),
            ]),
        );
        map.insert(Value::String("tun".to_string()), Value::Mapping(tun_map));

        // 3. 注入内置智能 DNS 与 Fake-IP 配置
        let mut dns_map = Mapping::new();
        dns_map.insert(Value::String("enable".to_string()), Value::Bool(true));
        dns_map.insert(
            Value::String("listen".to_string()),
            Value::String(format!("127.0.0.1:{}", setting.dns_listen_port)),
        );
        dns_map.insert(
            Value::String("enhanced-mode".to_string()),
            Value::String(if setting.fake_ip {
                "fake-ip".to_string()
            } else {
                "redir-host".to_string()
            }),
        );
        dns_map.insert(
            Value::String("fake-ip-range".to_string()),
            Value::String("198.18.0.1/16".to_string()),
        );
        dns_map.insert(
            Value::String("nameserver".to_string()),
            Value::Sequence(vec![
                Value::String("https://doh.pub/dns-query".to_string()),
                Value::String("https://dns.alidns.com/dns-query".to_string()),
                Value::String("223.5.5.5".to_string()),
                Value::String("119.29.29.29".to_string()),
            ]),
        );
        dns_map.insert(
            Value::String("fallback".to_string()),
            Value::Sequence(vec![
                Value::String("https://1.1.1.1/dns-query".to_string()),
                Value::String("https://8.8.8.8/dns-query".to_string()),
                Value::String("tls://8.8.4.4".to_string()),
            ]),
        );
        map.insert(Value::String("dns".to_string()), Value::Mapping(dns_map));

        // 4. 合并自定义规则
        if let Some(rules) = custom_rules {
            if !rules.is_empty() {
                let mut new_rules = vec![];
                for r in rules {
                    new_rules.push(Value::String(r.clone()));
                }
                if let Some(existing_rules) = map.get("rules").and_then(|v| v.as_sequence()) {
                    for r in existing_rules {
                        new_rules.push(r.clone());
                    }
                }
                map.insert(Value::String("rules".to_string()), Value::Sequence(new_rules));
            }
        }

        serde_yaml::to_string(&doc)
            .map_err(|e| WmimoError::Config(format!("序列化最终配置失败: {}", e)))
    }

    /// 保存配置到指定路径
    pub fn save_config_file(&self, file_name: &str, content: &str) -> Result<PathBuf> {
        let target = self.profiles_dir.join(file_name);
        std::fs::write(&target, content)
            .map_err(|e| WmimoError::Io(format!("写入配置文件失败: {}", e)))?;
        Ok(target)
    }

    /// 获取所有配置文件列表
    pub fn list_profiles(&self) -> Result<Vec<PathBuf>> {
        let mut list = Vec::new();
        if self.profiles_dir.exists() {
            for entry in std::fs::read_dir(&self.profiles_dir)? {
                let entry = entry?;
                let path = entry.path();
                if path.is_file() {
                    list.push(path);
                }
            }
        }
        Ok(list)
    }
}
