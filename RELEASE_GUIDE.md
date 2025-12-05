# Release Guide

本文档说明如何为 LoulanKey 项目创建新版本发布。

## 自动化发布流程

### 先决条件

- 拥有项目的写入权限
- 已完成所有待发布的代码更改和测试
- 已更新相关文档

### 创建新版本

#### 1. 准备发布

确保所有更改都已提交并推送到主分支：

```bash
git checkout main
git pull origin main
```

#### 2. 创建版本标签

使用语义化版本命名（Semantic Versioning）：

```bash
# 格式：v<major>.<minor>.<patch>
git tag -a v1.0.0 -m "Release version 1.0.0: Initial release with security features"
```

版本号规则：
- **Major (主版本号)**: 不兼容的 API 更改
- **Minor (次版本号)**: 向后兼容的功能新增
- **Patch (修订号)**: 向后兼容的问题修正

#### 3. 推送标签

```bash
git push origin v1.0.0
```

#### 4. 自动构建和发布

推送标签后，GitHub Actions 会自动：

1. ✅ 为 ESP32-S3 和 ESP32-S2 编译固件
2. ✅ 创建合并的二进制文件
3. ✅ 计算 SHA256 校验和
4. ✅ 自动创建 GitHub Release
5. ✅ 上传以下文件：
   - `pico_fido_esp32s3.bin` - ESP32-S3 固件
   - `pico_fido_esp32s2.bin` - ESP32-S2 固件
   - `SHA256SUMS.txt` - 校验和文件

#### 5. 验证发布

1. 访问 [Releases 页面](https://github.com/thomas-hiddenpeak/LoulanKey/releases)
2. 验证新版本已创建
3. 检查发布说明和附件文件

## 手动触发构建

如果需要测试构建流程而不创建正式发布：

1. 访问 [Actions 页面](https://github.com/thomas-hiddenpeak/LoulanKey/actions)
2. 选择 "Build and Release" workflow
3. 点击 "Run workflow" 按钮
4. 选择要运行的分支
5. 点击 "Run workflow" 确认

注意：手动触发的构建会创建构建产物，但不会自动创建 Release。

## 发布检查清单

在创建正式发布前，请确认：

- [ ] 所有测试通过
- [ ] 文档已更新
- [ ] CHANGELOG 已更新（如果有）
- [ ] 版本号符合语义化版本规范
- [ ] 安全特性正常工作
- [ ] 已在测试硬件上验证固件

## 撤销发布

如果发现问题需要撤销发布：

1. 在 GitHub 上删除 Release
2. 删除本地和远程标签：

```bash
# 删除本地标签
git tag -d v1.0.0

# 删除远程标签
git push origin --delete v1.0.0
```

## 热修复发布

对于紧急修复：

1. 从发布标签创建热修复分支：
   ```bash
   git checkout v1.0.0
   git checkout -b hotfix/v1.0.1
   ```

2. 进行修复并提交

3. 合并回主分支：
   ```bash
   git checkout main
   git merge hotfix/v1.0.1
   ```

4. 创建新的修订版本标签：
   ```bash
   git tag -a v1.0.1 -m "Hotfix: Critical security update"
   git push origin v1.0.1
   ```

## 构建失败排查

如果自动构建失败：

1. 查看 [Actions 页面](https://github.com/thomas-hiddenpeak/LoulanKey/actions) 的构建日志
2. 常见问题：
   - ESP-IDF 版本不兼容：更新 `.github/workflows/build-and-release.yml` 中的版本
   - 依赖项缺失：更新依赖项安装步骤
   - 编译错误：检查代码兼容性

3. 修复问题后，可以：
   - 创建新的标签（增加修订号）
   - 或者删除旧标签，修复后重新创建相同标签

## 版本历史

维护者可在此处记录版本发布历史。

示例格式：
| 版本 | 日期 | 主要更新 |
|------|------|----------|
| v1.0.0 | 2024-XX-XX | 初始发布，包含完整的安全特性 |

## 相关资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [语义化版本](https://semver.org/lang/zh-CN/)
- [ESP-IDF 发布说明](https://github.com/espressif/esp-idf/releases)
