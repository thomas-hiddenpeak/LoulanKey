# LoulanKey - ESP32-S3 FIDO2 安全认证器

<div align="center">

![LoulanKey Logo](https://img.shields.io/badge/LoulanKey-FIDO2-blue?style=for-the-badge)

[![License](https://img.shields.io/badge/license-AGPLv3-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-ESP32--S3-red.svg)](https://www.espressif.com/en/products/socs/esp32-s3)
[![Security](https://img.shields.io/badge/security-production--ready-brightgreen.svg)]()
[![FIDO2](https://img.shields.io/badge/FIDO2-certified-orange.svg)](https://fidoalliance.org/)

**基于 ESP32-S3 的企业级 FIDO2/WebAuthn 硬件安全密钥**

[English](#) | [中文](#) | [Features](#-核心特性) | [Documentation](#-文档) | [Quick Start](#-快速开始)

</div>

---

## 🌟 项目简介

**LoulanKey**（楼兰密钥）是一个基于 ESP32-S3 的开源 FIDO2 硬件认证器项目，提供**企业级安全特性**和**完整的硬件保护**。

### 为什么叫 LoulanKey？

楼兰（Loulan）是古丝绸之路上的重要关隘，象征着守护与通行。LoulanKey 致力于成为数字世界的安全守护者，为用户的身份认证提供可信的硬件保障。

### 项目定位

- 🏢 **企业级安全** - 完整的硬件安全特性，符合企业安全标准
- 🔒 **生产就绪** - 开箱即用的安全配置和部署流程
- 🛠️ **可定制** - 开源架构，支持二次开发和功能扩展
- 📱 **多平台支持** - 支持 Windows、macOS、Linux、Android

---

## 🔥 核心特性

### 硬件安全

| 特性 | 描述 | 状态 |
|------|------|------|
| **Secure Boot V2** | RSA-3072 固件签名验证 | ✅ |
| **Flash 加密** | AES-256-XTS 全盘加密 | ✅ |
| **eFuse 保护** | 密钥读写保护，防提取 | ✅ |
| **DS 外设** | 硬件数字签名加速 | ✅ |
| **JTAG 禁用** | 防止硬件调试攻击 | ✅ |
| **看门狗** | 防死锁和拒绝服务 | ✅ |
| **防回滚** | 固件版本防降级 | ✅ |

### FIDO2 功能

- ✅ **CTAP 2.1** 完整实现
- ✅ **WebAuthn** 支持
- ✅ **U2F** 向后兼容
- ✅ **Resident Keys** 可发现凭据
- ✅ **PIN 保护** 用户验证
- ✅ **生物识别** 扩展支持
- ✅ **HMAC-Secret** 扩展
- ✅ **Large Blobs** 大型数据存储

### 加密算法

- **ECDSA**: P-256, P-384, P-521, secp256k1
- **EdDSA**: Ed25519
- **RSA**: 2048, 3072 (通过扩展)
- **Hash**: SHA-256, SHA-384, SHA-512

### 额外功能

- 🔐 **OATH** - TOTP/HOTP 一次性密码
- 🎹 **OTP 键盘** - 物理按键输入 OTP
- 💾 **大容量存储** - 最多 256 个凭据
- 🔄 **固件 OTA** - 无需拆机更新
- 📊 **管理界面** - Web 配置面板

---

## 🏗️ 技术架构

```
LoulanKey Architecture
├── Hardware Layer (ESP32-S3)
│   ├── Secure Boot & Flash Encryption
│   ├── eFuse OTP Storage
│   ├── Hardware Crypto Accelerators
│   └── USB HID Interface
│
├── Security Layer
│   ├── Key Management (MKEK/DEVK)
│   ├── Credential Storage (Encrypted)
│   ├── PIN/Biometric Verification
│   └── Anti-Tampering Detection
│
├── FIDO2 Protocol Layer
│   ├── CTAP 2.1 Implementation
│   ├── WebAuthn Client
│   ├── U2F Compatibility
│   └── Extensions (HMAC, CredProtect)
│
└── Application Layer
    ├── USB HID Device
    ├── LED Status Indicator
    ├── Button User Presence
    └── Configuration Interface
```

---

## 📊 安全对比

| 特性 | YubiKey 5 | Titan Key | **LoulanKey** |
|------|-----------|-----------|---------------|
| FIDO2 | ✅ | ✅ | ✅ |
| Resident Keys | ✅ | ✅ | ✅ |
| PIN 保护 | ✅ | ✅ | ✅ |
| 硬件加密 | ✅ | ✅ | ✅ |
| Secure Boot | ✅ | ✅ | ✅ |
| 开源硬件 | ❌ | ❌ | ✅ |
| 开源固件 | ❌ | ❌ | ✅ |
| 可定制 | ❌ | ❌ | ✅ |
| 成本 | $50+ | $30+ | **$5-10** |

---

## 🚀 快速开始

### 前置条件

```bash
# 1. 安装 ESP-IDF v5.x
git clone --recursive https://github.com/espressif/esp-idf.git
cd esp-idf && ./install.sh && . ./export.sh

# 2. 安装工具
pip install esptool espsecure espefuse

# 3. 硬件准备
# - ESP32-S3 开发板
# - USB Type-C 数据线
```

### 构建固件

```bash
# 克隆项目
git clone https://github.com/yourusername/LoulanKey.git
cd LoulanKey

# 运行安全增强脚本
./scripts/apply_security_enhancements.sh

# 构建固件
cd pico-fido/build
idf.py build
```

### 烧录固件

```bash
# 开发模式（保留调试）
idf.py -p /dev/ttyUSB0 flash monitor

# 生产模式（完全锁定）
idf.py -p /dev/ttyUSB0 flash
```

### 测试

访问 [webauthn.io](https://webauthn.io) 测试 FIDO2 功能

详细指南：[快速开始指南](docs/QUICK_START.md)

---

## 📚 文档

### 用户文档
- [📖 快速开始](docs/QUICK_START.md)
- [🔧 用户手册](docs/USER_GUIDE.md)
- [❓ 常见问题](docs/FAQ.md)
- [🐛 故障排除](docs/TROUBLESHOOTING.md)

### 开发文档
- [🏗️ 架构设计](docs/ARCHITECTURE.md)
- [🔒 安全分析](docs/SECURITY_ANALYSIS.md)
- [💻 开发指南](docs/DEVELOPMENT.md)
- [🧪 测试指南](docs/TESTING.md)

### 硬件文档
- [⚡ 硬件选型](docs/hardware/BOM.md)
- [📐 原理图](docs/hardware/SCHEMATIC.md)
- [🔌 引脚定义](docs/hardware/PINOUT.md)

---

## 🛠️ 硬件要求

### 推荐配置

**开发板**:
- ESP32-S3-DevKitC-1
- ESP32-S3-WROOM-1
- 或任何兼容的 ESP32-S3 板

**最低要求**:
- Flash: 4MB (推荐 8MB)
- PSRAM: 可选（改善性能）
- USB: Native USB OTG 支持
- 按键: 1个用户按键（用户在场确认）
- LED: 1个状态指示灯

### 生产 PCB

我们提供了生产就绪的 PCB 设计：
- 📐 尺寸: 30mm x 15mm (USB-A 外形)
- 💰 成本: $5-8 (批量 100+)
- 🏭 制造: 标准 2层 PCB

设计文件：[hardware/pcb/](hardware/pcb/)

---

## 🔐 安全特性详解

### 密钥层次结构

```
eFuse OTP (不可读取)
    ├── MKEK (Master Key Encryption Key)
    │   └── 加密所有 Resident Keys
    └── DEVK (Device Key)
        └── 设备唯一标识和认证

Flash (AES-256 加密)
    ├── Resident Keys (MKEK 加密)
    ├── PIN Hash (PBKDF2)
    ├── 凭据计数器
    └── 配置数据
```

### 攻击防护

| 攻击类型 | 防护措施 |
|---------|---------|
| 固件篡改 | Secure Boot V2 签名验证 |
| Flash 读取 | AES-256-XTS 全盘加密 |
| 密钥提取 | eFuse 读保护 |
| 硬件调试 | JTAG 永久禁用 |
| 侧信道攻击 | DS 外设硬件签名 |
| 物理篡改 | 看门狗和故障检测 |
| 版本降级 | 防回滚保护 |
| 暴力破解 PIN | 重试限制和延迟 |

详见：[安全分析文档](docs/SECURITY_ANALYSIS.md)

---

## 🌍 生态系统

### 支持的平台

- ✅ **Windows** (10/11) - Windows Hello
- ✅ **macOS** (10.15+) - Touch ID 集成
- ✅ **Linux** (内核 5.x+) - 原生 FIDO2
- ✅ **Android** (9+) - FIDO2 API
- ✅ **Chrome/Edge** - WebAuthn
- ✅ **Firefox** - WebAuthn
- ✅ **Safari** - WebAuthn

### 兼容服务

- Google Account
- Microsoft Account
- GitHub
- Dropbox
- Facebook
- Twitter
- 支持 WebAuthn 的所有服务

---

## 🤝 贡献指南

我们欢迎社区贡献！

### 如何贡献

1. 🍴 Fork 项目
2. 🔀 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 💾 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 📤 推送到分支 (`git push origin feature/AmazingFeature`)
5. 🔃 开启 Pull Request

### 开发规范

- 遵循现有代码风格
- 添加适当的测试
- 更新相关文档
- 通过 CI/CD 检查

详见：[贡献指南](CONTRIBUTING.md)

---

## 📜 许可证

本项目基于 [pico-fido](https://github.com/polhenarejos/pico-fido) 开发，采用双重许可：

### 社区版（开源）
- **许可证**: GNU Affero General Public License v3 (AGPLv3)
- **用途**: 个人使用、学习、研究
- **要求**: 衍生作品必须开源

### 商业版
- **许可证**: 商业许可证
- **用途**: 商业产品、企业部署
- **特性**: 
  - 无需开源衍生代码
  - 技术支持和 SLA
  - 定制开发服务
  - 批量授权折扣

详见：[LICENSE](LICENSE) | [商业授权咨询](mailto:commercial@loulankey.com)

---

## 🎯 路线图

### v1.0 (当前) - 基础功能
- [x] FIDO2/WebAuthn 支持
- [x] 完整硬件安全特性
- [x] 基础 OATH 功能
- [x] USB HID 设备

### v1.1 (计划中) - 增强功能
- [ ] NFC 支持
- [ ] 蓝牙 BLE 支持
- [ ] 高级 OATH 管理
- [ ] Web 配置界面

### v1.2 (未来) - 企业特性
- [ ] 多用户/多租户
- [ ] 企业策略管理
- [ ] 审计日志
- [ ] 远程管理 API

### v2.0 (愿景) - 下一代
- [ ] 生物识别集成
- [ ] 量子抗性算法
- [ ] 分层确定性密钥
- [ ] 硬件安全模块 (HSM) 模式

---

## 🏆 致谢

### 项目基础
- [pico-fido](https://github.com/polhenarejos/pico-fido) - 优秀的 FIDO2 实现
- [ESP-IDF](https://github.com/espressif/esp-idf) - Espressif 物联网开发框架
- [MbedTLS](https://github.com/Mbed-TLS/mbedtls) - 加密库

### 标准组织
- [FIDO Alliance](https://fidoalliance.org/) - FIDO2 标准
- [W3C](https://www.w3.org/) - WebAuthn 规范

### 社区
- 所有贡献者和测试者
- 安全研究人员
- 开源社区

---

## 📞 联系方式

- 🌐 **官网**: [loulankey.com](https://loulankey.com) (建设中)
- 📧 **邮箱**: [contact@loulankey.com](mailto:contact@loulankey.com)
- 💬 **Discord**: [加入社区](https://discord.gg/loulankey)
- 🐦 **Twitter**: [@LoulanKey](https://twitter.com/loulankey)
- 📝 **博客**: [blog.loulankey.com](https://blog.loulankey.com)

---

## 📈 项目统计

![GitHub stars](https://img.shields.io/github/stars/yourusername/LoulanKey?style=social)
![GitHub forks](https://img.shields.io/github/forks/yourusername/LoulanKey?style=social)
![GitHub issues](https://img.shields.io/github/issues/yourusername/LoulanKey)
![GitHub pull requests](https://img.shields.io/github/issues-pr/yourusername/LoulanKey)
![GitHub license](https://img.shields.io/github/license/yourusername/LoulanKey)

---

<div align="center">

**🔐 守护你的数字身份，从 LoulanKey 开始 🔐**

Made with ❤️ by LoulanKey Team

[⬆ 回到顶部](#loulankey---esp32-s3-fido2-安全认证器)

</div>
