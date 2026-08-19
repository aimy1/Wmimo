use std::path::Path;
use tracing::{info, warn};
use wmimo_common::Result;

pub struct FirewallManager;

impl FirewallManager {
    /// 检查当前进程是否以管理员/特权权限运行
    pub fn is_admin() -> bool {
        #[cfg(target_os = "windows")]
        {
            windows::is_windows_admin()
        }
        #[cfg(not(target_os = "windows"))]
        {
            unsafe { libc_check_root() }
        }
    }

    /// 为程序添加防火墙放行规则
    pub fn add_app_rule(app_path: &Path, rule_name: &str) -> Result<()> {
        #[cfg(target_os = "windows")]
        {
            windows::add_firewall_app(app_path, rule_name)
        }
        #[cfg(not(target_os = "windows"))]
        {
            let _ = (app_path, rule_name);
            Ok(())
        }
    }

    /// 为端口添加防火墙放行规则
    pub fn add_port_rules(ports: &[u16], rule_name: &str) -> Result<()> {
        #[cfg(target_os = "windows")]
        {
            windows::add_firewall_ports(ports, rule_name)
        }
        #[cfg(not(target_os = "windows"))]
        {
            let _ = (ports, rule_name);
            Ok(())
        }
    }
}

#[cfg(not(target_os = "windows"))]
unsafe fn libc_check_root() -> bool {
    #[cfg(unix)]
    {
        libc::geteuid() == 0
    }
    #[cfg(not(unix))]
    {
        false
    }
}

#[cfg(target_os = "windows")]
mod windows {
    use super::*;
    use std::process::Command;
    use wmimo_common::WmimoError;

    pub fn is_windows_admin() -> bool {
        // 使用 net session 命令快速测试管理员权限
        let output = Command::new("cmd")
            .args(["/c", "net session >nul 2>&1"])
            .status();
        matches!(output, Ok(status) if status.success())
    }

    pub fn add_firewall_app(app_path: &Path, rule_name: &str) -> Result<()> {
        let path_str = app_path.to_string_lossy();
        info!("正在添加 Windows 防火墙应用规则: {} -> {}", rule_name, path_str);

        // netsh advfirewall firewall add rule name="Wmimo" dir=in action=allow program="C:\path\to\exe" enable=yes
        let status = Command::new("netsh")
            .args([
                "advfirewall",
                "firewall",
                "add",
                "rule",
                &format!("name={}", rule_name),
                "dir=in",
                "action=allow",
                &format!("program={}", path_str),
                "enable=yes",
            ])
            .status();

        match status {
            Ok(s) if s.success() => Ok(()),
            Ok(_) => {
                warn!("添加防火墙应用规则返回非零状态码 (可能已存在或缺少权限)");
                Ok(())
            }
            Err(e) => Err(WmimoError::SystemProxy(format!("执行 netsh 失败: {}", e))),
        }
    }

    pub fn add_firewall_ports(ports: &[u16], rule_name: &str) -> Result<()> {
        if ports.is_empty() {
            return Ok(());
        }
        let port_str = ports
            .iter()
            .map(|p| p.to_string())
            .collect::<Vec<_>>()
            .join(",");

        info!("正在添加 Windows 防火墙端口规则: {} -> TCP/UDP {}", rule_name, port_str);

        // TCP
        let _ = Command::new("netsh")
            .args([
                "advfirewall",
                "firewall",
                "add",
                "rule",
                &format!("name={} TCP", rule_name),
                "dir=in",
                "action=allow",
                "protocol=TCP",
                &format!("localport={}", port_str),
            ])
            .status();

        // UDP
        let _ = Command::new("netsh")
            .args([
                "advfirewall",
                "firewall",
                "add",
                "rule",
                &format!("name={} UDP", rule_name),
                "dir=in",
                "action=allow",
                "protocol=UDP",
                &format!("localport={}", port_str),
            ])
            .status();

        Ok(())
    }
}
