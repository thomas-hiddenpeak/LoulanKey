# ESP32-S3 FIDO2 项目分析

## 项目来源
基于 **pico-fido** 项目 (https://github.com/polhenarejos/pico-fido)
- ⭐ 851 stars
- 支持 Raspberry Pi Pico 和 ESP32-S3
- 完整的 CTAP 2.1/FIDO2 实现

## 核心架构

### 1. 项目结构
```
pico-fido/
├── src/fido/              # FIDO2 核心实现
│   ├── fido.c            # 主要 FIDO 逻辑
│   ├── cbor_*.c          # CBOR 编解码（CTAP协议）
│   ├── credential.c      # 凭据管理
│   ├── kek.c            # 密钥加密密钥
│   ├── oath.c           # OATH (TOTP/HOTP)
│   └── otp.c            # 一次性密码
├── pico-keys-sdk/        # 跨平台SDK
│   ├── src/
│   │   ├── main.c       # 平台入口点
│   │   ├── fs/          # 文件系统和OTP
│   │   │   └── otp.c    # 🔒 OTP安全存储
│   │   ├── led/         # LED控制
│   │   └── usb/         # USB HID接口
│   └── mbedtls/         # 加密库
└── CMakeLists.txt       # 构建配置
```

### 2. ESP32-S3 安全特性

#### OTP (One-Time Programmable) 存储
位置: `pico-keys-sdk/src/fs/otp.c`

**核心功能：**
- **EFUSE 密钥存储**: 使用 ESP32-S3 的 eFuse 块存储主密钥
  - `EFUSE_BLK_KEY3` (OTP_KEY_1): 主密钥加密密钥 (MKEK)
  - `EFUSE_BLK_KEY4` (OTP_KEY_2): 设备密钥 (DEVK)

**关键函数：**
```c
// 初始化 OTP 密钥（首次运行时写入 eFuse）
void init_otp_files()

// 读取 eFuse 密钥
esp_err_t read_key_from_efuse(esp_efuse_block_t block, uint8_t *key, size_t key_len)

// 启用 Secure Boot
int otp_enable_secure_boot(uint8_t bootkey, bool secure_lock)

// 检查 Secure Boot 状态
bool otp_is_secure_boot_enabled(uint8_t *bootkey)
bool otp_is_secure_boot_locked()
```

#### Secure Boot 实现
```c
// 安全启动流程：
// 1. 写入 Boot Key 到 OTP
// 2. 设置 BOOT_FLAGS (标记密钥有效)
// 3. 启用 SECURE_BOOT_ENABLE
// 4. [可选] 启用 Secure Lock:
//    - DEBUG_DISABLE (禁用JTAG)
//    - GLITCH_DETECTOR_ENABLE (故障注入检测)
//    - 锁定所有其他密钥槽
```

### 3. 加密架构

#### 密钥层次结构
```
OTP_KEY_1 (MKEK - eFuse不可读)
    ↓ 加密
所有 Resident Keys (存储在 Flash)
    ↓ 派生
单个凭据的私钥
```

#### MbedTLS 硬件加速
配置文件: `sdkconfig.defaults`
```
CONFIG_MBEDTLS_HARDWARE_ECC=y      # 硬件ECC加速
CONFIG_MBEDTLS_HARDWARE_GCM=y      # 硬件GCM加密
CONFIG_MBEDTLS_HARDWARE_SHA=y      # 硬件SHA加速
CONFIG_MBEDTLS_HARDWARE_AES=y      # 硬件AES加速
CONFIG_MBEDTLS_SHA512_C=y          # SHA-512支持
CONFIG_MBEDTLS_CMAC_C=y            # CMAC支持
CONFIG_MBEDTLS_CHACHA20_C=y        # ChaCha20支持
CONFIG_MBEDTLS_POLY1305_C=y        # Poly1305支持
CONFIG_MBEDTLS_CHACHAPOLY_C=y      # ChaCha20-Poly1305 AEAD
```

### 4. FIDO2 功能实现

#### CTAP 2.1 命令支持
文件位置: `src/fido/cbor_*.c`

- ✅ `authenticatorMakeCredential` - 创建新凭据
- ✅ `authenticatorGetAssertion` - 获取断言（登录）
- ✅ `authenticatorGetInfo` - 获取认证器信息
- ✅ `authenticatorClientPIN` - PIN管理
- ✅ `authenticatorReset` - 重置设备
- ✅ `authenticatorSelection` - 设备选择
- ✅ `authenticatorCredentialManagement` - 凭据管理
- ✅ `authenticatorLargeBlobs` - 大型Blob存储
- ✅ `authenticatorConfig` - 配置管理

#### 支持的算法
- **ECDSA**: SECP256R1, SECP384R1, SECP521R1, SECP256K1
- **EdDSA**: Ed25519
- **扩展**: 
  - HMAC-Secret
  - CredProtect
  - largeBlobKey
  - credBlobs

### 5. 用户验证

#### PIN 保护
文件: `src/fido/cbor_client_pin.c`
- PIN 存储在加密的文件系统中
- 使用 PBKDF2 进行密钥派生
- 支持 PIN 重试计数器
- 用户验证令牌 (pinUvAuthToken)

#### 物理按键确认
- 通过 GPIO 按键实现用户在场确认
- ESP32-S3: GPIO_NUM_0 (BOOT按钮)

### 6. LED 状态指示

LED 模式 (可在 README 中看到动图)：
- **按下确认**: 1秒闪烁1次 (900ms开/100ms关)
- **空闲模式**: 1秒闪烁1次 (500ms开/500ms关)
- **活动模式**: 1秒闪烁4次
- **处理中**: 1秒闪烁20次

## 关键安全考虑

### RP2040 vs ESP32-S3
**RP2040 (不推荐用于生产):**
- ❌ 无硬件安全特性
- ❌ Flash 可被轻易读取
- ❌ 无法保护主密钥

**ESP32-S3 (推荐):**
- ✅ eFuse OTP 存储（不可读）
- ✅ Secure Boot 支持
- ✅ Flash 加密
- ✅ 故障注入检测
- ✅ Debug 禁用选项

### 安全最佳实践

1. **启用 Secure Boot + Secure Lock**
   ```c
   otp_enable_secure_boot(0, true);
   ```

2. **使用硬件加速**
   - 减少侧信道攻击风险
   - 提高性能

3. **密钥永不离开设备**
   - 所有私钥在设备内生成
   - 使用 MKEK 加密存储

## 构建 ESP32-S3 固件

### 前置条件
```bash
# 安装 ESP-IDF
git clone --recursive https://github.com/espressif/esp-idf.git
cd esp-idf
./install.sh
. ./export.sh
```

### 构建步骤
```bash
cd ~/esp32s3-fido2/pico-fido
mkdir build && cd build

# 配置 ESP-IDF 项目
idf.py set-target esp32s3

# 配置（可选）
idf.py menuconfig

# 编译
idf.py build

# 烧录
idf.py -p /dev/ttyUSB0 flash

# 监控日志
idf.py monitor
```

### 自定义 VID/PID
```bash
cmake .. -DUSB_VID=0x1234 -DUSB_PID=0x5678
```

## 测试

### 运行测试套件
```bash
cd tests
pip install fido2 pytest
pytest                    # 运行所有测试
pytest -k test_credprotect # 运行特定测试
```

### 浏览器测试
1. 访问 https://webauthn.io
2. 注册新账户
3. 测试登录流程

## 下一步研究方向

### 1. 代码深入研究
- [ ] 凭据存储格式 (`credential.c`)
- [ ] CBOR 编解码实现 (`cbor_*.c`)
- [ ] 密钥派生过程 (`kek.c`)
- [ ] USB HID 协议实现

### 2. 安全增强
- [ ] 添加 PIN 复杂度要求
- [ ] 实现防暴力破解延迟
- [ ] 添加审计日志
- [ ] 实现固件签名验证

### 3. 功能扩展
- [ ] 支持 NFC (如果硬件支持)
- [ ] 添加蓝牙低功耗支持
- [ ] 实现固件更新机制
- [ ] 添加备份/恢复功能

### 4. ESP32-S3 特定优化
- [ ] 优化电源管理
- [ ] 利用 WiFi/BLE 功能
- [ ] 优化加密性能
- [ ] 实现安全元素隔离

## 参考资料

- [FIDO2 规范](https://fidoalliance.org/specifications/)
- [CTAP 2.1 规范](https://fidoalliance.org/specs/fido-v2.1-ps-20210615/fido-client-to-authenticator-protocol-v2.1-ps-errata-20220621.html)
- [WebAuthn 规范](https://www.w3.org/TR/webauthn/)
- [ESP32-S3 技术手册](https://www.espressif.com/sites/default/files/documentation/esp32-s3_technical_reference_manual_en.pdf)
- [ESP32-S3 安全指南](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/security/index.html)

## 许可证

- 社区版: AGPLv3 (开源)
- 商业版: 需要联系作者 pol@henarejos.me

---
生成时间: 2025-12-04
基于 pico-fido 项目分析
