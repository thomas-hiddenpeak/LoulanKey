#!/bin/bash
# ESP32-S3 安全特性实施脚本
# 用于将安全增强应用到 pico-fido 项目

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目路径
PROJECT_ROOT="/Users/thomas/esp32s3-fido2"
PICO_FIDO_DIR="${PROJECT_ROOT}/pico-fido"
SECURITY_DIR="${PROJECT_ROOT}"

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}ESP32-S3 FIDO2 安全增强实施脚本${NC}"
echo -e "${BLUE}======================================${NC}"
echo

# ============================================================================
# 函数定义
# ============================================================================

print_step() {
    echo -e "${GREEN}[步骤 $1]${NC} $2"
}

print_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

ask_confirmation() {
    read -p "$1 (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "操作已取消"
        exit 1
    fi
}

# ============================================================================
# 前置检查
# ============================================================================

print_step "1" "检查环境"

# 检查是否在正确的目录
if [ ! -d "${PICO_FIDO_DIR}" ]; then
    print_error "找不到 pico-fido 目录: ${PICO_FIDO_DIR}"
    exit 1
fi

# 检查 ESP-IDF
if [ -z "$IDF_PATH" ]; then
    print_error "ESP-IDF 环境未设置，请运行: . ~/esp-idf/export.sh"
    exit 1
fi

print_info "ESP-IDF 路径: $IDF_PATH"
print_info "项目路径: $PICO_FIDO_DIR"
echo

# ============================================================================
# 备份原始文件
# ============================================================================

print_step "2" "备份原始文件"

BACKUP_DIR="${PROJECT_ROOT}/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "${BACKUP_DIR}"

files_to_backup=(
    "${PICO_FIDO_DIR}/sdkconfig.defaults"
    "${PICO_FIDO_DIR}/pico-keys-sdk/config/esp32/partitions.csv"
    "${PICO_FIDO_DIR}/pico-keys-sdk/src/fs/otp.c"
    "${PICO_FIDO_DIR}/pico-keys-sdk/src/fs/otp.h"
)

for file in "${files_to_backup[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "${BACKUP_DIR}/"
        print_info "已备份: $(basename $file)"
    fi
done

print_info "备份目录: ${BACKUP_DIR}"
echo

# ============================================================================
# 选择部署模式
# ============================================================================

print_step "3" "选择部署模式"
echo
echo "1) 开发模式 (保留调试功能)"
echo "2) 生产模式 (完全锁定，不可逆！)"
echo
read -p "请选择模式 (1/2): " -n 1 -r MODE
echo

if [[ $MODE == "2" ]]; then
    print_warning "⚠️  生产模式将执行不可逆操作："
    print_warning "  - 禁用 JTAG"
    print_warning "  - 禁用串口下载"
    print_warning "  - 锁定 eFuse"
    echo
    ask_confirmation "确定要继续吗？"
    DEPLOYMENT_MODE="production"
else
    DEPLOYMENT_MODE="development"
fi

print_info "部署模式: ${DEPLOYMENT_MODE}"
echo

# ============================================================================
# 应用安全配置
# ============================================================================

print_step "4" "应用安全配置"

# 4.1 更新 sdkconfig.defaults
print_info "更新 sdkconfig.defaults..."

if [ "$DEPLOYMENT_MODE" == "production" ]; then
    # 生产模式：使用完整安全配置
    cat "${SECURITY_DIR}/sdkconfig.secure.defaults" > "${PICO_FIDO_DIR}/sdkconfig.defaults"
else
    # 开发模式：移除不可逆的设置
    cat "${SECURITY_DIR}/sdkconfig.secure.defaults" | \
    sed 's/^CONFIG_ESP_SYSTEM_DISABLE_JTAG=y/# CONFIG_ESP_SYSTEM_DISABLE_JTAG is not set/' | \
    sed 's/^CONFIG_ESP_SYSTEM_DISABLE_ROM_DOWNLOAD_MODE=y/# CONFIG_ESP_SYSTEM_DISABLE_ROM_DOWNLOAD_MODE is not set/' | \
    sed 's/^CONFIG_BOOTLOADER_LOG_LEVEL_ERROR=y/CONFIG_BOOTLOADER_LOG_LEVEL_INFO=y/' | \
    sed 's/^CONFIG_LOG_DEFAULT_LEVEL_NONE=y/CONFIG_LOG_DEFAULT_LEVEL_INFO=y/' \
    > "${PICO_FIDO_DIR}/sdkconfig.defaults"
fi

print_info "✓ sdkconfig.defaults 已更新"

# 4.2 更新分区表
print_info "更新分区表..."
cp "${SECURITY_DIR}/partitions.secure.csv" \
   "${PICO_FIDO_DIR}/pico-keys-sdk/config/esp32/partitions.csv"
print_info "✓ 分区表已更新（添加加密标志）"

echo

# ============================================================================
# 更新源代码
# ============================================================================

print_step "5" "集成 Secure Boot 实现"

OTP_C_FILE="${PICO_FIDO_DIR}/pico-keys-sdk/src/fs/otp.c"

# 检查是否已经有实现
if grep -q "TODO.*Implement secure boot for ESP32-S3" "$OTP_C_FILE"; then
    print_info "在 otp.c 中发现 TODO 标记，准备替换..."
    
    # 创建备份
    cp "$OTP_C_FILE" "${OTP_C_FILE}.bak"
    
    # 提示用户手动集成
    print_warning "需要手动集成 Secure Boot 实现："
    print_info "1. 打开文件: ${OTP_C_FILE}"
    print_info "2. 找到三个 TODO 标记（行号约 154, 177, 227）"
    print_info "3. 用 ${SECURITY_DIR}/otp_secure_boot_esp32s3.c 中的代码替换"
    print_info "4. 或者运行: vim ${OTP_C_FILE} 并手动复制粘贴"
    echo
    read -p "按回车键继续..."
else
    print_info "otp.c 可能已经实现了 Secure Boot"
fi

echo

# ============================================================================
# 生成 Secure Boot 密钥
# ============================================================================

print_step "6" "生成 Secure Boot 签名密钥"

KEYS_DIR="${PROJECT_ROOT}/keys"
mkdir -p "${KEYS_DIR}"
chmod 700 "${KEYS_DIR}"  # 限制访问权限

SIGNING_KEY="${KEYS_DIR}/secure_boot_signing_key.pem"

if [ -f "$SIGNING_KEY" ]; then
    print_warning "签名密钥已存在: ${SIGNING_KEY}"
    ask_confirmation "是否要重新生成？（旧密钥将被覆盖）"
fi

print_info "生成 RSA-3072 签名密钥..."
espsecure.py generate_signing_key --version 2 "$SIGNING_KEY"

if [ $? -eq 0 ]; then
    print_info "✓ 签名密钥已生成: ${SIGNING_KEY}"
    print_warning "⚠️  请妥善保管此密钥，丢失将无法更新固件！"
    
    # 生成公钥（用于验证）
    openssl rsa -in "$SIGNING_KEY" -pubout -out "${KEYS_DIR}/secure_boot_public_key.pem"
    print_info "✓ 公钥已导出: ${KEYS_DIR}/secure_boot_public_key.pem"
else
    print_error "密钥生成失败"
    exit 1
fi

echo

# ============================================================================
# 配置项目
# ============================================================================

print_step "7" "配置 CMake 项目"

cd "${PICO_FIDO_DIR}"

# 清理旧的构建
if [ -d "build" ]; then
    print_info "清理旧的构建目录..."
    rm -rf build
fi

mkdir -p build
cd build

# 设置目标芯片
print_info "设置目标芯片为 ESP32-S3..."
idf.py set-target esp32s3

# 配置签名密钥路径
print_info "配置 Secure Boot 签名密钥..."
export SECURE_BOOT_SIGNING_KEY="${SIGNING_KEY}"

echo

# ============================================================================
# 构建固件
# ============================================================================

print_step "8" "构建固件"

print_info "开始编译..."
idf.py build

if [ $? -eq 0 ]; then
    print_info "✓ 固件编译成功"
    
    # 显示固件信息
    echo
    print_info "固件位置: ${PICO_FIDO_DIR}/build/"
    print_info "主应用: build/pico_fido.bin"
    print_info "Bootloader: build/bootloader/bootloader.bin"
    
    # 检查是否启用了 Secure Boot
    if grep -q "CONFIG_SECURE_BOOT=y" sdkconfig; then
        print_info "✓ Secure Boot 已启用"
    fi
    
    # 检查是否启用了 Flash 加密
    if grep -q "CONFIG_SECURE_FLASH_ENC_ENABLED=y" sdkconfig; then
        print_info "✓ Flash 加密已启用"
    fi
else
    print_error "固件编译失败，请检查错误信息"
    exit 1
fi

echo

# ============================================================================
# 烧录指导
# ============================================================================

print_step "9" "烧录指导"

echo
print_info "固件已准备就绪，可以进行烧录"
echo

if [ "$DEPLOYMENT_MODE" == "production" ]; then
    print_warning "⚠️  生产模式烧录注意事项："
    echo
    echo "1. 首次烧录会自动："
    echo "   - 启用 Flash 加密"
    echo "   - 烧录 Secure Boot 密钥摘要"
    echo "   - 锁定相关 eFuse"
    echo
    echo "2. 烧录命令："
    echo "   idf.py -p /dev/ttyUSB0 flash"
    echo
    echo "3. 烧录后设备将自动重启并应用安全设置"
    echo
    echo "4. 后续更新必须使用签名的固件："
    echo "   espsecure.py sign_data --keyfile ${SIGNING_KEY} \\"
    echo "     --version 2 pico_fido.bin pico_fido_signed.bin"
    echo "   esptool.py --chip esp32s3 write_flash 0x10000 pico_fido_signed.bin"
    echo
    print_warning "⚠️  此操作不可逆，请确保："
    print_warning "  - 已备份签名密钥"
    print_warning "  - 已实现 OTA 更新机制"
    print_warning "  - 在测试设备上验证过完整流程"
    echo
else
    print_info "开发模式烧录命令："
    echo
    echo "   cd ${PICO_FIDO_DIR}/build"
    echo "   idf.py -p /dev/ttyUSB0 flash monitor"
    echo
    print_info "开发模式保留了："
    echo "   - JTAG 调试接口"
    echo "   - 串口下载模式"
    echo "   - 详细日志输出"
    echo
fi

# ============================================================================
# 验证清单
# ============================================================================

print_step "10" "安全验证清单"

echo
echo "烧录后请验证以下项目："
echo
echo "[ ] 1. 设备能正常启动"
echo "[ ] 2. LED 指示正常"
echo "[ ] 3. USB 设备能被识别"
echo "[ ] 4. FIDO2 功能正常（webauthn.io 测试）"
echo "[ ] 5. 安全特性已启用："
if [ "$DEPLOYMENT_MODE" == "production" ]; then
    echo "      [ ] Secure Boot 已启用"
    echo "      [ ] Flash 加密已启用"
    echo "      [ ] JTAG 已禁用"
    echo "      [ ] 下载模式已禁用"
else
    echo "      [ ] Flash 加密已启用（开发模式）"
    echo "      [ ] Secure Boot 已启用（开发模式）"
fi
echo

# ============================================================================
# 完成
# ============================================================================

print_info "========================================="
print_info "安全增强实施完成！"
print_info "========================================="
echo
print_info "下一步："
echo "1. 检查构建输出"
echo "2. 连接 ESP32-S3 设备"
echo "3. 执行烧录命令"
echo "4. 验证功能"
echo
print_info "相关文档："
echo "- 安全缺失分析: ${PROJECT_ROOT}/SECURITY_GAPS_ANALYSIS.md"
echo "- 项目分析: ${PROJECT_ROOT}/PROJECT_ANALYSIS.md"
echo "- 备份目录: ${BACKUP_DIR}"
echo
print_warning "⚠️  请妥善保管签名密钥: ${SIGNING_KEY}"
echo
