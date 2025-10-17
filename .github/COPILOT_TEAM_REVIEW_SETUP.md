# Copilot PR 自动审查 - 团队配置指南

## 概述

此配置允许您为特定团队启用 GitHub Copilot 的 PR 自动审查功能。只有指定团队的成员创建的 PR 才会自动触发 Copilot 审查。

## 配置步骤

### 1. 创建或选择目标团队

首先，您需要在 GitHub 组织中创建一个团队，或使用现有团队：

1. 进入您的 GitHub 组织页面
2. 点击 "Teams" 标签
3. 创建新团队或选择现有团队
4. 记录团队的 **slug**（团队的 URL 标识符）
   - 例如：如果团队 URL 是 `https://github.com/orgs/myorg/teams/frontend-team`
   - 那么团队 slug 就是 `frontend-team`

### 2. 配置仓库变量

在您的 GitHub 仓库中设置必要的变量：

1. 进入仓库的 **Settings** → **Secrets and variables** → **Actions**
2. 点击 **Variables** 标签
3. 添加新的仓库变量：
   - **名称**: `COPILOT_REVIEW_TEAM_SLUG`
   - **值**: 您的团队 slug（例如：`frontend-team`）

### 3. 配置团队权限

确保 GitHub Actions 有权限查询团队成员资格：

1. 进入组织的 **Settings** → **Actions** → **General**
2. 在 "Workflow permissions" 部分，确保已启用：
   - "Read repository contents and packages permissions"
3. 如果需要，可以在团队设置中调整可见性

### 4. （可选）自定义审查指令

如果您想自定义 Copilot 的审查指令：

1. 编辑 `.github/copilot-instructions.md` 文件
2. 在文件中使用 `{PR_DIFF}` 占位符来插入 PR 差异
3. 或者，创建一个 secret：
   - **名称**: `COPILOT_REVIEW_INSTRUCTIONS`
   - **值**: 您的自定义审查指令

## 工作流程说明

### 触发条件

工作流程在以下情况下触发：
- 新 PR 被打开 (opened)
- PR 有新的提交 (synchronize)
- PR 被重新打开 (reopened)

### 执行流程

1. **检查团队成员资格**
   - 系统自动检查 PR 作者是否是指定团队的成员
   - 使用 GitHub API 验证成员资格状态

2. **条件执行审查**
   - 如果作者是团队成员：运行 Copilot 自动审查
   - 如果作者不是团队成员：跳过审查并发送通知

3. **发布审查结果**
   - 审查结果会作为评论发布到 PR 中
   - 评论包含代码质量、安全性和最佳实践的建议

## 配置示例

### 示例 1：单个团队

```yaml
# 在仓库变量中设置
COPILOT_REVIEW_TEAM_SLUG: "backend-team"
```

### 示例 2：前端团队

```yaml
COPILOT_REVIEW_TEAM_SLUG: "frontend-team"
```

## 故障排除

### 问题：工作流程无法检查团队成员资格

**解决方案**：
1. 确认团队 slug 拼写正确
2. 确认 `GITHUB_TOKEN` 有足够的权限
3. 检查团队在组织中的可见性设置

### 问题：所有 PR 都被跳过审查

**解决方案**：
1. 确认仓库变量 `COPILOT_REVIEW_TEAM_SLUG` 已正确设置
2. 确认 PR 作者确实是团队成员
3. 检查团队成员的状态是否为 "active"

### 问题：审查指令未正确加载

**解决方案**：
1. 确认 `.github/copilot-instructions.md` 文件存在
2. 检查文件内容格式是否正确
3. 确保文件中包含 `{PR_DIFF}` 占位符

## 扩展配置

### 支持多个团队

如果您想为多个团队启用此功能，可以修改工作流程文件：

```yaml
# 在 check-team-membership 步骤中
TEAMS: "team1,team2,team3"  # 逗号分隔的团队列表
```

然后更新检查逻辑以循环检查多个团队。

### 自定义审查规则

您可以根据不同的团队设置不同的审查规则：

1. 为每个团队创建单独的 copilot-instructions 文件
2. 在工作流程中根据团队动态加载相应的指令文件

## 安全注意事项

1. **Token 权限**：确保 `GITHUB_TOKEN` 只有必要的权限
2. **团队可见性**：考虑团队的可见性对工作流程的影响
3. **审查内容**：审查指令不应包含敏感信息

## 维护和更新

定期检查和更新：
- 团队成员列表
- 审查指令
- 工作流程配置

## 参考资源

- [GitHub Teams 文档](https://docs.github.com/en/organizations/organizing-members-into-teams)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [GitHub API - Teams](https://docs.github.com/en/rest/teams)

## 支持

如有问题或需要帮助，请：
1. 查看工作流程运行日志
2. 检查仓库的 Actions 标签页
3. 联系仓库管理员或团队负责人
