use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use thiserror::Error;

/// 全局错误类型
#[derive(Error, Debug, Serialize, Deserialize)]
pub enum WmimoError {
    #[error("IO 错误: {0}")]
    Io(String),

    #[error("序列化/反序列化错误: {0}")]
    Serialization(String),

    #[error("网络请求错误: {0}")]
    Network(String),

    #[error("Mihomo 核心错误: {0}")]
    Core(String),

    #[error("系统代理错误: {0}")]
    SystemProxy(String),

    #[error("配置错误: {0}")]
    Config(String),

    #[error("未找到对应资源: {0}")]
    NotFound(String),

    #[error("权限不足: {0}")]
    PermissionDenied(String),

    #[error("通用错误: {0}")]
    Custom(String),
}

impl From<std::io::Error> for WmimoError {
    fn from(err: std::io::Error) -> Self {
        WmimoError::Io(err.to_string())
    }
}

pub type Result<T> = std::result::Result<T, WmimoError>;

/// 代理运行模式
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, Default)]
#[serde(rename_all = "lowercase")]
pub enum ProxyMode {
    #[default]
    Rule,
    Global,
    Direct,
}

/// 服务运行状态
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, Default)]
#[serde(rename_all = "snake_case")]
pub enum TunnelState {
    #[default]
    Disconnected,
    Connecting,
    Connected,
    Disconnecting,
    Error,
}

/// 实时流量数据
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, Default)]
pub struct TrafficData {
    pub up: u64,
    pub down: u64,
}

/// 内存使用数据
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, Default)]
pub struct MemoryData {
    pub inuse: u64,
    pub oslimit: u64,
}

/// 实时日志消息
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LogMessage {
    #[serde(rename = "type")]
    pub log_type: String,
    pub payload: String,
    pub time: DateTime<Utc>,
}

/// 连接元信息
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct ConnectionMetadata {
    pub network: String,
    #[serde(rename = "type")]
    pub type_name: String,
    #[serde(rename = "sourceIP")]
    pub source_ip: String,
    #[serde(rename = "sourcePort")]
    pub source_port: String,
    #[serde(rename = "destinationIP")]
    pub destination_ip: String,
    #[serde(rename = "destinationPort")]
    pub destination_port: String,
    pub host: String,
    #[serde(rename = "processPath", default)]
    pub process_path: String,
    #[serde(default)]
    pub dns_mode: String,
}

/// 活跃连接信息
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ConnectionInfo {
    pub id: String,
    pub metadata: ConnectionMetadata,
    pub upload: u64,
    pub download: u64,
    pub start: DateTime<Utc>,
    pub chains: Vec<String>,
    pub rule: String,
    #[serde(rename = "rulePayload", default)]
    pub rule_payload: String,
}

/// 活跃连接响应集合
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct ConnectionSnapshot {
    #[serde(rename = "downloadTotal")]
    pub download_total: u64,
    #[serde(rename = "uploadTotal")]
    pub upload_total: u64,
    pub connections: Vec<ConnectionInfo>,
}

/// 节点延迟历史
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DelayHistory {
    pub time: DateTime<Utc>,
    pub delay: u16,
}

/// 代理节点 / 策略组信息
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProxyNode {
    pub name: String,
    #[serde(rename = "type")]
    pub proxy_type: String,
    pub delay: Option<u16>,
    pub alive: bool,
    pub udp: bool,
    #[serde(default)]
    pub history: Vec<DelayHistory>,
    #[serde(default)]
    pub all: Option<Vec<String>>,
    pub now: Option<String>,
}

/// 订阅配置项
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProfileItem {
    pub id: String,
    pub name: String,
    pub url: Option<String>,
    pub file_name: String,
    pub updated_at: DateTime<Utc>,
    pub total_traffic: Option<u64>,
    pub used_traffic: Option<u64>,
    pub expire_time: Option<DateTime<Utc>>,
    pub auto_update_interval_minutes: u32,
    pub enabled: bool,
}

/// 应用设置项
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AppSetting {
    pub auto_start: bool,
    pub silent_start: bool,
    pub system_proxy: bool,
    pub tun_mode: bool,
    pub mixed_port: u16,
    pub control_port: u16,
    pub secret: String,
    pub allow_lan: bool,
    pub log_level: String,
    pub mode: ProxyMode,
    pub dns_listen_port: u16,
    pub fake_ip: bool,
}

impl Default for AppSetting {
    fn default() -> Self {
        Self {
            auto_start: false,
            silent_start: false,
            system_proxy: true,
            tun_mode: false,
            mixed_port: 7890,
            control_port: 9090,
            secret: "".to_string(),
            allow_lan: false,
            log_level: "info".to_string(),
            mode: ProxyMode::Rule,
            dns_listen_port: 1053,
            fake_ip: true,
        }
    }
}

/// 全局服务状态快照
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ServiceStatus {
    pub state: TunnelState,
    pub current_profile_id: Option<String>,
    pub mode: ProxyMode,
    pub system_proxy_enabled: bool,
    pub tun_enabled: bool,
    pub traffic: TrafficData,
    pub memory: MemoryData,
    pub active_connections_count: usize,
    pub error: Option<String>,
}

impl Default for ServiceStatus {
    fn default() -> Self {
        Self {
            state: TunnelState::Disconnected,
            current_profile_id: None,
            mode: ProxyMode::Rule,
            system_proxy_enabled: false,
            tun_enabled: false,
            traffic: TrafficData::default(),
            memory: MemoryData::default(),
            active_connections_count: 0,
            error: None,
        }
    }
}
