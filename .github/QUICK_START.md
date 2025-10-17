# Quick Start - Team-Based Copilot PR Review
# 快速开始 - 基于团队的 Copilot PR 审查

## 🚀 快速配置 / Quick Setup

### 中文版本

**3 步启用团队专属 Copilot 审查：**

1. **获取团队 slug**
   ```
   https://github.com/orgs/your-org/teams/your-team-name
                                            ^^^^^^^^^^^^^^
                                            这就是 team slug
   ```

2. **设置仓库变量**
   - 进入: `Settings` → `Secrets and variables` → `Actions` → `Variables`
   - 点击 `New repository variable`
   - 名称: `COPILOT_REVIEW_TEAM_SLUG`
   - 值: 您的团队 slug (例如: `frontend-team`)
   - 点击 `Add variable`

3. **完成！**
   - 工作流已经配置好，位于 `.github/workflows/copilot-review-team.yml`
   - 只有指定团队成员创建的 PR 才会触发自动审查
   - 其他人的 PR 会收到跳过通知

---

### English Version

**Enable team-specific Copilot review in 3 steps:**

1. **Get your team slug**
   ```
   https://github.com/orgs/your-org/teams/your-team-name
                                            ^^^^^^^^^^^^^^
                                            This is the team slug
   ```

2. **Set repository variable**
   - Go to: `Settings` → `Secrets and variables` → `Actions` → `Variables`
   - Click `New repository variable`
   - Name: `COPILOT_REVIEW_TEAM_SLUG`
   - Value: Your team slug (e.g., `frontend-team`)
   - Click `Add variable`

3. **Done!**
   - Workflow is already configured at `.github/workflows/copilot-review-team.yml`
   - Only PRs from specified team members will trigger auto-review
   - Other PRs will receive a skip notification

---

## 📋 验证配置 / Verify Configuration

### 测试步骤 / Test Steps

1. **团队成员创建 PR / Team member creates PR**
   ```bash
   git checkout -b test-copilot-review
   echo "test" >> test.txt
   git add test.txt
   git commit -m "Test Copilot review"
   git push origin test-copilot-review
   # 创建 PR / Create PR on GitHub
   ```

2. **检查工作流 / Check workflow**
   - 进入 PR 页面 / Go to PR page
   - 查看 "Checks" 标签 / View "Checks" tab
   - 应该看到 "Copilot PR Auto Review for Specific Team" 运行
   - Should see "Copilot PR Auto Review for Specific Team" running

3. **查看结果 / View results**
   - 团队成员的 PR 应该收到自动审查评论
   - Team member's PR should receive auto-review comment
   - 非团队成员的 PR 应该收到跳过通知
   - Non-team member's PR should receive skip notification

---

## 🔧 高级配置 / Advanced Configuration

### 自定义审查指令 / Customize Review Instructions

编辑文件 / Edit file: `.github/copilot-instructions.md`

当前指令 / Current instructions:
- 代码质量检查 / Code quality check
- 安全性审查 / Security review
- 性能分析 / Performance analysis
- 测试覆盖率 / Test coverage
- 最佳实践建议 / Best practice suggestions

### 修改工作流触发条件 / Modify Workflow Triggers

编辑文件 / Edit file: `.github/workflows/copilot-review-team.yml`

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
    # 添加更多触发条件 / Add more triggers:
    # - labeled
    # - ready_for_review
```

### 支持多个团队 / Support Multiple Teams

修改工作流以支持多个团队 / Modify workflow to support multiple teams:

```yaml
env:
  TEAM_SLUGS: "team1,team2,team3"  # 逗号分隔 / Comma-separated
```

---

## 📚 详细文档 / Detailed Documentation

- **完整配置指南 / Full Setup Guide**
  - [中文版 / Chinese](.github/COPILOT_TEAM_REVIEW_SETUP.md)
  - [English Version](.github/COPILOT_TEAM_REVIEW_SETUP_EN.md)

- **Ruleset 配置 / Ruleset Configuration**
  - [详细说明 / Details](.github/RULESET_CONFIGURATION.md)

---

## ❓ 常见问题 / FAQ

### Q: 如何找到团队 slug？/ How to find team slug?

**A:** 访问团队页面，URL 中的最后部分就是 slug / Visit team page, the last part of URL is the slug:
```
https://github.com/orgs/myorg/teams/frontend-developers
                                     ^^^^^^^^^^^^^^^^^^^
                                     这是 slug / This is slug
```

### Q: 工作流没有运行？/ Workflow not running?

**A:** 检查 / Check:
1. 工作流文件是否在 `.github/workflows/` 目录
2. 仓库变量 `COPILOT_REVIEW_TEAM_SLUG` 是否设置
3. 工作流权限是否正确配置

### Q: 如何禁用某个 PR 的自动审查？/ How to disable auto-review for a PR?

**A:** 两种方法 / Two methods:
1. 在 PR 标题添加 `[skip ci]` / Add `[skip ci]` to PR title
2. 修改工作流添加条件检查 / Modify workflow to add conditional check

### Q: 可以为不同团队设置不同的审查规则吗？/ Can different teams have different review rules?

**A:** 可以！修改工作流，根据团队加载不同的指令文件 / Yes! Modify workflow to load different instruction files based on team:

```yaml
- name: Load team-specific instructions
  run: |
    if [ "$TEAM_SLUG" == "frontend-team" ]; then
      cp .github/copilot-instructions-frontend.md .github/copilot-instructions.md
    elif [ "$TEAM_SLUG" == "backend-team" ]; then
      cp .github/copilot-instructions-backend.md .github/copilot-instructions.md
    fi
```

---

## 🛟 获取帮助 / Get Help

遇到问题？/ Having issues?

1. 查看工作流日志 / Check workflow logs
   - 进入 `Actions` 标签 / Go to `Actions` tab
   - 点击失败的工作流运行 / Click failed workflow run
   - 查看详细日志 / View detailed logs

2. 检查权限 / Check permissions
   - 组织设置 / Organization settings
   - 仓库设置 / Repository settings
   - 团队权限 / Team permissions

3. 联系管理员 / Contact administrators
   - 仓库管理员 / Repository admins
   - 组织管理员 / Organization admins

---

## ✅ 配置检查清单 / Configuration Checklist

- [ ] 已创建或选择目标团队 / Created or selected target team
- [ ] 已记录团队 slug / Noted team slug
- [ ] 已在仓库中设置 `COPILOT_REVIEW_TEAM_SLUG` 变量 / Set `COPILOT_REVIEW_TEAM_SLUG` variable in repository
- [ ] 工作流文件存在于 `.github/workflows/` / Workflow file exists in `.github/workflows/`
- [ ] 已确认 `.github/copilot-instructions.md` 存在 / Confirmed `.github/copilot-instructions.md` exists
- [ ] 已测试团队成员的 PR / Tested PR from team member
- [ ] 已测试非团队成员的 PR / Tested PR from non-team member
- [ ] 工作流正常运行 / Workflow runs successfully

---

**准备好了吗？开始使用吧！🎉**
**Ready? Let's get started! 🎉**
