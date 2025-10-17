# GitHub Ruleset 配置指南 / Ruleset Configuration Guide

## 中文说明

### 使用 GitHub Rulesets 限制 Copilot 审查到特定团队

GitHub Rulesets 是 GitHub 原生功能，可以基于条件应用规则。虽然 Rulesets 本身不直接支持"仅对特定团队运行 Copilot 审查"，但可以通过以下方法实现类似效果：

#### 方法 1: 结合 Rulesets 和 GitHub Actions（推荐）

这是本仓库采用的方法，已在 `.github/workflows/copilot-review-team.yml` 中实现。

**优势**：
- 灵活性高
- 可以精确控制哪些团队触发审查
- 易于维护和更新

**配置步骤**：
1. 参考 `COPILOT_TEAM_REVIEW_SETUP.md` 文件
2. 设置仓库变量 `COPILOT_REVIEW_TEAM_SLUG`
3. 工作流会自动检查 PR 作者的团队成员资格

#### 方法 2: 使用 Branch Protection Rules + Required Workflows

如果您想使用 GitHub 的原生功能：

1. **创建分支保护规则**
   - 进入仓库 Settings → Branches
   - 添加 branch protection rule
   - 目标分支：`main` 或其他主分支

2. **设置 Required Workflows（仅限 GitHub Enterprise）**
   - 如果您的组织使用 GitHub Enterprise，可以配置 required workflows
   - 在组织级别设置必需的工作流程
   - 可以针对特定团队应用

3. **配置 CODEOWNERS**
   - 创建 `.github/CODEOWNERS` 文件
   - 指定团队作为代码所有者
   - 结合分支保护规则要求团队审查

示例 CODEOWNERS 文件：
```
# 所有文件都需要 frontend-team 的审查
* @your-org/frontend-team
```

#### 方法 3: 使用 GitHub Ruleset 的目标条件

GitHub Rulesets 支持基于以下条件的定位：
- 分支名称模式
- 标签名称模式
- 仓库属性

**当前限制**：
- Rulesets 不直接支持"团队成员资格"作为条件
- 无法直接在 ruleset 中指定"仅对特定团队的 PR 运行操作"

**变通方法**：
1. 要求特定团队在特定分支上工作
2. 创建针对这些分支的 ruleset
3. 在这些分支上启用 Copilot 审查

### 推荐配置流程

对于您的需求（"只给某一个 team 的 PR 开启 copilot PR auto review"），我们推荐：

1. **使用本仓库提供的 GitHub Actions 工作流**
   - 文件：`.github/workflows/copilot-review-team.yml`
   - 配置文件：`COPILOT_TEAM_REVIEW_SETUP.md`

2. **配置步骤**：
   ```bash
   # 1. 确定团队 slug
   TEAM_SLUG="your-team-name"
   
   # 2. 在仓库中设置变量
   # Settings → Secrets and variables → Actions → Variables
   # 添加：COPILOT_REVIEW_TEAM_SLUG = your-team-name
   
   # 3. 确保 .github/copilot-instructions.md 存在
   # 这个文件已经存在于您的仓库中
   
   # 4. 提交并推送工作流文件
   git add .github/workflows/copilot-review-team.yml
   git commit -m "Add team-based Copilot review workflow"
   git push
   ```

3. **验证配置**：
   - 让团队成员创建测试 PR
   - 检查工作流是否正确运行
   - 确认只有团队成员的 PR 触发审查

---

## English Version

### Limiting Copilot Review to Specific Team Using GitHub Rulesets

GitHub Rulesets are native GitHub features that can apply rules based on conditions. While Rulesets don't directly support "run Copilot review only for specific team," you can achieve similar effects through:

#### Method 1: Combine Rulesets with GitHub Actions (Recommended)

This is the approach used in this repository, implemented in `.github/workflows/copilot-review-team.yml`.

**Advantages**:
- High flexibility
- Precise control over which teams trigger reviews
- Easy to maintain and update

**Configuration Steps**:
1. Refer to `COPILOT_TEAM_REVIEW_SETUP_EN.md` file
2. Set repository variable `COPILOT_REVIEW_TEAM_SLUG`
3. Workflow automatically checks PR author's team membership

#### Method 2: Use Branch Protection Rules + Required Workflows

If you want to use GitHub's native features:

1. **Create Branch Protection Rules**
   - Go to repository Settings → Branches
   - Add branch protection rule
   - Target branch: `main` or other primary branch

2. **Set Required Workflows (GitHub Enterprise Only)**
   - If your organization uses GitHub Enterprise, you can configure required workflows
   - Set required workflows at organization level
   - Can be applied to specific teams

3. **Configure CODEOWNERS**
   - Create `.github/CODEOWNERS` file
   - Specify team as code owners
   - Combine with branch protection rules to require team review

Example CODEOWNERS file:
```
# All files require review from frontend-team
* @your-org/frontend-team
```

#### Method 3: Use GitHub Ruleset Targeting Conditions

GitHub Rulesets support targeting based on:
- Branch name patterns
- Tag name patterns
- Repository properties

**Current Limitations**:
- Rulesets don't directly support "team membership" as a condition
- Cannot directly specify in ruleset "run action only for specific team's PRs"

**Workaround**:
1. Require specific team to work on specific branches
2. Create rulesets for those branches
3. Enable Copilot review on those branches

### Recommended Configuration Process

For your requirement ("enable copilot PR auto review only for a specific team's PRs"), we recommend:

1. **Use the GitHub Actions workflow provided in this repository**
   - File: `.github/workflows/copilot-review-team.yml`
   - Configuration guide: `COPILOT_TEAM_REVIEW_SETUP_EN.md`

2. **Configuration Steps**:
   ```bash
   # 1. Determine team slug
   TEAM_SLUG="your-team-name"
   
   # 2. Set variable in repository
   # Settings → Secrets and variables → Actions → Variables
   # Add: COPILOT_REVIEW_TEAM_SLUG = your-team-name
   
   # 3. Ensure .github/copilot-instructions.md exists
   # This file already exists in your repository
   
   # 4. Commit and push workflow file
   git add .github/workflows/copilot-review-team.yml
   git commit -m "Add team-based Copilot review workflow"
   git push
   ```

3. **Verify Configuration**:
   - Have team member create test PR
   - Check if workflow runs correctly
   - Confirm only team members' PRs trigger review

---

## 技术细节 / Technical Details

### 工作流工作原理 / How the Workflow Works

1. **触发器 / Trigger**: PR opened, synchronized, or reopened
2. **团队检查 / Team Check**: Uses GitHub API to verify team membership
3. **条件执行 / Conditional Execution**: Review runs only if author is team member
4. **结果发布 / Result Publishing**: Review posted as PR comment

### 所需权限 / Required Permissions

```yaml
permissions:
  contents: read        # Read repository content
  pull-requests: write  # Post comments on PRs
```

### 环境变量 / Environment Variables

- `COPILOT_REVIEW_TEAM_SLUG`: Team slug to check membership (required)
- `COPILOT_REVIEW_INSTRUCTIONS`: Custom review instructions (optional)

### API 使用 / API Usage

The workflow uses GitHub's REST API:
```
GET /orgs/{org}/teams/{team_slug}/memberships/{username}
```

This checks if a user is an active member of the specified team.

## 故障排除 / Troubleshooting

### Common Issues

1. **403 Forbidden Error**
   - Cause: Insufficient permissions
   - Solution: Check organization and repository settings

2. **Team Not Found**
   - Cause: Incorrect team slug
   - Solution: Verify team slug in organization settings

3. **Workflow Not Triggering**
   - Cause: Workflow file not in correct location
   - Solution: Ensure file is in `.github/workflows/` directory

## 参考链接 / Reference Links

- [GitHub Rulesets Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
- [GitHub Teams API](https://docs.github.com/en/rest/teams)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)
