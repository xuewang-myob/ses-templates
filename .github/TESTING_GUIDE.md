# Testing Guide for Team-Based Copilot Review
# 团队 Copilot 审查测试指南

## Pre-Testing Checklist / 测试前检查清单

- [ ] Workflow file exists at `.github/workflows/copilot-review-team.yml`
- [ ] Repository variable `COPILOT_REVIEW_TEAM_SLUG` is set
- [ ] Team exists in GitHub organization
- [ ] Team has at least one member
- [ ] `.github/copilot-instructions.md` file exists
- [ ] GitHub Actions are enabled for the repository

---

## Test Scenarios / 测试场景

### Test 1: Team Member Creates PR / 团队成员创建 PR

**Expected Result / 预期结果**: Copilot review should run and post detailed review

**Steps / 步骤**:

1. Ensure you are a member of the configured team
   确保您是配置的团队成员

2. Create a new branch
   创建新分支
   ```bash
   git checkout -b test/team-member-pr
   ```

3. Make a simple change
   进行简单更改
   ```bash
   echo "# Test by team member" > test-team-member.md
   git add test-team-member.md
   git commit -m "Test: Team member PR"
   git push origin test/team-member-pr
   ```

4. Create PR on GitHub
   在 GitHub 上创建 PR

5. Check Actions tab
   检查 Actions 标签
   - Workflow should start automatically
   - Check "Copilot PR Auto Review for Specific Team"

6. Verify the results
   验证结果
   - Job "check-team-membership" should pass
   - Job "copilot-review" should run
   - PR should have a detailed review comment

**Success Criteria / 成功标准**:
- ✅ Workflow completes successfully
- ✅ Review comment is posted
- ✅ Comment contains code quality assessment
- ✅ Comment indicates author is team member

---

### Test 2: Non-Team Member Creates PR / 非团队成员创建 PR

**Expected Result / 预期结果**: Review should be skipped with notification

**Steps / 步骤**:

1. Have a user who is NOT in the configured team create a PR
   让不在配置团队中的用户创建 PR

   Or, temporarily change `COPILOT_REVIEW_TEAM_SLUG` to a team you're not in
   或者，临时将 `COPILOT_REVIEW_TEAM_SLUG` 更改为您不在其中的团队

2. Create a new branch
   创建新分支
   ```bash
   git checkout -b test/non-team-member-pr
   ```

3. Make a simple change
   进行简单更改
   ```bash
   echo "# Test by non-team member" > test-non-team.md
   git add test-non-team.md
   git commit -m "Test: Non-team member PR"
   git push origin test/non-team-member-pr
   ```

4. Create PR on GitHub
   在 GitHub 上创建 PR

5. Check Actions tab
   检查 Actions 标签

6. Verify the results
   验证结果
   - Job "check-team-membership" should complete
   - Job "copilot-review" should be skipped
   - Job "skip-review-notification" should run
   - PR should have a skip notification comment

**Success Criteria / 成功标准**:
- ✅ Workflow completes successfully
- ✅ Skip notification is posted
- ✅ No detailed review is performed
- ✅ Comment explains review was skipped

---

### Test 3: PR Synchronization / PR 同步

**Expected Result / 预期结果**: Review runs again on new commits

**Steps / 步骤**:

1. Use an existing PR from a team member
   使用团队成员的现有 PR

2. Add a new commit
   添加新提交
   ```bash
   git checkout test/team-member-pr
   echo "Additional change" >> test-team-member.md
   git add test-team-member.md
   git commit -m "Test: Additional commit"
   git push origin test/team-member-pr
   ```

3. Check Actions tab
   检查 Actions 标签

4. Verify workflow runs again
   验证工作流再次运行

**Success Criteria / 成功标准**:
- ✅ Workflow triggers on new commit
- ✅ New review is posted (or existing one updated)
- ✅ Workflow completes successfully

---

### Test 4: Invalid Team Slug / 无效的团队 slug

**Expected Result / 预期结果**: Workflow should handle gracefully

**Steps / 步骤**:

1. Temporarily set invalid team slug
   临时设置无效的团队 slug
   ```yaml
   COPILOT_REVIEW_TEAM_SLUG: "nonexistent-team-slug"
   ```

2. Create a test PR
   创建测试 PR

3. Check Actions tab
   检查 Actions 标签

4. Review error handling
   查看错误处理

**Success Criteria / 成功标准**:
- ✅ Workflow doesn't crash
- ✅ Clear error message or skip notification
- ✅ No partial/broken comments on PR

---

### Test 5: Missing Configuration / 缺少配置

**Expected Result / 预期结果**: Workflow uses default or fails gracefully

**Steps / 步骤**:

1. Temporarily remove `COPILOT_REVIEW_TEAM_SLUG` variable
   临时删除变量

2. Create a test PR
   创建测试 PR

3. Check workflow behavior
   检查工作流行为

4. Restore variable
   恢复变量

**Success Criteria / 成功标准**:
- ✅ Workflow indicates configuration is missing
- ✅ Clear message about what's needed
- ✅ No confusing errors

---

### Test 6: Custom Instructions / 自定义指令

**Expected Result / 预期结果**: Custom instructions are used in review

**Steps / 步骤**:

1. Modify `.github/copilot-instructions.md`
   修改指令文件
   ```markdown
   # Custom Test Instructions
   
   Please review with focus on:
   - Testing practices
   - Documentation
   
   PR Diff:
   {PR_DIFF}
   ```

2. Create a test PR
   创建测试 PR

3. Verify review uses custom instructions
   验证审查使用自定义指令

4. Restore original instructions
   恢复原始指令

**Success Criteria / 成功标准**:
- ✅ Review reflects custom instructions
- ✅ All elements from instructions appear
- ✅ PR_DIFF placeholder is replaced

---

## Performance Testing / 性能测试

### Test 7: Workflow Execution Time / 工作流执行时间

**Goal / 目标**: Ensure workflow completes in reasonable time

**Steps / 步骤**:

1. Create test PR
   创建测试 PR

2. Note start time
   记录开始时间

3. Note completion time
   记录完成时间

4. Calculate duration
   计算持续时间

**Benchmarks / 基准**:
- ✅ Team check: < 10 seconds
- ✅ PR diff fetch: < 30 seconds
- ✅ Review generation: < 60 seconds
- ✅ Total time: < 2 minutes

---

### Test 8: Large PR Handling / 大型 PR 处理

**Goal / 目标**: Verify workflow handles large changes

**Steps / 步骤**:

1. Create PR with many files
   创建包含多个文件的 PR
   ```bash
   for i in {1..50}; do
     echo "File $i" > "test-file-$i.txt"
   done
   git add .
   git commit -m "Test: Large PR with 50 files"
   git push
   ```

2. Create PR and monitor workflow
   创建 PR 并监控工作流

3. Check if review handles all files
   检查审查是否处理所有文件

**Success Criteria / 成功标准**:
- ✅ Workflow completes without timeout
- ✅ Review covers all significant changes
- ✅ No truncation or errors

---

## Error Handling Testing / 错误处理测试

### Test 9: API Rate Limiting / API 速率限制

**Goal / 目标**: Verify graceful handling of rate limits

**Steps / 步骤**:

1. Create multiple PRs in quick succession
   快速连续创建多个 PR

2. Monitor for rate limit errors
   监控速率限制错误

3. Check error messages
   检查错误消息

**Success Criteria / 成功标准**:
- ✅ Clear error message if rate limited
- ✅ Workflow doesn't retry indefinitely
- ✅ User is informed about the issue

---

### Test 10: Network Failures / 网络故障

**Goal / 目标**: Verify resilience to network issues

**Note / 注意**: This is difficult to test directly, but check workflow logs for retry logic

**Success Criteria / 成功标准**:
- ✅ Workflow has timeout protection
- ✅ Clear error messages on failure
- ✅ Doesn't leave PR in unclear state

---

## Security Testing / 安全测试

### Test 11: Token Permissions / Token 权限

**Goal / 目标**: Verify minimal required permissions

**Steps / 步骤**:

1. Review workflow permissions
   查看工作流权限
   ```yaml
   permissions:
     contents: read
     pull-requests: write
   ```

2. Verify no additional permissions requested
   验证没有请求额外权限

3. Check Actions run logs for permission errors
   检查 Actions 运行日志中的权限错误

**Success Criteria / 成功标准**:
- ✅ Only necessary permissions used
- ✅ No overly broad permissions
- ✅ Workflow runs successfully with minimal permissions

---

### Test 12: Secret Handling / 密钥处理

**Goal / 目标**: Ensure no secrets leaked in logs

**Steps / 步骤**:

1. Create test PR
   创建测试 PR

2. Review workflow run logs
   查看工作流运行日志

3. Search for sensitive data
   搜索敏感数据
   - API tokens
   - Team member names (should be visible)
   - PR content (expected)

**Success Criteria / 成功标准**:
- ✅ No tokens visible in logs
- ✅ GitHub masks sensitive data automatically
- ✅ Only expected information is logged

---

## Integration Testing / 集成测试

### Test 13: Multiple Workflows / 多个工作流

**Goal / 目标**: Ensure no conflicts with other workflows

**Steps / 步骤**:

1. If repository has other workflows, create a PR
   如果仓库有其他工作流，创建 PR

2. Verify all workflows run
   验证所有工作流运行

3. Check for conflicts or interference
   检查冲突或干扰

**Success Criteria / 成功标准**:
- ✅ All workflows complete
- ✅ No resource conflicts
- ✅ No duplicate comments

---

### Test 14: GitHub Features Compatibility / GitHub 功能兼容性

**Goal / 目标**: Work with other GitHub features

**Test with / 测试项**:
- Draft PRs
- PR labels
- PR assignments
- Required reviews
- Branch protection

**Success Criteria / 成功标准**:
- ✅ Works with draft PRs
- ✅ Doesn't interfere with other features
- ✅ Respects branch protection rules

---

## Regression Testing / 回归测试

### Test 15: After Workflow Updates / 工作流更新后

**When / 时机**: After any changes to workflow file

**Steps / 步骤**:

1. Run all previous tests (Test 1-14)
   运行所有之前的测试

2. Document any changes in behavior
   记录行为的任何变化

3. Update documentation if needed
   如果需要更新文档

**Success Criteria / 成功标准**:
- ✅ All previous tests still pass
- ✅ New functionality works as expected
- ✅ No regressions introduced

---

## Test Reporting Template / 测试报告模板

```markdown
# Test Report / 测试报告

**Date / 日期**: YYYY-MM-DD
**Tester / 测试者**: [Your Name]
**Branch / 分支**: [Branch Name]
**Configuration / 配置**:
- Team Slug: [team-slug]
- Custom Instructions: [Yes/No]

## Test Results / 测试结果

| Test # | Test Name | Status | Notes |
|--------|-----------|--------|-------|
| 1 | Team Member PR | ✅/❌ | |
| 2 | Non-Team Member PR | ✅/❌ | |
| 3 | PR Synchronization | ✅/❌ | |
| 4 | Invalid Team Slug | ✅/❌ | |
| 5 | Missing Configuration | ✅/❌ | |
| 6 | Custom Instructions | ✅/❌ | |
| 7 | Execution Time | ✅/❌ | Duration: X seconds |
| 8 | Large PR Handling | ✅/❌ | |
| 9 | API Rate Limiting | ✅/❌ | |
| 10 | Network Failures | ✅/❌ | |
| 11 | Token Permissions | ✅/❌ | |
| 12 | Secret Handling | ✅/❌ | |
| 13 | Multiple Workflows | ✅/❌ | |
| 14 | GitHub Features | ✅/❌ | |
| 15 | Regression Testing | ✅/❌ | |

## Issues Found / 发现的问题

1. [Issue description]
2. [Issue description]

## Recommendations / 建议

1. [Recommendation]
2. [Recommendation]

## Overall Assessment / 总体评估

[Pass / Fail / Needs Improvement]
```

---

## Automated Testing Script / 自动化测试脚本

```bash
#!/bin/bash
# test-copilot-workflow.sh

set -e

echo "🧪 Starting Copilot Workflow Tests..."

# Configuration
TEAM_SLUG="${COPILOT_REVIEW_TEAM_SLUG:-your-team-slug}"
REPO_OWNER="${GITHUB_REPOSITORY_OWNER}"
REPO_NAME="${GITHUB_REPOSITORY##*/}"

# Test 1: Verify workflow file exists
echo "📁 Test 1: Checking workflow file..."
if [ -f ".github/workflows/copilot-review-team.yml" ]; then
    echo "✅ Workflow file exists"
else
    echo "❌ Workflow file not found"
    exit 1
fi

# Test 2: Verify YAML syntax
echo "📝 Test 2: Validating YAML syntax..."
if command -v yamllint &> /dev/null; then
    yamllint -d relaxed .github/workflows/copilot-review-team.yml
    echo "✅ YAML syntax valid"
else
    echo "⚠️  yamllint not found, skipping"
fi

# Test 3: Verify instructions file exists
echo "📋 Test 3: Checking instructions file..."
if [ -f ".github/copilot-instructions.md" ]; then
    echo "✅ Instructions file exists"
else
    echo "❌ Instructions file not found"
    exit 1
fi

# Test 4: Verify configuration
echo "⚙️  Test 4: Checking configuration..."
if [ -z "$TEAM_SLUG" ] || [ "$TEAM_SLUG" == "your-team-slug" ]; then
    echo "⚠️  COPILOT_REVIEW_TEAM_SLUG not set or using default"
else
    echo "✅ Team slug configured: $TEAM_SLUG"
fi

# Test 5: Check GitHub CLI availability
echo "🔧 Test 5: Checking GitHub CLI..."
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI available"
else
    echo "⚠️  GitHub CLI not found"
fi

echo ""
echo "✅ Basic tests completed!"
echo "📝 For full testing, create a PR and monitor the workflow."
```

---

## Continuous Monitoring / 持续监控

### Metrics to Track / 跟踪的指标

1. **Workflow Success Rate / 工作流成功率**
   - Target: > 95%

2. **Average Execution Time / 平均执行时间**
   - Target: < 2 minutes

3. **Review Quality / 审查质量**
   - Measure by developer feedback
   - Track false positives

4. **Adoption Rate / 采用率**
   - PRs reviewed vs total PRs
   - Team member participation

### Dashboard / 仪表板

Monitor via GitHub Actions page:
- Success/failure trends
- Execution time trends
- Most common errors

---

## Support and Feedback / 支持和反馈

If tests fail or you encounter issues:

1. **Check Workflow Logs / 检查工作流日志**
   - Actions tab → Failed run → View logs

2. **Review Configuration / 检查配置**
   - Verify all variables set correctly
   - Check team membership

3. **Consult Documentation / 查阅文档**
   - [Quick Start](QUICK_START.md)
   - [Setup Guide](COPILOT_TEAM_REVIEW_SETUP.md)

4. **Get Help / 获取帮助**
   - Contact repository administrators
   - Create an issue
   - Check GitHub Community forums
