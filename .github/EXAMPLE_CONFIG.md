# Example Configuration / 配置示例

## Repository Variables / 仓库变量

These should be set in: **Settings → Secrets and variables → Actions → Variables**

### Required / 必需

```
COPILOT_REVIEW_TEAM_SLUG
```

**Description / 描述**: The slug of the team that should receive automatic Copilot reviews
**Example values / 示例值**:
- `frontend-team`
- `backend-team`
- `platform-engineering`
- `mobile-development`

### Optional / 可选

```
COPILOT_REVIEW_INSTRUCTIONS
```

**Description / 描述**: Custom review instructions (if not using `.github/copilot-instructions.md` file)
**Example value / 示例值**:
```
You are an expert code reviewer. Review the following pull request and provide:
1. Code quality assessment
2. Security concerns
3. Performance issues
4. Testing recommendations
5. Specific improvements

PR Diff:
{PR_DIFF}
```

---

## Configuration Examples by Organization / 按组织类型的配置示例

### Example 1: Small Startup / 小型创业公司

**Scenario / 场景**: One engineering team, want all PRs reviewed
**配置**: Single team gets all reviews

```yaml
# Repository Variable
COPILOT_REVIEW_TEAM_SLUG: "engineering"
```

### Example 2: Mid-size Company / 中型公司

**Scenario / 场景**: Multiple teams, only frontend team wants reviews
**配置**: Only frontend team members get reviews

```yaml
# Repository Variable
COPILOT_REVIEW_TEAM_SLUG: "frontend-team"
```

### Example 3: Large Organization / 大型组织

**Scenario / 场景**: Many teams, different teams for different repositories
**配置**: Different settings per repository

```yaml
# For frontend repositories
COPILOT_REVIEW_TEAM_SLUG: "frontend-engineers"

# For backend repositories
COPILOT_REVIEW_TEAM_SLUG: "backend-engineers"

# For platform repositories
COPILOT_REVIEW_TEAM_SLUG: "platform-team"
```

---

## Team Structure Examples / 团队结构示例

### Example 1: Feature Teams / 功能团队

```
Organization: myob
├── Team: payments-team          ← Use this slug
│   ├── alice
│   ├── bob
│   └── carol
│
├── Team: identity-team          ← Or this slug
│   ├── dave
│   ├── eve
│   └── frank
│
└── Team: platform-team          ← Or this slug
    ├── grace
    ├── henry
    └── iris
```

**Configuration for payments repository / 支付仓库配置**:
```yaml
COPILOT_REVIEW_TEAM_SLUG: "payments-team"
```

### Example 2: Role-Based Teams / 基于角色的团队

```
Organization: company
├── Team: senior-engineers       ← Experienced developers
│   ├── senior-dev-1
│   └── senior-dev-2
│
├── Team: junior-engineers       ← Need more review help
│   ├── junior-dev-1
│   └── junior-dev-2
│
└── Team: architects             ← Review critical changes
    ├── architect-1
    └── architect-2
```

**Use case / 用例**: Enable reviews for junior team who need more guidance
```yaml
COPILOT_REVIEW_TEAM_SLUG: "junior-engineers"
```

### Example 3: Mixed Structure / 混合结构

```
Organization: tech-company
├── Team: frontend
│   ├── Subteam: frontend-web
│   └── Subteam: frontend-mobile
│
├── Team: backend
│   ├── Subteam: backend-api
│   └── Subteam: backend-data
│
└── Team: all-engineers          ← Parent team
    └── (includes all above)
```

**Note / 注意**: GitHub Teams API doesn't support nested team queries directly. Use the specific team slug, not parent team.

---

## Custom Instructions Examples / 自定义指令示例

### Example 1: Security-Focused Review / 注重安全的审查

```markdown
# Security-Focused Code Review

Review this PR with emphasis on security:

## Security Checklist
- [ ] No hardcoded credentials or secrets
- [ ] Input validation implemented
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Authentication/authorization checks
- [ ] Sensitive data encryption
- [ ] Secure communication (HTTPS)

## Additional Checks
- Code quality
- Performance
- Testing

---
PR Diff:
{PR_DIFF}
```

### Example 2: Performance-Focused Review / 注重性能的审查

```markdown
# Performance-Focused Code Review

Review this PR with emphasis on performance:

## Performance Checklist
- [ ] No N+1 queries
- [ ] Efficient algorithms (O(n) vs O(n²))
- [ ] Proper caching strategies
- [ ] Database indexes
- [ ] Lazy loading where appropriate
- [ ] Minimal network requests
- [ ] Resource cleanup (memory leaks)
- [ ] Async operations where beneficial

## Additional Checks
- Code quality
- Security
- Testing

---
PR Diff:
{PR_DIFF}
```

### Example 3: Junior Developer Support / 初级开发者支持

```markdown
# Educational Code Review

This review is designed to help junior developers learn best practices:

## Review Focus
1. **Code Quality**
   - Explain why certain patterns are better
   - Suggest improvements with examples
   - Point out best practices

2. **Learning Opportunities**
   - Identify areas for improvement
   - Suggest resources for learning
   - Explain the "why" behind suggestions

3. **Positive Reinforcement**
   - Highlight good practices
   - Acknowledge improvements
   - Encourage continued growth

Please be constructive and educational in your feedback.

---
PR Diff:
{PR_DIFF}
```

### Example 4: Minimal Quick Review / 最小快速审查

```markdown
# Quick Code Review

Provide a brief review focusing on:
1. Critical issues only
2. Security vulnerabilities
3. Breaking changes

Keep it concise - under 10 points total.

PR Diff:
{PR_DIFF}
```

---

## Testing Configurations / 测试配置

### Test Setup 1: Single User Test / 单用户测试

1. Create a test team with just yourself
   创建只包含自己的测试团队

```bash
# GitHub UI steps:
# 1. Go to org → Teams → New team
# 2. Name: "copilot-test-team"
# 3. Add yourself as member
# 4. Set variable: COPILOT_REVIEW_TEAM_SLUG="copilot-test-team"
```

2. Create a test PR
   创建测试 PR

```bash
git checkout -b test-copilot-review
echo "# Test" > test-file.md
git add test-file.md
git commit -m "Test Copilot review workflow"
git push origin test-copilot-review
# Create PR on GitHub
```

3. Verify workflow runs
   验证工作流运行

- Check Actions tab
- Review should appear in PR comments

### Test Setup 2: Multiple Users Test / 多用户测试

1. Create test team with 2+ members
   创建包含2个以上成员的测试团队

2. Have team member create PR (should get review)
   让团队成员创建 PR（应该获得审查）

3. Have non-team member create PR (should skip)
   让非团队成员创建 PR（应该跳过）

4. Compare results
   比较结果

---

## Migration from Existing Setup / 从现有设置迁移

### If you're currently using repository-wide reviews / 如果当前使用仓库级审查

**Before / 之前**:
- All PRs get reviewed
- No team filtering

**After / 之后**:
- Only specific team PRs get reviewed
- More targeted reviews

**Steps / 步骤**:
1. Identify which team should receive reviews
   确定哪个团队应该接收审查
2. Set `COPILOT_REVIEW_TEAM_SLUG` variable
   设置变量
3. Deploy new workflow
   部署新工作流
4. Monitor and adjust as needed
   监控并根据需要调整

### If you're using manual reviews / 如果当前使用手动审查

**Before / 之前**:
- Manual code reviews only
- Time-consuming

**After / 之后**:
- Automated reviews for specific team
- Manual reviews still available

**Steps / 步骤**:
1. Start with one team as pilot
   从一个团队作为试点开始
2. Gather feedback
   收集反馈
3. Expand to other teams if successful
   如果成功则扩展到其他团队
4. Keep manual review as backup
   保留手动审查作为后备

---

## Troubleshooting Examples / 故障排除示例

### Problem 1: Team slug not working / 团队 slug 不起作用

```yaml
# ❌ Wrong - using team name with spaces
COPILOT_REVIEW_TEAM_SLUG: "Frontend Team"

# ✅ Correct - using team slug
COPILOT_REVIEW_TEAM_SLUG: "frontend-team"
```

### Problem 2: Wrong organization / 错误的组织

```yaml
# ❌ Wrong - trying to use team from different org
COPILOT_REVIEW_TEAM_SLUG: "other-org/frontend-team"

# ✅ Correct - just the team slug from current org
COPILOT_REVIEW_TEAM_SLUG: "frontend-team"
```

### Problem 3: Private team not accessible / 无法访问私有团队

**Solution / 解决方案**: Check team visibility settings

```bash
# Team visibility options:
# - Visible: Anyone can see team members
# - Secret: Only organization members can see team

# For workflow to work, team should be "Visible" or
# workflow should have appropriate permissions
```

---

## Best Practices / 最佳实践

### 1. Start Small / 从小开始

- Begin with one team
- Gather feedback
- Iterate and improve
- Expand gradually

### 2. Clear Communication / 清晰沟通

- Announce the change to team
- Explain how it works
- Provide documentation link
- Be available for questions

### 3. Monitor and Adjust / 监控和调整

- Check workflow success rate
- Review feedback quality
- Adjust instructions as needed
- Track time savings

### 4. Maintain Documentation / 维护文档

- Keep team slug updated
- Update instructions regularly
- Document any customizations
- Share learnings with team

---

## Additional Resources / 额外资源

- [Quick Start Guide](QUICK_START.md)
- [Workflow Diagram](WORKFLOW_DIAGRAM.md)
- [Ruleset Configuration](RULESET_CONFIGURATION.md)
- [GitHub Teams Documentation](https://docs.github.com/en/organizations/organizing-members-into-teams)
