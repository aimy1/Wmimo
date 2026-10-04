# Wmimo macOS 与 iOS 端完善及编译部署详细教程

> **适用项目**：Wmimo (基于 Flutter + Mihomo/Clash 核心的跨平台代理客户端)  
> **文档版本**：v1.0  
> **编写日期**：2026-10-04  
> **编写目的**：为开发者与进阶用户提供从源码到成品、在 macOS 与 iOS 平台打通完整运行与自动化打包的保姆级指引。

---

## 目录
- [一、全局架构与两端现状概览](#一全局架构与两端现状概览)
- [二、macOS 端完善实战](#二macos-端完善实战)
  - [1. macOS 本地编译与直接运行](#1-macos-本地编译与直接运行)
  - [2. TUN 虚拟网卡模式提权使用机制](#2-tun-虚拟网卡模式提权使用机制)
  - [3. 本地打包输出 DMG 安装镜像](#3-本地打包输出-dmg-安装镜像)
  - [4. 配置 GitHub Actions 云端全自动打包 DMG](#4-配置-github-actions-云端全自动打包-dmg)
- [三、iOS 端完善实战（攻坚全流程）](#三ios-端完善实战攻坚全流程)
  - [1. iOS 运行机制与核心阻碍](#1-ios-运行机制与核心阻碍)
  - [2. 环境准备](#2-环境准备)
  - [3. 步骤一：编译 Go 核心静态框架 (Libclash.xcframework)](#3-步骤一编译-go-核心静态框架-libclashxcframework)
  - [4. 步骤二：打通 Swift 扩展与核心数据通信](#4-步骤二打通-swift-扩展与核心数据通信)
  - [5. 步骤三：Apple 开发者证书与 Entitlements 签名配置](#5-步骤三apple-开发者证书与-entitlements-签名配置)
  - [6. 步骤四：无 99 美元账号的替代方案 (TrollStore / 免费个人签)](#6-步骤四无-99-美元账号的替代方案-trollstore--免费个人签)
  - [7. 步骤五：iPhone 真机联调与部署](#7-步骤五iphone-真机联调与部署)
- [四、常见问题排查 (Troubleshooting)](#四常见问题排查-troubleshooting)

---

## 一、全局架构与两端现状概览

### 1. 两端核心机制对比

| 平台 | 核心运行形态 | 代理机制 | 现状评估 |
| :--- | :--- | :--- | :--- |
| **macOS** | 独立子进程 (`wmimoService` 二进制) | 1. 系统代理：`networksetup`<br>2. 全局 TUN：`utun` 接口 + SUID 提权 | **代码与二进制已 100% 具备，开箱即用** |
| **iOS** | 系统网络扩展进程 (`wmimoService.appex`) | 苹果 `NetworkExtension` (`NEPacketTunnelProvider`) | **架构与通道已打通，需补全 Go 静态库与签名** |

### 2. 关联代码文件地图

```text
Wmimo-main/
├── bind/
│   ├── macos/core/wmimoService          # macOS 内核可执行二进制 (amd64 / arm64)
│   └── apple/
│       ├── Libclash.xcframework         # [待编译] iOS/macOS 静态 Go 核心
│       └── LibVpnCore/                  # Apple 扩展层 Swift 核心源码 (已就绪)
│           ├── LibVpnCore.swift         # 核心单例与事件状态机
│           ├── ExtensionProvider.swift  # NEPacketTunnelProvider 基础扩展类
│           ├── ExtensionPlatformInterface.swift # 虚拟网卡路由/DNS 设置接口
│           └── Extension+RunBlocking.swift      # 异步阻塞工具
├── macos/                               # macOS 原生工程 (窗口、Dock、托盘已就绪)
├── ios/                                 # iOS 原生工程
│   ├── Runner/AppDelegate.swift         # iOS MethodChannel 通信与 VPN 管理器 (已就绪)
│   └── wmimoService/                    # Packet Tunnel Provider 原生工程模板
├── tool/
│   ├── build_apple_core.sh              # 编译 Libclash.xcframework 自动化脚本
│   └── download_all_cores.dart          # 桌面端全平台核心自动下载工具
└── .github/workflows/release.yml        # GitHub Actions 自动化发布流程
```

---

## 二、macOS 端完善实战

macOS 端开发代码已完全打通，无需编写任何额外功能代码，只需了解本地运行、打包及配置 CI。

### 1. macOS 本地编译与直接运行

在任何一台安装了 **Flutter SDK** 和 **Xcode** 的 Mac 电脑上执行：

```bash
# 1. 进入项目根目录
cd Wmimo-main

# 2. 安装 Dart 依赖并生成多语言文件
flutter pub get
dart run slang

# 3. 确保本地核心就位 (自动下载 Universal 架构核心)
dart run tool/download_all_cores.dart

# 4. 直接以 Debug 模式启动 macOS 客户端
flutter run -d macos

# 5. 或编译为 Release 独立应用程序
flutter build macos --release
```
编译成功后的成品为：  
`build/macos/Build/Products/Release/Wmimo.app`，直接拖入系统的“应用程序 (Applications)”目录即可使用。

---

### 2. TUN 虚拟网卡模式提权使用机制

在 macOS 上：
- **普通系统代理模式**：直接点击连接即可，无需管理员密码，软件通过 `networksetup` 自动配置并清理 HTTP/HTTPS/SOCKS5 代理。
- **开启 TUN 模式**：
  1. 在软件设置中打开“TUN 模式”；
  2. 点击主界面“启动”连接；
  3. 软件内部的 `isServiceAuthorized` 会检测内核所有权；如尚未提权，会自动通过系统 AppleScript 弹出 macOS 官方授权框：  
     > **“Wmimo 想要进行更改。输入管理员密码，或使用 Touch ID 指纹确认。”**
  4. 验证成功后，软件自动执行 `chown root:admin` 和 `chmod +sx`（设置 SUID 特权），底层 `utun` 网卡立刻创建成功；
  5. **后续使用全程免密**，无需重复输入密码。

---

### 3. 本地打包输出 DMG 安装镜像

如果想在 Mac 本地打包一个漂亮的 `.dmg` 安装镜像供其他 Mac 用户下载：

```bash
# 全局安装打包工具 appdmg
npm install --global appdmg

# 执行打包命令 (使用工程内置的样式配置文件)
mkdir -p dist
appdmg macos/packaging/dmg/appdmg_make_config.json dist/Wmimo-macOS.dmg
```
产出的 `dist/Wmimo-macOS.dmg` 带有拖拽安装到 `/Applications` 的引导背景窗口。

---

### 4. 配置 GitHub Actions 云端全自动打包 DMG

如果您自己没有 Mac 电脑，或者希望每次打 tag 发布时由 **GitHub 免费提供的云端 macOS 服务器** 自动打包 `.dmg`，请按以下步骤操作：

编辑 [`.github/workflows/release.yml`](file:///C:/Users/win/Desktop/Wmimo-main/.github/workflows/release.yml)：

#### 步骤 1：在 `jobs:` 下添加 `build-macos` 任务
在 `build-android:` 任务下方追加以下内容：

```yaml
  build-macos:
    name: Build macOS Release (Universal DMG)
    runs-on: macos-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          submodules: true
          fetch-depth: 0

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Install Dependencies
        run: |
          flutter pub get
          dart run slang

      - name: Download Multiplatform Mihomo Cores
        run: dart run tool/download_all_cores.dart

      - name: Build macOS Application
        run: flutter build macos --release

      - name: Package DMG Installer
        run: |
          mkdir -p dist
          npm install --global appdmg
          appdmg macos/packaging/dmg/appdmg_make_config.json dist/Wmimo-macOS.dmg

      - name: Upload macOS Artifact
        uses: actions/upload-artifact@v4
        with:
          name: macos-dist
          path: dist/Wmimo-macOS.dmg
```

#### 步骤 2：在 `publish-release:` 任务中关联 `build-macos`
找到 `publish-release:` 任务的 `needs:`，修改为：
```yaml
  publish-release:
    name: Publish GitHub Release
    needs: [build-windows, build-linux, build-android, build-macos]
    runs-on: ubuntu-latest
```

> **效果**：完成修改推送到 GitHub 后，每次推送 Tag（如 `v1.1.11`），GitHub Actions 就会自动生成 Windows、Linux、Android 和 **macOS DMG** 全套 4 端安装包！

---

## 三、iOS 端完善实战（攻坚全流程）

---

### 1. iOS 运行机制与核心阻碍

- **严格的沙盒限制**：iOS 绝对不允许调用 `Process.start`、`fork` 或独立运行二进制程序。
- **独立扩展进程**：代理流量必须通过苹果专属的 **NetworkExtension (Packet Tunnel)** 运行在单独的 `wmimoService.appex` 扩展中。
- **核心形态要求**：Mihomo Go 源码必须被编译为 iOS 原生静态库（`Libclash.xcframework`），并通过 C-ABI 或 Swift 绑定导入扩展进程中执行。

---

### 2. 环境准备

编译 iOS 必须具备：
1. 一台运行 macOS 的电脑（M1/M2/M3 或 Intel）；
2. 安装 Xcode（建议 15.0 或更新版本）；
3. 安装 Go 环境（Go 1.21 或更新版本）：
   ```bash
   brew install go
   ```
4. 安装 Go Mobile 交叉编译工具：
   ```bash
   go install golang.org/x/mobile/cmd/gomobile@latest
   go install golang.org/x/mobile/cmd/gobind@latest
   export PATH="$(go env GOPATH)/bin:${PATH}"
   gomobile init
   ```

---

### 3. 步骤一：编译 Go 核心静态框架 (Libclash.xcframework)

仓库中已经为您内置了自动化编译脚本 [`tool/build_apple_core.sh`](file:///C:/Users/win/Desktop/Wmimo-main/tool/build_apple_core.sh)。在 Mac 终端中运行：

```bash
cd Wmimo-main
chmod +x tool/build_apple_core.sh
./tool/build_apple_core.sh
```

**脚本内部执行的实质逻辑**：
1. 自动拉取 Mihomo 源码；
2. 执行 `gomobile bind`：
   ```bash
   gomobile bind \
     -target=ios,iossimulator,macos \
     -bundleid=com.wmimo.app.libclash \
     -ldflags="-s -w" \
     -o bind/apple/Libclash.xcframework \
     .
   ```
3. 编译完成后，`bind/apple/Libclash.xcframework` 将生成就绪。

---

### 4. 步骤二：打通 Swift 扩展与核心数据通信

打开 [`bind/apple/LibVpnCore/ExtensionProvider.swift`](file:///C:/Users/win/Desktop/Wmimo-main/bind/apple/LibVpnCore/ExtensionProvider.swift)，完善在系统扩展启动时调用 Go 核心的入口：

```swift
import Foundation
import NetworkExtension
import Libclash // 导入步骤一生成的 Libclash.xcframework
import os.log

open class ExtensionProvider: NEPacketTunnelProvider {
    private let log = OSLog(subsystem: "com.wmimo.app.wmimoService", category: "ExtensionProvider")
    private var isCoreRunning = false

    open override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        os_log("PacketTunnelProvider: startTunnel invoked", log: log, type: .info)

        // 1. 设置 TUN 虚拟网卡属性 (虚拟 IP、子网掩码、路由表)
        let platformHelper = DefaultExtensionPlatform()
        let tunnelSettings = platformHelper.setupTunnelNetworkSettings(tunnelRemoteAddress: "198.18.0.1", mtu: 9000)
        platformHelper.configureDns(settings: tunnelSettings, servers: ["198.18.0.2", "1.1.1.1", "8.8.8.8"])

        // 2. 将配置应用到 iOS 系统网络栈
        setTunnelNetworkSettings(tunnelSettings) { [weak self] error in
            if let error = error {
                os_log("Failed to set tunnel network settings: %{public}@", log: self?.log ?? .default, type: .error, error.localizedDescription)
                completionHandler(error)
                return
            }

            // 3. 从 App Group 共享沙盒中读取主 App 写入的 config.json
            guard let groupDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.wmimo.app") else {
                os_log("Cannot access App Group directory", log: self?.log ?? .default, type: .error)
                completionHandler(nil)
                return
            }
            let sharedConfigFile = groupDir.appendingPathComponent("config.json").path

            // 4. 在后台线程启动 Libclash 核心
            DispatchQueue.global(qos: .userInitiated).async {
                // 调用 Go 核心启动函数 (由 Libclash.xcframework 导出)
                LibclashStart(sharedConfigFile)
                self?.isCoreRunning = true
                os_log("Libclash Core started successfully", log: self?.log ?? .default, type: .info)
            }

            LibVpnCore.shared.updateState(.connected)
            completionHandler(nil)
        }
    }

    open override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        os_log("PacketTunnelProvider: stopTunnel invoked", log: log, type: .info)
        if isCoreRunning {
            LibclashStop() // 停止 Go 核心
            isCoreRunning = false
        }
        LibVpnCore.shared.updateState(.disconnected)
        completionHandler()
    }
}
```

---

### 5. 步骤三：Apple 开发者证书与 Entitlements 签名配置

#### 1. 登录 Apple Developer 门户 (developer.apple.com)
在 **Certificates, Identifiers & Profiles** 中配置两个 App ID：

1. **主应用 App ID**：`com.wmimo.app`
   - Capabilities 勾选：
     - ✅ **App Groups**（添加并绑定 `group.com.wmimo.app`）
     - ✅ **Network Extensions** -> 勾选 `Packet Tunnel Provider`
2. **扩展 App ID**：`com.wmimo.app.wmimoService`
   - Capabilities 勾选：
     - ✅ **App Groups**（同样绑定 `group.com.wmimo.app`）
     - ✅ **Network Extensions** -> 勾选 `Packet Tunnel Provider`

#### 2. 打开 Xcode 配置工程签名
在 Mac 终端中运行：
```bash
open ios/Runner.xcworkspace
```
1. 点击左侧根节点 **Runner** 项目；
2. 选择 **Runner** Target：
   - 进入 **Signing & Capabilities**；
   - 勾选 **Automatically manage signing**；
   - **Team** 选择您的开发者团队；
   - 检查 **App Groups** 和 **Network Extensions** 是否全部显示为正常（无红色感叹号）。
3. 选择 **wmimoService** Target：
   - 重复上述签名配置，确保 Team 与描述文件对应。

---

### 6. 步骤四：无 99 美元账号的替代方案 (TrollStore / 免费个人签)

如果您不想支付每年 99 美元的苹果开发者年费，社区有两个成熟的替代玩法：

#### 方案 A：巨魔商店 TrollStore（永久使用、免越狱、免证书）
- **适用设备**：系统版本在 iOS 14.0 - 16.6.1 / 17.0 且安装了 TrollStore 的 iPhone。
- **原理**：TrollStore 利用系统 CoreTrust 漏洞，可以赋予 App 任意私有 Entitlements（包括未受签名的 NetworkExtension）。
- **操作**：
  1. 使用 Xcode 或 `flutter build ipa --no-codesign` 导出未签名包；
  2. 将生成的 `.ipa` 通过 AirDrop 发送到 iPhone；
  3. 用 TrollStore 打开安装，**即可永久免费使用 VPN 功能，永不掉签**。

#### 方案 B：AltStore / Sideloadly（使用免费个人 Apple ID 辅助续签）
- **原理**：利用电脑端守护进程每 7 天自动重签安装。
- **注意**：免费 Apple ID 默认不开放 Network Extension 权限，需在 AltStore 设置中开启高级网络权限插件。

---

### 7. 步骤五：iPhone 真机联调与部署

1. 用 USB 数据线将 iPhone 连接到 Mac；
2. 在 iPhone 上信任此电脑，并在系统设置中开启 **开发者模式**（iOS 16+：设置 -> 隐私与安全性 -> 开发者模式 -> 开启并重启）；
3. 在 Mac 终端运行：
   ```bash
   # 查看当前识别到的真机设备名称或 ID
   flutter devices

   # 直接编译安装到真机并开始调试
   flutter run -d <您的iPhone设备名>
   ```
4. **真机运行验证**：
   - 启动手机上的 Wmimo App；
   - 点击连接开关；
   - 此时 iOS 会弹出系统级提示：  
     > **“Wmimo” 想添加 VPN 配置**  
     > 所有网络流量可能通过 VPN 路由或监控。  
     > [允许]  [不允许]
   - 点击 **“允许”** 并输入锁屏数字密码；
   - iPhone 顶部状态栏出现 `[VPN]` 标志，即可正常科学上网！

---

## 四、常见问题排查 (Troubleshooting)

### Q1: 在 Xcode 中编译报 `missing Libclash.xcframework` 或符号找不到？
- **原因**：尚未运行 `tool/build_apple_core.sh`，或者生成的文件没有放在 `bind/apple/Libclash.xcframework` 路径下。
- **解决**：确保在 Mac 终端运行 `bash tool/build_apple_core.sh`，确认该目录下存在该文件夹后，在 Xcode 中执行 `Product -> Clean Build Folder`（快捷键 `Shift+Cmd+K`），重新编译。

### Q2: iOS 真机上开启连接瞬间崩溃闪退？
- **原因**：iOS 系统对 Network Extension 扩展进程施加了严格的 **内存限制（Memory Limit 通常为 15MB ~ 50MB）**。如果 Mihomo 核心加载了过大的 GeoIP/GeoSite 规则集或启用了占用大量内存的 DNS 缓存，进程会被系统 Jetsam 机制强制杀掉。
- **解决**：
  1. 在配置文件中关闭不必要的庞大规则库，优先使用轻量规则（Direct/Proxy/Reject 基础分流）；
  2. 确保在 `PacketTunnelProvider` 中仅运行精简内核实例。

### Q3: 点击连接后没有弹出系统的“允许添加 VPN 配置”弹窗？
- **原因**：
  1. 主 App 与扩展的 Bundle ID 或 App Group 不匹配；
  2. `Runner.entitlements` 与 `wmimoService.entitlements` 中的 `group.com.wmimo.app` 不一致。
- **解决**：检查两处的 Entitlements 文件，确保 `group.com.wmimo.app` 拼写完全一致，且已经在 Apple Developer 网站（或 Xcode Capabilities）中正确关联。

### Q4: macOS 启动 TUN 模式提示 `operation not permitted` 或 `access denied`？
- **原因**：核心二进制缺少 SUID 特权。
- **解决**：在 Mac 终端中手动执行一次提权赋予权限：
  ```bash
  sudo chown root:admin build/macos/Build/Products/Release/Wmimo.app/Contents/Frameworks/wmimoService
  sudo chmod 4755 build/macos/Build/Products/Release/Wmimo.app/Contents/Frameworks/wmimoService
  ```

---

> **结语**：通过本指南，任何具备 Mac 机器的开发者都可以在 10 分钟内完成 macOS 的自动化 DMG 产出，或在 1 小时内按步骤打通 iOS 的全功能真机运行。
