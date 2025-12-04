# LoulanKey - ESP32-S3 FIDO2 Security Authenticator

<div align="center">

![LoulanKey Logo](https://img.shields.io/badge/LoulanKey-FIDO2-blue?style=for-the-badge)

[![License](https://img.shields.io/badge/license-AGPLv3-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-ESP32--S3-red.svg)](https://www.espressif.com/en/products/socs/esp32-s3)
[![Based on](https://img.shields.io/badge/based%20on-pico--fido-orange.svg)](https://github.com/polhenarejos/pico-fido)

**基于 ESP32-S3 和 pico-fido 的 FIDO2/WebAuthn 硬件安全密钥增强版**

[Features](#-核心特性) | [Quick Start](#-快速开始) | [Contributing](CONTRIBUTING.md)

</div>

---

## 🌟 项目简介

**LoulanKey**（楼兰密钥）是一个基于 [pico-fido](https://github.com/polhenarejos/pico-fido) 的 ESP32-S3 FIDO2 硬件安全认证器项目，专注于为 ESP32-S3 平台实现完整的**硬件安全特性**。

### 为什么叫 LoulanKey？

楼兰（Loulan）是古丝绸之路上的重要关隘，象征着守护与通行。LoulanKey 致力于成为数字世界的安全守护者，为用户的身份认证提供可信的硬件保障。

### 项目定位

本项目基于优秀的 [pico-fido](https://github.com/polhenarejos/pico-fido) 项目，针对 ESP32-S3 平台进行了以下增强：

- 🔒 **硬件安全增强** - 完整实现 ESP32-S3 的 Secure Boot V2、Flash 加密、eFuse 保护等特性
- 🛠️ **开源学习** - 提供安全特性的详细实现文档和分析
- 📚 **中文文档** - 完整的中文文档和实现指南
- 🔧 **可定制** - 开源架构，支持学习和研究

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
| 开源硬件 | ❌ | ❌ | 部分 (基于 ESP32-S3) |
| 开源固件 | ❌ | ❌ | ✅ (基于 pico-fido) |
| 学习研究 | ❌ | ❌ | ✅ |

> **注意**: LoulanKey 是一个学习和研究项目，基于开源的 pico-fido。商用部署请考虑使用经过认证的商业产品。

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

### 克隆项目

```bash
git clone https://github.com/thomas-hiddenpeak/LoulanKey.git
cd LoulanKey
git submodule update --init --recursive
```

### 构建固件

```bash
# 运行安全增强脚本（可选）
./scripts/apply_security_enhancements.sh

# 构建固件
cd pico-fido
mkdir -p build
cd build
idf.py build
```

### 烧录固件

```bash
# 开发模式（保留调试）
idf.py -p /dev/ttyUSB0 flash monitor

# 生产模式（完全锁定，需根据实际需求配置）
# 警告：生产模式会永久禁用某些功能，请参考文档
idf.py -p /dev/ttyUSB0 flash
```

### 测试

访问 [webauthn.io](https://webauthn.io) 测试 FIDO2 功能

更多详细信息请参考: 
- [pico-fido 官方文档](https://github.com/polhenarejos/pico-fido)
- [ESP32-S3 安全特性文档](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/security/index.html)

---

## 📚 文档

### 项目文档
- [📋 项目分析](PROJECT_ANALYSIS.md) - pico-fido 项目结构分析
- [🔒 安全差距分析](SECURITY_GAPS_ANALYSIS.md) - ESP32-S3 安全特性分析
- [📖 实施指南](IMPLEMENTATION_GUIDE.md) - 安全特性实施步骤
- [📝 执行摘要](EXECUTIVE_SUMMARY.md) - 项目总体概览
- [🏗️ 项目结构](PROJECT_STRUCTURE.md) - 代码结构说明
- [🚀 推送指南](PUSH_GUIDE.md) - Git 操作指南
- [🛡️ 安全说明](SECURITY.md) - 安全相关说明

### 上游文档
- [pico-fido README](pico-fido/README.md) - 原始项目文档
- [pico-fido GitHub](https://github.com/polhenarejos/pico-fido) - 上游项目主页
- [ESP32-S3 安全特性](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/security/index.html) - 官方安全文档

### 贡献文档
- [🤝 贡献指南](CONTRIBUTING.md) - 如何贡献代码

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

### 硬件信息

更多硬件相关信息请参考：
- [ESP32-S3 数据手册](https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf)
- [ESP32-S3-DevKitC-1 用户指南](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/hw-reference/esp32s3/user-guide-devkitc-1.html)

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

更多详细安全分析请参考：
- [SECURITY_GAPS_ANALYSIS.md](SECURITY_GAPS_ANALYSIS.md)
- [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)

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

本项目基于 [pico-fido](https://github.com/polhenarejos/pico-fido) 开发，遵循相同的开源许可证：

### GNU Affero General Public License v3 (AGPLv3)
- **用途**: 个人使用、学习、研究
- **要求**: 衍生作品必须开源（根据 AGPLv3 条款）
- **原始版权**: pico-fido © 2022 Pol Henarejos

本项目的修改和增强部分同样采用 AGPLv3 许可证。

详见：[LICENSE](LICENSE)

### 其他依赖项许可证

- **MbedTLS**: Apache License 2.0
- **ESP-IDF**: Apache License 2.0
- **TinyCBOR**: MIT License

请注意：本项目是基于 pico-fido 的学习和研究项目。如需商业使用，请遵守 AGPLv3 许可证要求或联系上游项目。

---

## 🎯 路线图

### v1.0 (当前) - 基础增强
- [x] ESP32-S3 硬件安全特性实现
- [x] Secure Boot V2 集成
- [x] Flash 加密支持
- [x] eFuse 密钥保护
- [x] 完整的中文文档

### 未来计划
- [ ] 更完善的测试覆盖
- [ ] 更详细的安全配置指南
- [ ] 性能优化
- [ ] 更多示例和教程

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解如何参与。

---

## 🏆 致谢

### 项目基础
- [pico-fido](https://github.com/polhenarejos/pico-fido) - 优秀的 FIDO2 实现，本项目的核心基础
- [ESP-IDF](https://github.com/espressif/esp-idf) - Espressif 物联网开发框架
- [MbedTLS](https://github.com/Mbed-TLS/mbedtls) - 加密库

### 标准组织
- [FIDO Alliance](https://fidoalliance.org/) - FIDO2 标准
- [W3C](https://www.w3.org/) - WebAuthn 规范

### 维护者
- 本项目由 Thomas 个人维护
- 欢迎通过 GitHub Issues 和 Pull Requests 参与贡献

---

<div align="center">

**🔐 守护你的数字身份，从 LoulanKey 开始 🔐**

基于 pico-fido | 为学习和研究而生

[⬆ 回到顶部](#loulankey---esp32-s3-fido2-security-authenticator)

</div>
