use tracing::info;
use wmimo_common::Result;

pub struct SysProxy;

impl SysProxy {
    /// 开启系统代理
    pub fn enable(host: &str, port: u16, bypass: Option<&str>) -> Result<()> {
        info!("正在启用系统代理 -> {}:{}", host, port);
        #[cfg(target_os = "windows")]
        {
            windows::set_windows_proxy(true, host, port, bypass)?;
        }
        #[cfg(target_os = "linux")]
        {
            linux::set_linux_proxy(true, host, port, bypass)?;
        }
        #[cfg(target_os = "macos")]
        {
            macos::set_macos_proxy(true, host, port, bypass)?;
        }
        #[cfg(not(any(target_os = "windows", target_os = "linux", target_os = "macos")))]
        {
            info!("当前平台不支持自动设置系统代理");
        }
        Ok(())
    }

    /// 关闭系统代理
    pub fn disable() -> Result<()> {
        info!("正在关闭系统代理");
        #[cfg(target_os = "windows")]
        {
            windows::set_windows_proxy(false, "", 0, None)?;
        }
        #[cfg(target_os = "linux")]
        {
            linux::set_linux_proxy(false, "", 0, None)?;
        }
        #[cfg(target_os = "macos")]
        {
            macos::set_macos_proxy(false, "", 0, None)?;
        }
        #[cfg(not(any(target_os = "windows", target_os = "linux", target_os = "macos")))]
        {
            info!("当前平台无需还原系统代理");
        }
        Ok(())
    }

    /// 检查系统代理状态
    pub fn is_enabled() -> Result<bool> {
        #[cfg(target_os = "windows")]
        {
            windows::get_windows_proxy_enabled()
        }
        #[cfg(not(target_os = "windows"))]
        {
            Ok(false)
        }
    }
}

#[cfg(target_os = "windows")]
mod windows {
    use super::*;
    use std::ffi::c_void;
    use std::ptr::null_mut;
    use winreg::enums::{HKEY_CURRENT_USER, KEY_READ, KEY_WRITE};
    use winreg::RegKey;
    use wmimo_common::WmimoError;

    const DEFAULT_BYPASS: &str = "<local>;localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*;192.168.*";

    #[link(name = "wininet")]
    extern "system" {
        fn InternetSetOptionW(
            h_internet: *mut c_void,
            dw_option: u32,
            lp_buffer: *mut c_void,
            dw_buffer_length: u32,
        ) -> i32;
    }

    const INTERNET_OPTION_SETTINGS_CHANGED: u32 = 39;
    const INTERNET_OPTION_REFRESH: u32 = 37;

    pub fn set_windows_proxy(
        enable: bool,
        host: &str,
        port: u16,
        bypass: Option<&str>,
    ) -> Result<()> {
        let hkcu = RegKey::predef(HKEY_CURRENT_USER);
        let settings_path = "Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings";
        let (key, _) = hkcu
            .create_subkey_with_flags(settings_path, KEY_WRITE)
            .map_err(|e| WmimoError::SystemProxy(format!("打开注册表失败: {}", e)))?;

        let enable_val: u32 = if enable { 1 } else { 0 };
        key.set_value("ProxyEnable", &enable_val)
            .map_err(|e| WmimoError::SystemProxy(format!("设置 ProxyEnable 失败: {}", e)))?;

        if enable {
            let proxy_server = format!("{}:{}", host, port);
            key.set_value("ProxyServer", &proxy_server)
                .map_err(|e| WmimoError::SystemProxy(format!("设置 ProxyServer 失败: {}", e)))?;

            let bypass_str = bypass.unwrap_or(DEFAULT_BYPASS);
            key.set_value("ProxyOverride", &bypass_str)
                .map_err(|e| WmimoError::SystemProxy(format!("设置 ProxyOverride 失败: {}", e)))?;
        }

        // 通知系统刷新代理设置 (WinINet)
        unsafe {
            InternetSetOptionW(null_mut(), INTERNET_OPTION_SETTINGS_CHANGED, null_mut(), 0);
            InternetSetOptionW(null_mut(), INTERNET_OPTION_REFRESH, null_mut(), 0);
        }

        Ok(())
    }

    pub fn get_windows_proxy_enabled() -> Result<bool> {
        let hkcu = RegKey::predef(HKEY_CURRENT_USER);
        let settings_path = "Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings";
        if let Ok(key) = hkcu.open_subkey_with_flags(settings_path, KEY_READ) {
            let val: u32 = key.get_value("ProxyEnable").unwrap_or(0);
            Ok(val == 1)
        } else {
            Ok(false)
        }
    }
}

#[cfg(target_os = "linux")]
mod linux {
    use super::*;
    use std::process::Command;

    pub fn set_linux_proxy(
        enable: bool,
        host: &str,
        port: u16,
        _bypass: Option<&str>,
    ) -> Result<()> {
        let mode = if enable { "manual" } else { "none" };
        let _ = Command::new("gsettings")
            .args(["set", "org.gnome.system.proxy", "mode", mode])
            .output();

        if enable {
            let _ = Command::new("gsettings")
                .args(["set", "org.gnome.system.proxy.http", "host", host])
                .output();
            let _ = Command::new("gsettings")
                .args(["set", "org.gnome.system.proxy.http", "port", &port.to_string()])
                .output();
            let _ = Command::new("gsettings")
                .args(["set", "org.gnome.system.proxy.https", "host", host])
                .output();
            let _ = Command::new("gsettings")
                .args(["set", "org.gnome.system.proxy.https", "port", &port.to_string()])
                .output();
        }
        Ok(())
    }
}

#[cfg(target_os = "macos")]
mod macos {
    use super::*;
    use std::process::Command;

    pub fn set_macos_proxy(
        enable: bool,
        host: &str,
        port: u16,
        _bypass: Option<&str>,
    ) -> Result<()> {
        let state = if enable { "on" } else { "off" };
        for net_service in ["Wi-Fi", "Ethernet"] {
            if enable {
                let _ = Command::new("networksetup")
                    .args(["-setwebproxy", net_service, host, &port.to_string()])
                    .output();
                let _ = Command::new("networksetup")
                    .args(["-setsecurewebproxy", net_service, host, &port.to_string()])
                    .output();
            }
            let _ = Command::new("networksetup")
                .args(["-setwebproxystate", net_service, state])
                .output();
            let _ = Command::new("networksetup")
                .args(["-setsecurewebproxystate", net_service, state])
                .output();
        }
        Ok(())
    }
}
