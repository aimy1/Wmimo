use chrono::Utc;
use futures_util::{SinkExt, StreamExt};
use reqwest::header::{HeaderMap, HeaderValue, AUTHORIZATION};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::collections::HashMap;
use std::sync::Arc;
use tokio::sync::broadcast;
use tokio_tungstenite::connect_async;
use tokio_tungstenite::tungstenite::client::IntoClientRequest;
use tracing::{error, info, warn};
use url::Url;
use wmimo_common::{
    ConnectionSnapshot, LogMessage, MemoryData, ProxyNode, Result, TrafficData, WmimoError,
};

#[derive(Clone)]
pub struct MihomoClient {
    base_url: String,
    secret: String,
    http_client: reqwest::Client,
}

impl MihomoClient {
    pub fn new(host: &str, port: u16, secret: &str) -> Self {
        let base_url = format!("http://{}:{}", host, port);
        let http_client = reqwest::Client::builder()
            .timeout(std::time::Duration::from_secs(10))
            .build()
            .unwrap_or_default();

        Self {
            base_url,
            secret: secret.to_string(),
            http_client,
        }
    }

    fn auth_headers(&self) -> HeaderMap {
        let mut headers = HeaderMap::new();
        if !self.secret.is_empty() {
            if let Ok(val) = HeaderValue::from_str(&format!("Bearer {}", self.secret)) {
                headers.insert(AUTHORIZATION, val);
            }
        }
        headers
    }

    /// 获取 Mihomo 版本号
    pub async fn get_version(&self) -> Result<String> {
        let url = format!("{}/version", self.base_url);
        let res: Value = self
            .http_client
            .get(&url)
            .headers(self.auth_headers())
            .send()
            .await
            .map_err(|e| WmimoError::Network(format!("获取版本失败: {}", e)))?
            .json()
            .await
            .map_err(|e| WmimoError::Serialization(e.to_string()))?;

        Ok(res["version"].as_str().unwrap_or("unknown").to_string())
    }

    /// 热加载/更新运行配置
    pub async fn reload_config(&self, config_path: &str) -> Result<()> {
        let url = format!("{}/configs?force=true", self.base_url);
        let body = serde_json::json!({ "path": config_path });

        let res = self
            .http_client
            .put(&url)
            .headers(self.auth_headers())
            .json(&body)
            .send()
            .await
            .map_err(|e| WmimoError::Network(format!("重载配置失败: {}", e)))?;

        if !res.status().is_success() {
            let err_text = res.text().await.unwrap_or_default();
            return Err(WmimoError::Core(format!("内核重载配置失败: {}", err_text)));
        }

        info!("Mihomo 核心配置已成功热重载 -> {}", config_path);
        Ok(())
    }

    /// 获取所有代理节点与策略组列表
    pub async fn get_proxies(&self) -> Result<HashMap<String, ProxyNode>> {
        let url = format!("{}/proxies", self.base_url);
        let res: Value = self
            .http_client
            .get(&url)
            .headers(self.auth_headers())
            .send()
            .await
            .map_err(|e| WmimoError::Network(format!("获取代理列表失败: {}", e)))?
            .json()
            .await
            .map_err(|e| WmimoError::Serialization(e.to_string()))?;

        let proxies_map = res["proxies"].as_object().ok_or_else(|| {
            WmimoError::Serialization("返回格式缺少 proxies 字段".to_string())
        })?;

        let mut result = HashMap::new();
        for (name, item) in proxies_map {
            if let Ok(node) = serde_json::from_value::<ProxyNode>(item.clone()) {
                result.insert(name.clone(), node);
            }
        }

        Ok(result)
    }

    /// 切换策略组选中的节点
    pub async fn select_proxy(&self, group_name: &str, target_proxy_name: &str) -> Result<()> {
        let url = format!(
            "{}/proxies/{}",
            self.base_url,
            urlencoding::encode(group_name)
        );
        let body = serde_json::json!({ "name": target_proxy_name });

        let res = self
            .http_client
            .put(&url)
            .headers(self.auth_headers())
            .json(&body)
            .send()
            .await
            .map_err(|e| WmimoError::Network(format!("切换节点失败: {}", e)))?;

        if !res.status().is_success() {
            let err_text = res.text().await.unwrap_or_default();
            return Err(WmimoError::Core(format!("切换节点错误: {}", err_text)));
        }

        info!("策略组 [{}] 已切换至 -> [{}]", group_name, target_proxy_name);
        Ok(())
    }

    /// 对指定节点进行延迟测速 (Ping)
    pub async fn test_proxy_delay(
        &self,
        proxy_name: &str,
        test_url: Option<&str>,
        timeout_ms: Option<u32>,
    ) -> Result<u16> {
        let test_url = test_url.unwrap_or("http://www.gstatic.com/generate_204");
        let timeout = timeout_ms.unwrap_or(5000);

        let url = format!(
            "{}/proxies/{}/delay?url={}&timeout={}",
            self.base_url,
            urlencoding::encode(proxy_name),
            urlencoding::encode(test_url),
            timeout
        );

        let res: Value = self
            .http_client
            .get(&url)
            .headers(self.auth_headers())
            .send()
            .await
            .map_err(|e| WmimoError::Network(format!("测速请求失败: {}", e)))?
            .json()
            .await
            .map_err(|e| WmimoError::Serialization(e.to_string()))?;

        let delay = res["delay"]
            .as_u64()
            .ok_or_else(|| WmimoError::Core("测速超时或节点无响应".to_string()))?;

        Ok(delay as u16)
    }

    /// 获取当前所有活跃连接快照
    pub async fn get_connections(&self) -> Result<ConnectionSnapshot> {
        let url = format!("{}/connections", self.base_url);
        let snapshot: ConnectionSnapshot = self
            .http_client
            .get(&url)
            .headers(self.auth_headers())
            .send()
            .await
            .map_err(|e| WmimoError::Network(format!("获取连接快照失败: {}", e)))?
            .json()
            .await
            .map_err(|e| WmimoError::Serialization(e.to_string()))?;

        Ok(snapshot)
    }

    /// 关闭单个连接
    pub async fn close_connection(&self, id: &str) -> Result<()> {
        let url = format!("{}/connections/{}", self.base_url, id);
        let _ = self
            .http_client
            .delete(&url)
            .headers(self.auth_headers())
            .send()
            .await
            .map_err(|e| WmimoError::Network(format!("关闭连接失败: {}", e)))?;
        Ok(())
    }

    /// 关闭全部活跃连接
    pub async fn close_all_connections(&self) -> Result<()> {
        let url = format!("{}/connections", self.base_url);
        let _ = self
            .http_client
            .delete(&url)
            .headers(self.auth_headers())
            .send()
            .await
            .map_err(|e| WmimoError::Network(format!("清空连接失败: {}", e)))?;
        Ok(())
    }

    /// 启动实时流量监听通道 (WebSocket -> broadcast Sender)
    pub fn start_traffic_stream(&self, tx: broadcast::Sender<TrafficData>) {
        let ws_url = self.base_url.replace("http://", "ws://") + "/traffic";
        let secret = self.secret.clone();

        tokio::spawn(async move {
            loop {
                info!("正在连接 Mihomo 流量 WebSocket: {}", ws_url);
                if let Ok(mut req) = ws_url.clone().into_client_request() {
                    if !secret.is_empty() {
                        req.headers_mut().insert(
                            "Authorization",
                            HeaderValue::from_str(&format!("Bearer {}", secret)).unwrap(),
                        );
                    }

                    if let Ok((mut ws_stream, _)) = connect_async(req).await {
                        info!("Mihomo 流量 WebSocket 连接已建立");
                        while let Some(msg_res) = ws_stream.next().await {
                            if let Ok(msg) = msg_res {
                                if let Ok(text) = msg.to_text() {
                                    if let Ok(traffic) = serde_json::from_str::<TrafficData>(text) {
                                        let _ = tx.send(traffic);
                                    }
                                }
                            } else {
                                break;
                            }
                        }
                    }
                }
                tokio::time::sleep(std::time::Duration::from_secs(2)).await;
            }
        });
    }

    /// 启动实时日志监听通道 (WebSocket -> broadcast Sender)
    pub fn start_logs_stream(&self, tx: broadcast::Sender<LogMessage>, log_level: &str) {
        let ws_url = format!(
            "{}/logs?level={}",
            self.base_url.replace("http://", "ws://"),
            log_level
        );
        let secret = self.secret.clone();

        tokio::spawn(async move {
            loop {
                info!("正在连接 Mihomo 日志 WebSocket: {}", ws_url);
                if let Ok(mut req) = ws_url.clone().into_client_request() {
                    if !secret.is_empty() {
                        req.headers_mut().insert(
                            "Authorization",
                            HeaderValue::from_str(&format!("Bearer {}", secret)).unwrap(),
                        );
                    }

                    if let Ok((mut ws_stream, _)) = connect_async(req).await {
                        info!("Mihomo 日志 WebSocket 连接已建立");
                        while let Some(msg_res) = ws_stream.next().await {
                            if let Ok(msg) = msg_res {
                                if let Ok(text) = msg.to_text() {
                                    if let Ok(mut log_item) = serde_json::from_str::<LogMessage>(text) {
                                        log_item.time = Utc::now();
                                        let _ = tx.send(log_item);
                                    }
                                }
                            } else {
                                break;
                            }
                        }
                    }
                }
                tokio::time::sleep(std::time::Duration::from_secs(3)).await;
            }
        });
    }
}

mod urlencoding {
    pub fn encode(s: &str) -> String {
        url::form_urlencoded::byte_serialize(s.as_bytes()).collect()
    }
}
