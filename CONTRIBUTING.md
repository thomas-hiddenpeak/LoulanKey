# 贡献指南

感谢你对 LoulanKey 项目的关注！我们欢迎各种形式的贡献。

## 🤝 如何贡献

### 报告 Bug

如果你发现了 Bug，请创建 Issue 并包含以下信息：

- **描述清晰**: 清楚描述问题
- **复现步骤**: 详细的复现步骤
- **预期行为**: 你期望发生什么
- **实际行为**: 实际发生了什么
- **环境信息**: 
  - ESP32-S3 板型号
  - ESP-IDF 版本
  - 操作系统
  - 相关日志

### 提交功能请求

创建 Issue 并说明：
- 功能描述
- 使用场景
- 预期效果
- 是否愿意自己实现

### 提交代码

1. **Fork 项目**
   ```bash
   git clone https://github.com/thomas-hiddenpeak/LoulanKey.git
   cd LoulanKey
   ```

2. **创建分支**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **进行修改**
   - 遵循代码规范
   - 添加必要的测试
   - 更新相关文档

4. **提交更改**
   ```bash
   git add .
   git commit -m "feat: add amazing feature"
   ```

5. **推送分支**
   ```bash
   git push origin feature/amazing-feature
   ```

6. **创建 Pull Request**
   - 清晰描述改动
   - 引用相关 Issue
   - 等待代码审查

## 📝 代码规范

### C/C++ 代码

- 使用 4 空格缩进
- 变量和函数使用 snake_case
- 常量使用 UPPER_SNAKE_CASE
- 添加必要的注释
- 遵循 ESP-IDF 编码规范

示例：
```c
// 良好的示例
static int secure_boot_enabled = 0;

int check_secure_boot_status(uint8_t *bootkey) {
    // 检查 Secure Boot 状态
    return otp_is_secure_boot_enabled(bootkey);
}
```

### Python 脚本

- 遵循 PEP 8
- 使用 4 空格缩进
- 添加类型注解

### 文档

- 使用 Markdown 格式
- 中英文之间加空格
- 添加适当的代码示例

## 🧪 测试

所有代码改动都应该包含测试：

```bash
# 运行单元测试
cd tests/unit
pytest

# 运行集成测试
cd tests/integration
./run_tests.sh
```

## 📋 提交信息规范

使用语义化提交信息：

- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `style:` 代码格式（不影响功能）
- `refactor:` 重构
- `test:` 测试相关
- `chore:` 构建/工具相关

示例：
```
feat: add NFC support for FIDO2

- Implement NFC NDEF reader
- Add APDU over NFC
- Update documentation

Closes #123
```

## 🔒 安全相关

如果你发现安全漏洞：

1. **不要公开讨论**
2. 通过 GitHub Security Advisories 私密报告
3. 包含详细的漏洞信息和复现步骤
4. 我们会尽快回复并处理

## 📄 许可证

提交代码即表示你同意：

- 你的贡献将遵循项目的 AGPLv3 许可证
- 你拥有该代码的版权或已获得授权
- 你的贡献可以被项目使用

## 🌟 行为准则

- 尊重所有贡献者
- 接受建设性批评
- 专注于对项目最有利的事
- 保持友好和专业

## 💬 沟通渠道

- **GitHub Issues**: Bug 报告和功能请求
- **GitHub Discussions**: 一般讨论和问答
- **Pull Requests**: 代码贡献

## 🎓 学习资源

新手贡献者可以从这些 Issue 开始：

- 查找标记为 `good first issue` 的问题
- 查找标记为 `help wanted` 的问题
- 阅读现有文档和代码

## ✅ 检查清单

提交 PR 前确认：

- [ ] 代码遵循项目规范
- [ ] 通过所有测试
- [ ] 更新了相关文档
- [ ] 添加了必要的测试
- [ ] 提交信息遵循规范
- [ ] PR 描述清晰

---

感谢你的贡献！ ❤️
