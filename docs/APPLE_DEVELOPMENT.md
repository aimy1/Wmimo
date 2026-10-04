# Apple (macOS & iOS) 适配与开发指南

本文档记录 Wmimo 在 macOS 与 iOS 平台的架构设计、底层机制及构建部署流程。

---

## 一、macOS 平台架构与使用

### 1. 运行机制
- **系统代理模式 (System Proxy)**：
  - 基于 macOS 原生 `networksetup` 命令，由应用主进程自动管理 HTTP、HTTPS、SOCKS5 代理和局域网绕过列表。
  - 普通权限即可运行，退出应用或切换模式时自动重置网络设置。
- **TUN 虚拟网卡模式 (TUN Mode)**：
  - Mihomo 核心通过创建 `utun` 设备实现全局流量接管。由于 macOS 内核限制，创建虚拟网卡需要特权（UID 0 / SUID）。
  - **提权与授权方案**：
    - 应用内置了 `isServiceAuthorized` 检查内核二进制文件的所有者与 SUID 权限标志位。
    - 当用户启用 TUN 模式且未授权时，应用会调用 `FlutterVpnService.authorizeService()`：
      - 优先执行原生 AppleScript 提权：`osascript -e 'do shell script "chown root:admin \"...\" && chmod +sx \"...\"" with administrator privileges'`
      - 触发 macOS 系统原生授权弹窗（支持 **Touch ID** 或管理员密码）。
      - 一次性赋予核心 SUID (`4755`) 权限后，后续启动 TUN 模式全程免密透明运行。

### 2. 构建与打包
```bash
# 生成 macOS 运行构建
flutter build macos --release

# 打包 DMG 安装镜像
dart run appdmg:make macos/packaging/dmg/appdmg_make_config.json dist/Wmimo-macOS.dmg
```

---

## 二、iOS 平台架构与构建

### 1. 架构概览
iOS 系统严格禁止子进程派生（`fork` / `exec` / `Process.start`），网络代理必须通过苹果 **Network Extension** 体系实现：
- **主应用 (Flutter Runner)**：负责 UI 展示、节点与订阅管理、规则配置。
- **Packet Tunnel 扩展 (wmimoService)**：独立的系统扩展进程（`NEPacketTunnelProvider`），接管系统数据流。
- **App Group (`group.com.wmimo.app`)**：主应用与扩展进程共享沙盒目录，用于同步配置文件和数据库。
- **通信桥梁 (`com.wmimo.app/native_helper`)**：
  - Flutter 通过 MethodChannel 调用 iOS 原生 `AppDelegate.swift`。
  - 原生层通过 `NETunnelProviderManager` 管理扩展的安装、授权弹窗、启动与停止。

### 2. 编译 Go 核心 (`Libclash.xcframework`)
在具有 Xcode 与 Go 环境的 macOS 设备上执行：
```bash
bash tool/build_apple_core.sh
```
该脚本将通过 `gomobile bind` 产出包含真机 (arm64) 与模拟器架构的 `bind/apple/Libclash.xcframework`。

### 3. Apple 开发者证书配置要求
在真机部署与分发前，必须在 Apple Developer 门户配置：
1. **App IDs**：
   - 主应用：`com.wmimo.app`
   - 扩展：`com.wmimo.app.wmimoService`
2. **Entitlements 权限**：
   - 主应用与扩展需同时启用 **App Groups**（`group.com.wmimo.app`）。
   - 必须勾选 **Network Extensions** -> **Packet Tunnel Provider**。
3. **Provisioning Profiles**：
   - 分别为主应用和扩展生成并下载对应的描述文件。

---

## 三、代码目录映射

| 路径 | 作用说明 |
| :--- | :--- |
| `bind/apple/LibVpnCore/` | iOS / macOS 网络扩展核心 Swift 接口层（`LibVpnCore`, `ExtensionProvider` 等） |
| `ios/Runner/AppDelegate.swift` | iOS 原生 MethodChannel 通道与 `NETunnelProviderManager` 控制器 |
| `ios/wmimoService/` | iOS Packet Tunnel Provider 原生工程 |
| `macos/Runner/AppDelegate.swift` | macOS 原生窗口控制与 MethodChannel 桥接 |
| `third_party/libclash_vpn_service/` | Dart 跨平台 VPN 服务调度（包含 macOS SUID 授权与 iOS 扩展调用） |
| `tool/build_apple_core.sh` | 自动化编译 `Libclash.xcframework` 脚本 |
