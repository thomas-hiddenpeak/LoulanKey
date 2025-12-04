# LoulanKey 项目结构

```
LoulanKey/
├── .github/                          # GitHub 配置
│   ├── workflows/                    # CI/CD 工作流
│   │   ├── build.yml                # 构建测试
│   │   ├── security-scan.yml        # 安全扫描
│   │   └── release.yml              # 发布流程
│   ├── ISSUE_TEMPLATE/              # Issue 模板
│   └── PULL_REQUEST_TEMPLATE.md     # PR 模板
│
├── docs/                            # 文档目录
│   ├── QUICK_START.md              # 快速开始
│   ├── USER_GUIDE.md               # 用户手册
│   ├── DEVELOPMENT.md              # 开发指南
│   ├── ARCHITECTURE.md             # 架构设计
│   ├── SECURITY_ANALYSIS.md        # 安全分析
│   ├── FAQ.md                      # 常见问题
│   ├── TROUBLESHOOTING.md          # 故障排除
│   ├── hardware/                   # 硬件文档
│   │   ├── BOM.md                 # 物料清单
│   │   ├── SCHEMATIC.md           # 原理图
│   │   └── PINOUT.md              # 引脚定义
│   └── images/                     # 文档图片
│
├── hardware/                        # 硬件设计
│   ├── pcb/                        # PCB 设计文件
│   │   ├── LoulanKey.kicad_pro    # KiCad 项目
│   │   ├── gerber/                # Gerber 文件
│   │   └── README.md              # PCB 说明
│   ├── enclosure/                  # 外壳设计
│   │   ├── 3d-models/             # 3D 模型
│   │   └── README.md
│   └── images/                     # 硬件图片
│
├── scripts/                         # 脚本工具
│   ├── apply_security_enhancements.sh  # 安全增强脚本
│   ├── build.sh                    # 构建脚本
│   ├── flash.sh                    # 烧录脚本
│   ├── test.sh                     # 测试脚本
│   └── generate_keys.sh            # 密钥生成脚本
│
├── config/                          # 配置文件
│   ├── sdkconfig.secure.defaults   # 安全配置
│   ├── partitions.secure.csv       # 分区表
│   └── menuconfig_presets/         # 预设配置
│
├── src/                            # 源代码（安全增强）
│   ├── security/                   # 安全模块
│   │   ├── otp_secure_boot_esp32s3.c
│   │   └── secure_storage.c
│   └── extensions/                 # 功能扩展
│       ├── nfc/                   # NFC 支持
│       └── ble/                   # 蓝牙支持
│
├── tests/                          # 测试
│   ├── unit/                       # 单元测试
│   ├── integration/                # 集成测试
│   └── security/                   # 安全测试
│
├── tools/                          # 开发工具
│   ├── pico-commissioner/          # 配置工具
│   └── firmware-updater/           # 固件更新工具
│
├── pico-fido/                      # 上游项目（submodule）
│   └── ...
│
├── .gitignore                      # Git 忽略文件
├── .gitmodules                     # Git 子模块配置
├── LICENSE                         # 许可证
├── README.md                       # 项目说明（GitHub）
├── CONTRIBUTING.md                 # 贡献指南
├── CHANGELOG.md                    # 变更日志
├── SECURITY.md                     # 安全政策
└── CMakeLists.txt                  # CMake 配置
```

## 目录说明

### 核心目录

- **config/** - 所有配置文件，包括安全配置和分区表
- **src/** - 项目特定的源代码，主要是安全增强
- **scripts/** - 自动化脚本，简化构建和部署
- **docs/** - 完整的项目文档

### 开发目录

- **tests/** - 测试套件
- **tools/** - 开发和管理工具
- **hardware/** - 硬件设计文件

### GitHub 目录

- **.github/** - GitHub Actions 工作流和模板
- **pico-fido/** - 上游项目作为 Git submodule

## 文件组织原则

1. **配置分离** - 所有配置文件集中在 `config/` 目录
2. **文档完整** - 每个功能模块都有对应文档
3. **测试覆盖** - 重要功能都有测试用例
4. **工具化** - 常用操作都有脚本支持
