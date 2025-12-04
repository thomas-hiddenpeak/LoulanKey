# LoulanKey GitHub 推送指南

## 🚀 快速推送（3种方法）

### 方法 1：使用推送脚本（推荐）⭐

```bash
cd /Users/thomas/esp32s3-fido2

# 1. 编辑脚本，设置你的 GitHub 用户名
nano push_to_github.sh
# 或
vim push_to_github.sh
# 修改第 13 行: GITHUB_USERNAME="你的用户名"

# 2. 运行脚本
./push_to_github.sh
```

### 方法 2：使用 GitHub CLI（最简单）

如果你安装了 GitHub CLI (`gh`):

```bash
cd /Users/thomas/esp32s3-fido2

# 登录 GitHub（首次使用）
gh auth login

# 创建仓库并推送（一条命令搞定！）
gh repo create LoulanKey \
  --public \
  --description "🔐 ESP32-S3 FIDO2 Security Authenticator" \
  --source=. \
  --push
```

安装 GitHub CLI:
```bash
# macOS
brew install gh

# 或访问: https://cli.github.com/
```

### 方法 3：手动方式

#### 步骤 1: 在 GitHub 创建仓库

1. 访问 https://github.com/new
2. 填写：
   - **Repository name**: `LoulanKey`
   - **Description**: `🔐 ESP32-S3 FIDO2 Security Authenticator`
   - 选择 **Public**
   - ⚠️ **不要**勾选任何初始化选项
3. 点击 **Create repository**

#### 步骤 2: 推送代码

```bash
cd /Users/thomas/esp32s3-fido2

# 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/LoulanKey.git

# 推送代码
git branch -M main
git push -u origin main
```

## 🔐 认证配置

### 使用 HTTPS（推荐）

首次推送会要求输入凭据：

1. **用户名**: 你的 GitHub 用户名
2. **密码**: ⚠️ **不是**你的登录密码，而是 **Personal Access Token**

#### 创建 Personal Access Token:

1. 访问: https://github.com/settings/tokens/new
2. 填写：
   - **Note**: `LoulanKey Development`
   - **Expiration**: 选择有效期
   - **Select scopes**: 勾选 `repo` （全部权限）
3. 点击 **Generate token**
4. **复制并保存** token（只显示一次！）
5. 使用 token 作为密码

#### 保存凭据（避免重复输入）:

```bash
# macOS/Linux
git config --global credential.helper store

# 首次输入后会自动保存
```

### 使用 SSH（高级用户）

```bash
# 1. 生成 SSH 密钥（如果还没有）
ssh-keygen -t ed25519 -C "your_email@example.com"

# 2. 查看公钥
cat ~/.ssh/id_ed25519.pub

# 3. 添加到 GitHub
# 访问: https://github.com/settings/ssh/new
# 粘贴公钥

# 4. 测试连接
ssh -T git@github.com

# 5. 使用 SSH URL
git remote set-url origin git@github.com:YOUR_USERNAME/LoulanKey.git
git push -u origin main
```

## ✅ 推送后的配置

### 1. 重命名 README

```bash
cd /Users/thomas/esp32s3-fido2
mv README_GITHUB.md README.md
rm README.md.bak  # 如果有的话
git add README.md
git commit -m "docs: use GitHub README as main README"
git push
```

### 2. 配置仓库设置

访问: `https://github.com/YOUR_USERNAME/LoulanKey/settings`

#### About 部分:
- **Website**: https://loulankey.com
- **Topics**: 
  - `fido2`
  - `esp32-s3`
  - `security`
  - `webauthn`
  - `authentication`
  - `hardware-security`
  - `iot-security`
  - `cryptography`
  - `embedded-systems`
  - `open-hardware`

#### Features:
- ✅ Issues
- ✅ Discussions
- ❌ Projects（可选）
- ❌ Wiki（可选，我们已有完整文档）

### 3. 创建 Release

访问: `https://github.com/YOUR_USERNAME/LoulanKey/releases/new`

```markdown
Tag: v1.0.0
Release title: LoulanKey v1.0.0 - Initial Release 🎉

## 🌟 首次发布

LoulanKey 是基于 ESP32-S3 的开源 FIDO2 硬件安全密钥，提供企业级安全特性。

### ✨ 主要特性

- ✅ 完整的 FIDO2/WebAuthn 支持
- ✅ Secure Boot V2 (RSA-3072)
- ✅ Flash 加密 (AES-256-XTS)
- ✅ eFuse 密钥保护
- ✅ 硬件加密加速
- ✅ 生产就绪的安全配置

### 📦 包含内容

- 完整的源代码和安全增强
- 35+ 页详细文档
- 自动化部署脚本
- 生产配置文件

### 📚 快速开始

查看 [快速开始指南](https://github.com/YOUR_USERNAME/LoulanKey#-快速开始)

### 🔗 相关链接

- [项目文档](https://github.com/YOUR_USERNAME/LoulanKey/tree/main/docs)
- [安全分析](SECURITY_GAPS_ANALYSIS.md)
- [贡献指南](CONTRIBUTING.md)

### 🙏 致谢

基于优秀的 [pico-fido](https://github.com/polhenarejos/pico-fido) 项目。
```

## 🐛 常见问题

### Q: 推送时提示 "Permission denied"

**A**: 检查认证配置
```bash
# 使用 HTTPS + Token
git remote -v
# 应该显示 https://github.com/...

# 或使用 SSH
git remote set-url origin git@github.com:YOUR_USERNAME/LoulanKey.git
```

### Q: 推送时提示 "remote: Repository not found"

**A**: 
1. 确认仓库已在 GitHub 创建
2. 检查 URL 是否正确
```bash
git remote -v
```

### Q: 如何删除重来？

**A**:
```bash
# 删除远程仓库（在 GitHub 网页上）
# https://github.com/YOUR_USERNAME/LoulanKey/settings

# 删除本地 remote 配置
git remote remove origin

# 重新开始
```

### Q: 推送被拒绝 "non-fast-forward"

**A**:
```bash
# 如果 GitHub 仓库有额外提交（如 LICENSE），拉取合并
git pull origin main --allow-unrelated-histories
git push -u origin main
```

## 📞 需要帮助？

- 📧 Email: contact@loulankey.com
- 💬 GitHub Discussions: 推送后在仓库中启用
- 📖 文档: 查看项目中的 `.md` 文件

---

**Good luck! 🚀**
