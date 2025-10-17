# Copilot PR Auto Review - Team Configuration Guide

## Overview

This configuration allows you to enable GitHub Copilot PR auto review for a specific team. Only PRs created by members of the specified team will trigger automatic Copilot reviews.

## Setup Steps

### 1. Create or Select Target Team

First, you need to create a team in your GitHub organization or use an existing one:

1. Go to your GitHub organization page
2. Click the "Teams" tab
3. Create a new team or select an existing team
4. Note the team's **slug** (the URL identifier)
   - Example: If team URL is `https://github.com/orgs/myorg/teams/frontend-team`
   - Then the team slug is `frontend-team`

### 2. Configure Repository Variables

Set up the necessary variables in your GitHub repository:

1. Go to repository **Settings** → **Secrets and variables** → **Actions**
2. Click the **Variables** tab
3. Add a new repository variable:
   - **Name**: `COPILOT_REVIEW_TEAM_SLUG`
   - **Value**: Your team slug (e.g., `frontend-team`)

### 3. Configure Team Permissions

Ensure GitHub Actions has permission to query team membership:

1. Go to organization **Settings** → **Actions** → **General**
2. In "Workflow permissions" section, ensure:
   - "Read repository contents and packages permissions" is enabled
3. If needed, adjust team visibility in team settings

### 4. (Optional) Customize Review Instructions

To customize Copilot review instructions:

1. Edit the `.github/copilot-instructions.md` file
2. Use `{PR_DIFF}` placeholder to insert PR diff
3. Or create a secret:
   - **Name**: `COPILOT_REVIEW_INSTRUCTIONS`
   - **Value**: Your custom review instructions

## Workflow Description

### Trigger Conditions

The workflow triggers on:
- New PR opened
- PR synchronized (new commits)
- PR reopened

### Execution Flow

1. **Check Team Membership**
   - Automatically checks if PR author is a member of specified team
   - Uses GitHub API to verify membership status

2. **Conditional Review Execution**
   - If author is team member: Run Copilot auto review
   - If author is not team member: Skip review and send notification

3. **Publish Review Results**
   - Review results posted as comment on PR
   - Includes suggestions for code quality, security, and best practices

## Configuration Examples

### Example 1: Single Team

```yaml
# Set in repository variables
COPILOT_REVIEW_TEAM_SLUG: "backend-team"
```

### Example 2: Frontend Team

```yaml
COPILOT_REVIEW_TEAM_SLUG: "frontend-team"
```

## Troubleshooting

### Issue: Workflow Cannot Check Team Membership

**Solution**:
1. Verify team slug spelling is correct
2. Confirm `GITHUB_TOKEN` has sufficient permissions
3. Check team visibility settings in organization

### Issue: All PRs Skip Review

**Solution**:
1. Verify repository variable `COPILOT_REVIEW_TEAM_SLUG` is correctly set
2. Confirm PR author is actually a team member
3. Check team member status is "active"

### Issue: Review Instructions Not Loading Correctly

**Solution**:
1. Verify `.github/copilot-instructions.md` file exists
2. Check file content format is correct
3. Ensure file contains `{PR_DIFF}` placeholder

## Advanced Configuration

### Support Multiple Teams

To enable this feature for multiple teams, modify the workflow file:

```yaml
# In check-team-membership step
TEAMS: "team1,team2,team3"  # Comma-separated team list
```

Then update the checking logic to loop through multiple teams.

### Custom Review Rules

You can set different review rules for different teams:

1. Create separate copilot-instructions files for each team
2. Dynamically load corresponding instruction file based on team in workflow

## Security Considerations

1. **Token Permissions**: Ensure `GITHUB_TOKEN` only has necessary permissions
2. **Team Visibility**: Consider impact of team visibility on workflow
3. **Review Content**: Review instructions should not contain sensitive information

## Maintenance and Updates

Regularly check and update:
- Team member lists
- Review instructions
- Workflow configuration

## Reference Resources

- [GitHub Teams Documentation](https://docs.github.com/en/organizations/organizing-members-into-teams)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub API - Teams](https://docs.github.com/en/rest/teams)

## Support

For questions or assistance:
1. Review workflow run logs
2. Check repository's Actions tab
3. Contact repository administrators or team leads
