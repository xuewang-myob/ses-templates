# GitHub Actions Workflows

## copilot-review-team.yml

This workflow enables team-based GitHub Copilot PR auto review.

### Purpose

Only PRs created by members of a specific team will trigger automatic Copilot code reviews. This allows you to:
- Control which teams receive automatic reviews
- Manage review costs by limiting to specific teams
- Provide specialized reviews for different teams

### Configuration Required

1. **Repository Variable** (Required)
   - Name: `COPILOT_REVIEW_TEAM_SLUG`
   - Value: Your team slug (e.g., `frontend-team`, `backend-team`)
   - Location: Repository Settings → Secrets and variables → Actions → Variables

2. **Review Instructions** (Optional)
   - File: `.github/copilot-instructions.md` (already exists in this repo)
   - Can be customized for your needs
   - Use `{PR_DIFF}` placeholder where PR diff should be inserted

3. **Secret** (Optional)
   - Name: `COPILOT_REVIEW_INSTRUCTIONS`
   - Use this if you prefer to store instructions as a secret instead of in a file

### How to Find Your Team Slug

1. Go to your organization's Teams page: `https://github.com/orgs/YOUR-ORG/teams`
2. Click on the team you want to use
3. The URL will be: `https://github.com/orgs/YOUR-ORG/teams/TEAM-SLUG`
4. The `TEAM-SLUG` part is what you need

Example:
- URL: `https://github.com/orgs/myob/teams/platform-engineering`
- Team slug: `platform-engineering`

### Workflow Behavior

#### When PR is opened by team member:
1. ✅ Checks team membership - PASS
2. 🤖 Runs Copilot review
3. 💬 Posts detailed review comment with:
   - Code quality assessment
   - Security concerns
   - Performance issues
   - Testing suggestions
   - Specific improvement recommendations
   - Overall rating

#### When PR is opened by non-team member:
1. ❌ Checks team membership - FAIL
2. ⏭️ Skips Copilot review
3. 💬 Posts notification that review was skipped

### Troubleshooting

#### Issue: "Team not found" error

**Possible causes:**
- Team slug is incorrect
- Team doesn't exist in the organization
- Team name has changed

**Solution:**
1. Verify team slug in GitHub UI
2. Update `COPILOT_REVIEW_TEAM_SLUG` variable
3. Ensure there are no typos or extra spaces

#### Issue: "Insufficient permissions" error

**Possible causes:**
- `GITHUB_TOKEN` lacks team read permissions
- Organization settings restrict team information access

**Solution:**
1. Check organization Settings → Actions → General
2. Verify "Workflow permissions" includes content read
3. Check team visibility settings

#### Issue: Workflow doesn't trigger

**Possible causes:**
- Workflow file not in correct location
- YAML syntax error
- PR events not matching trigger conditions

**Solution:**
1. Verify file is at `.github/workflows/copilot-review-team.yml`
2. Check Actions tab for error messages
3. Validate YAML syntax: `yamllint .github/workflows/copilot-review-team.yml`

### Customization Options

#### 1. Change Trigger Events

Modify the `on:` section to change when the workflow runs:

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]
    # Add or remove events as needed
```

#### 2. Support Multiple Teams

Modify the team check step to accept multiple teams:

```yaml
env:
  TEAM_SLUGS: "team1,team2,team3"
```

Then update the checking logic to loop through teams.

#### 3. Customize Review Format

Modify the comment template in the "Run Copilot Review" step to change the format of review comments.

#### 4. Add Team-Specific Instructions

Create different instruction files for different teams and load them conditionally:

```yaml
- name: Load team-specific instructions
  run: |
    if [ "$TEAM_SLUG" == "frontend" ]; then
      cp .github/copilot-instructions-frontend.md .github/copilot-instructions.md
    elif [ "$TEAM_SLUG" == "backend" ]; then
      cp .github/copilot-instructions-backend.md .github/copilot-instructions.md
    fi
```

### Permissions

The workflow requires these permissions:

```yaml
permissions:
  contents: read        # To read repository contents
  pull-requests: write  # To post comments on PRs
```

These are automatically provided by `GITHUB_TOKEN`.

### Cost Considerations

- The workflow only runs when PRs are opened/updated
- Team membership check is a simple API call
- Actual review step only runs for team members
- Consider setting up review limits if needed

### Further Documentation

- [Quick Start Guide](../QUICK_START.md)
- [Detailed Setup Guide (Chinese)](../COPILOT_TEAM_REVIEW_SETUP.md)
- [Detailed Setup Guide (English)](../COPILOT_TEAM_REVIEW_SETUP_EN.md)
- [Ruleset Configuration](../RULESET_CONFIGURATION.md)

### Support

For issues or questions:
1. Check workflow run logs in Actions tab
2. Review this documentation
3. Contact repository administrators
4. Create an issue in the repository
