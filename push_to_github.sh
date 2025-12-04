#!/bin/bash
# LoulanKey GitHub 推送脚本
# 
# 使用方法:
#   1. 编辑此文件，替换 YOUR_GITHUB_USERNAME
#   2. chmod +x push_to_github.sh
#   3. ./push_to_github.sh

set -e

# ============================================================================
# 配置区域 - 请修改这里
# ============================================================================

# 你的 GitHub 用户名
GITHUB_USERNAME="YOUR_GITHUB_USERNAME"

# 仓库名称（不要改，除非你想用其他名字）
REPO_NAME="LoulanKey"

# 仓库描述
REPO_DESCRIPTION="🔐 ESP32-S3 FIDO2 Security Authenticator - Open Source Hardware Security Key"

# ============================================================================
# 脚本开始 - 下面不需要修改
# ============================================================================

echo "╔════════════════════════════════════════════════════════════╗"
echo "║      LoulanKey GitHub 推送脚本                              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

# 检查用户名是否已设置
if [ "$GITHUB_USERNAME" = "YOUR_GITHUB_USERNAME" ]; then
    echo "❌ 错误: 请先编辑此脚本，设置你的 GitHub 用户名"
    echo "   编辑第 13 行: GITHUB_USERNAME=\"你的用户名\""
    exit 1
fi

echo "📋 配置信息:"
echo "   用户名: $GITHUB_USERNAME"
echo "   仓库名: $REPO_NAME"
echo "   描述: $REPO_DESCRIPTION"
echo

# 检查 git 状态
echo "🔍 检查 Git 仓库..."
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ 错误: 当前目录不是 Git 仓库"
    exit 1
fi

# 检查是否有未提交的更改
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  警告: 有未提交的更改"
    echo "是否要先提交? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git add .
        echo "请输入提交信息:"
        read -r commit_msg
        git commit -m "$commit_msg"
    fi
fi

echo "✅ Git 仓库检查通过"
echo

# 步骤 1: 使用 GitHub CLI 创建仓库（如果已安装）
echo "═══════════════════════════════════════════════════════════"
echo "步骤 1: 创建 GitHub 仓库"
echo "═══════════════════════════════════════════════════════════"

if command -v gh &> /dev/null; then
    echo "✨ 检测到 GitHub CLI (gh)"
    echo "正在创建仓库..."
    
    if gh repo create "$REPO_NAME" --public --description "$REPO_DESCRIPTION" --source=. --push; then
        echo "✅ 仓库创建并推送成功！"
        REPO_CREATED=true
    else
        echo "⚠️  GitHub CLI 创建失败，将使用手动方式"
        REPO_CREATED=false
    fi
else
    echo "ℹ️  未检测到 GitHub CLI"
    echo "   你可以安装 gh: https://cli.github.com/"
    REPO_CREATED=false
fi

# 步骤 2: 手动方式（如果 gh 不可用）
if [ "$REPO_CREATED" = false ]; then
    echo
    echo "请按照以下步骤操作:"
    echo
    echo "1️⃣  打开浏览器访问:"
    echo "   https://github.com/new"
    echo
    echo "2️⃣  填写仓库信息:"
    echo "   • Repository name: $REPO_NAME"
    echo "   • Description: $REPO_DESCRIPTION"
    echo "   • Public (公开)"
    echo "   • ⚠️  不要勾选 'Add a README file'"
    echo "   • ⚠️  不要选择 .gitignore"
    echo "   • ⚠️  不要选择 license"
    echo
    echo "3️⃣  点击 'Create repository'"
    echo
    echo "完成后按回车继续..."
    read -r

    echo
    echo "═══════════════════════════════════════════════════════════"
    echo "步骤 2: 添加远程仓库"
    echo "═══════════════════════════════════════════════════════════"
    
    REMOTE_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    
    # 检查是否已有 origin
    if git remote get-url origin > /dev/null 2>&1; then
        echo "⚠️  remote 'origin' 已存在，移除旧的..."
        git remote remove origin
    fi
    
    echo "添加远程仓库: $REMOTE_URL"
    git remote add origin "$REMOTE_URL"
    echo "✅ 远程仓库添加成功"
    echo
    
    echo "═══════════════════════════════════════════════════════════"
    echo "步骤 3: 推送代码"
    echo "═══════════════════════════════════════════════════════════"
    
    # 确保在 main 分支
    git branch -M main
    
    echo "正在推送到 GitHub..."
    echo "ℹ️  如果这是第一次推送，可能需要输入 GitHub 凭据"
    echo
    
    if git push -u origin main; then
        echo "✅ 代码推送成功！"
    else
        echo
        echo "❌ 推送失败"
        echo
        echo "可能的原因:"
        echo "1. 需要配置 GitHub 认证"
        echo "   • 使用 HTTPS: 需要 Personal Access Token"
        echo "   • 使用 SSH: 需要 SSH 密钥"
        echo
        echo "2. 配置 Personal Access Token:"
        echo "   a. 访问: https://github.com/settings/tokens/new"
        echo "   b. 选择 'repo' 权限"
        echo "   c. 生成 token"
        echo "   d. 使用 token 作为密码"
        echo
        echo "3. 或使用 SSH:"
        echo "   git remote set-url origin git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
        echo "   git push -u origin main"
        echo
        exit 1
    fi
fi

echo
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              🎉 推送成功！                                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo
echo "📊 仓库信息:"
echo "   • URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "   • Clone: git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo
echo "🚀 下一步建议:"
echo
echo "1️⃣  访问你的仓库:"
echo "   https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo
echo "2️⃣  配置仓库设置:"
echo "   • 添加 Topics: fido2, esp32-s3, security, webauthn, hardware-security"
echo "   • 设置 About 描述"
echo "   • 启用 Discussions"
echo "   • 启用 Issues"
echo
echo "3️⃣  将 README_GITHUB.md 重命名为 README.md:"
echo "   mv README_GITHUB.md README.md"
echo "   git add README.md"
echo "   git commit -m 'docs: update README for GitHub'"
echo "   git push"
echo
echo "4️⃣  创建第一个 Release:"
echo "   • 访问: https://github.com/$GITHUB_USERNAME/$REPO_NAME/releases/new"
echo "   • Tag: v1.0.0"
echo "   • Title: LoulanKey v1.0.0 - Initial Release"
echo "   • 描述发布内容"
echo
echo "═══════════════════════════════════════════════════════════"
echo "📧 需要帮助? contact@loulankey.com"
echo "═══════════════════════════════════════════════════════════"
