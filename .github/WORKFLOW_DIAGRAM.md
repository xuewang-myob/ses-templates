# Copilot Team-Based Review Workflow Diagram
# Copilot 团队审查工作流程图

## Workflow Flow / 工作流程

```
┌─────────────────────────────────────────────────────────────┐
│                    PR Event Triggered                        │
│                    PR 事件触发                                │
│  (opened / synchronize / reopened)                           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Job 1: check-team-membership                    │
│              作业 1: 检查团队成员资格                          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
         ┌───────────────────────────────┐
         │   Get PR Author & Team Slug   │
         │   获取 PR 作者和团队 slug      │
         └───────────────┬───────────────┘
                         │
                         ▼
         ┌───────────────────────────────┐
         │  Call GitHub Teams API        │
         │  调用 GitHub Teams API        │
         │  GET /orgs/{org}/teams/       │
         │      {team}/memberships/      │
         │      {username}               │
         └───────────────┬───────────────┘
                         │
                         ▼
              ┌──────────────────┐
              │  Is User Active  │
              │   Team Member?   │
              │  用户是否是团队   │
              │   活跃成员？      │
              └────┬────────┬────┘
                   │        │
              YES  │        │  NO
                   │        │
        ┌──────────▼────────▼─────────┐
        │                              │
        │                              │
┌───────▼──────────┐      ┌───────────▼────────┐
│ Job 2:           │      │ Job 3:              │
│ copilot-review   │      │ skip-review-        │
│                  │      │ notification        │
│ 作业2: Copilot   │      │ 作业3: 跳过审查通知  │
│ 审查             │      │                     │
└───────┬──────────┘      └───────────┬─────────┘
        │                             │
        ▼                             ▼
┌──────────────────┐      ┌──────────────────────┐
│ Checkout Code    │      │ Post Skip Comment    │
│ 检出代码          │      │ 发布跳过评论          │
└───────┬──────────┘      │                      │
        │                 │ "ℹ️ Review skipped"  │
        ▼                 │ because user is not  │
┌──────────────────┐      │ team member"         │
│ Get PR Diff      │      │                      │
│ 获取 PR 差异     │      │ "ℹ️ 审查已跳过，因为" │
└───────┬──────────┘      │ "用户不是团队成员"    │
        │                 └──────────────────────┘
        ▼
┌──────────────────┐
│ Read Instructions│
│ 读取审查指令      │
└───────┬──────────┘
        │
        ▼
┌──────────────────┐
│ Replace {PR_DIFF}│
│ Placeholder      │
│ 替换占位符        │
└───────┬──────────┘
        │
        ▼
┌──────────────────┐
│ Post Review      │
│ Comment with:    │
│ 发布审查评论包含: │
│                  │
│ • Code Quality   │
│ • Security       │
│ • Performance    │
│ • Testing        │
│ • Suggestions    │
│ • Rating         │
└──────────────────┘
```

## Decision Tree / 决策树

```
                    Start: PR Event
                    开始: PR 事件
                           │
                           ▼
                 ┌─────────────────┐
                 │ Is TEAM_SLUG    │
                 │ configured?     │
                 │ 团队slug已配置？ │
                 └────┬──────┬─────┘
                  NO  │      │  YES
                      │      │
                      ▼      ▼
              ┌───────────┐ ┌──────────────┐
              │Use default│ │Check team    │
              │team slug  │ │membership    │
              │使用默认   │ │检查团队成员   │
              └───────────┘ └──────┬───────┘
                                   │
                        ┌──────────┴──────────┐
                        │                     │
                   Member                 Not Member
                   是成员                   不是成员
                        │                     │
                        ▼                     ▼
              ┌──────────────────┐  ┌────────────────┐
              │ Run Full Review  │  │ Post Skip Note │
              │ 运行完整审查      │  │ 发布跳过通知    │
              └──────────────────┘  └────────────────┘
```

## Component Interaction / 组件交互

```
┌─────────────┐
│   GitHub    │
│   PR Event  │
│  PR 事件    │
└──────┬──────┘
       │ triggers / 触发
       │
       ▼
┌─────────────────────────────┐
│  GitHub Actions Workflow    │
│  GitHub Actions 工作流      │
│                             │
│  ┌─────────────────────┐   │
│  │ Environment Vars    │   │
│  │ 环境变量            │   │
│  │                     │   │
│  │ • TEAM_SLUG         │   │
│  │ • PR_AUTHOR         │   │
│  │ • ORG               │   │
│  └─────────────────────┘   │
│           │                 │
│           ▼                 │
│  ┌─────────────────────┐   │
│  │ GitHub Teams API    │   │
│  │ GitHub Teams API    │───┼──────► GitHub API
│  └─────────────────────┘   │         GitHub API
│           │                 │
│           ▼                 │
│  ┌─────────────────────┐   │
│  │ Conditional Logic   │   │
│  │ 条件逻辑            │   │
│  └─────────┬───────────┘   │
│            │                │
│     ┌──────┴──────┐        │
│     │             │         │
│     ▼             ▼         │
│ ┌───────┐   ┌─────────┐   │
│ │Review │   │  Skip   │   │
│ │审查   │   │  跳过   │   │
│ └───┬───┘   └────┬────┘   │
└─────┼────────────┼─────────┘
      │            │
      ▼            ▼
┌──────────────────────┐
│   PR Comment         │
│   PR 评论            │
│                      │
│ • Review results or  │
│ • Skip notification  │
│                      │
│ • 审查结果 或        │
│ • 跳过通知           │
└──────────────────────┘
```

## Data Flow / 数据流

```
┌────────────┐     ┌──────────────┐     ┌─────────────┐
│ Repository │────▶│    Workflow  │────▶│   GitHub    │
│   Config   │     │   Variables  │     │   Teams     │
│            │     │              │     │     API     │
│ 仓库配置   │     │  工作流变量   │     │  团队 API   │
└────────────┘     └──────────────┘     └──────┬──────┘
                                                │
                    ┌───────────────────────────┘
                    │
                    ▼
              ┌──────────────┐
              │ Membership   │
              │   Status     │
              │  成员资格     │
              │   状态       │
              └──────┬───────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
┌───────────────┐        ┌────────────────┐
│  .github/     │        │   PR Diff      │
│  copilot-     │        │   PR 差异      │
│  instructions │        │                │
│  .md          │        └────────┬───────┘
│               │                 │
│  审查指令     │                 │
└───────┬───────┘                 │
        │                         │
        └────────┬────────────────┘
                 │
                 ▼
        ┌─────────────────┐
        │  Review Comment │
        │  审查评论        │
        └─────────────────┘
```

## Timeline Example / 时间线示例

```
Time / 时间      Event / 事件
─────────────────────────────────────────────────────────
00:00           PR opened by team member
                团队成员创建 PR
                
00:01           Workflow triggered
                工作流触发
                
00:02           Check team membership
                检查团队成员资格
                ✅ PASS: User is team member
                通过: 用户是团队成员
                
00:03           Checkout code & get PR diff
                检出代码并获取 PR 差异
                
00:04           Load review instructions
                加载审查指令
                
00:05           Generate review with Copilot
                使用 Copilot 生成审查
                
00:06           Post review comment to PR
                发布审查评论到 PR
                ✅ Complete
                完成
                
─────────────────────────────────────────────────────────

Alternative scenario / 替代场景:

00:00           PR opened by non-team member
                非团队成员创建 PR
                
00:01           Workflow triggered
                工作流触发
                
00:02           Check team membership
                检查团队成员资格
                ❌ FAIL: User is not team member
                失败: 用户不是团队成员
                
00:03           Post skip notification
                发布跳过通知
                ✅ Complete
                完成
```

## Key Files / 关键文件

```
Repository / 仓库
│
├── .github/
│   ├── workflows/
│   │   └── copilot-review-team.yml     ⭐ Main workflow / 主工作流
│   │
│   ├── copilot-instructions.md         📝 Review template / 审查模板
│   ├── QUICK_START.md                  🚀 Quick setup / 快速设置
│   ├── COPILOT_TEAM_REVIEW_SETUP.md    📚 中文详细指南
│   ├── COPILOT_TEAM_REVIEW_SETUP_EN.md 📚 English guide
│   └── RULESET_CONFIGURATION.md        ⚙️ Alternative methods
│
└── [Repository Settings] / [仓库设置]
    └── Variables / 变量
        └── COPILOT_REVIEW_TEAM_SLUG    🔑 Team identifier / 团队标识
```

## Security Flow / 安全流程

```
┌──────────────────┐
│  GITHUB_TOKEN    │  ← Auto-provided by GitHub Actions
│  (Automatic)     │     GitHub Actions 自动提供
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Permissions     │
│  权限:           │
│                  │
│  • contents:read │  ← Read repo / 读取仓库
│  • pull-requests:│     
│    write         │  ← Comment on PRs / 评论 PR
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  API Call        │  ← Query team membership
│  API 调用        │     查询团队成员资格
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Audit Log       │  ← All actions logged
│  审计日志        │     所有操作都被记录
└──────────────────┘
```
