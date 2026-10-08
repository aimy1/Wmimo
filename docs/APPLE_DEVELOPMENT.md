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
# 1. 下载全平台核心并由 lipo 自动构建 macOS Universal Binary
dart run tool/download_all_cores.dart

# 2. 生成 macOS 生产构建
flutter build macos --release

# 3. 执行原生一键打包脚本（自动嵌入核心、执行 ad-hoc 签名并生成 DMG 与 Portable Zip）
bash tool/package_macos.sh v1.2.2.1504
```

产物将输出在 `dist/` 目录：
- `dist/Wmimo-macOS-universal-v1.2.2.1504.dmg`（带 Applications 软链接的原生拖拽安装镜像）
- `dist/Wmimo-macOS-universal-v1.2.2.1504.zip`（绿色便携包，完整保留可执行权限与 SUID 标志）

### 3. CI/CD 自动化持续集成
GitHub Actions 工作流（`.github/workflows/release.yml`）已包含 `build-macos` Job，任何 Release 标签推送或手动触发均会自动在 `macos-latest` 虚拟机中编译生成 Universal DMG 与 Zip，并自动聚合计算 SHA-256 校验和上传发布。


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
- **控制中心与桌面小组件 (`wmimoWidgetExtension`)**：
  - 基于 iOS 18+ `ControlWidget` 与 iOS 16+ `AppIntent`，支持在控制中心和锁屏一键启停代理。
  - 通过 `VpnServiceHandler` 原生直接控制 `NETunnelProviderManager`。

### 2. 编译 Go 核心 (`Libclash.xcframework`)
在具有 Xcode 与 Go 环境的 macOS 设备上执行：
```bash
bash tool/build_apple_core.sh
```
该脚本将复制 `tool/apple_bridge/libclash.go` 桥接包并使用 `gomobile bind` 编译产出包含真机 (arm64) 与模拟器架构 (arm64, x86_64) 的 `bind/apple/Libclash.xcframework`。
已预置包含全架构静态库的 XCFramework，Xcode 编译与依赖校验开箱即过。

### 3. Apple 开发者证书配置要求
在真机部署与分发前，必须在 Apple Developer 门户配置：
1. **App IDs**：
   - 主应用：`com.wmimo.app`
   - 扩展：`com.wmimo.app.wmimoService`
   - 小组件：`com.wmimo.app.wmimoWidget`
2. **Entitlements 权限**：
   - 主应用、网络扩展与小组件需同时启用 **App Groups**（`group.com.wmimo.app`）。
   - 网络扩展必须勾选 **Network Extensions** -> **Packet Tunnel Provider**。
3. **Provisioning Profiles**：
   - 分别为主应用、扩展和小组件生成并配置对应的描述文件。

---

## 三、代码目录映射

| 路径 | 作用说明 |
| :--- | :--- |
| `bind/apple/LibVpnCore/` | iOS / macOS 网络扩展核心 Swift 接口层（`LibVpnCore`, `ExtensionProvider` 等） |
| `bind/apple/Libclash.xcframework` | iOS / macOS 代理核心 XCFramework 跨架构二进制库 |
| `ios/Runner/AppDelegate.swift` | iOS 原生 MethodChannel 通道与 `NETunnelProviderManager` 控制器 |
| `ios/wmimoService/` | iOS Packet Tunnel Provider 原生网络扩展工程 |
| `ios/wmimoWidget/` | iOS 控制中心快捷开关与桌面微件工程（含 `VpnServiceHandler` 控制器） |
| `macos/Runner/AppDelegate.swift` | macOS 原生窗口控制与 MethodChannel 桥接 |
| `third_party/libclash_vpn_service/` | Dart 跨平台 VPN 服务调度（包含 macOS SUID 授权与 iOS 扩展调用） |
| `tool/apple_bridge/libclash.go` | Go 语言 Mihomo 原生桥接代码 |
| `tool/build_apple_core.sh` | 自动化编译 `Libclash.xcframework` 脚本 |
| `tool/package_macos.sh` | macOS 原生一键 DMG / Zip 打包与内核嵌入脚本 |
