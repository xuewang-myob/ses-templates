# Auto Enable Copilot Review Workflow

## Overview

This GitHub Actions workflow automatically enables Copilot review for pull requests when the PR creator's email matches a predefined list of approved email addresses.

## How It Works

### Trigger
The workflow is triggered when:
- A pull request is **opened**
- A pull request is **reopened**

### Process Flow

1. **Get PR Creator Email**
   - Extracts the email address of the PR creator from the commit history
   - Falls back to GitHub user API if email is not found in commits

2. **Check Branch Start with VHNP

3. **Enable Copilot Review** (if branch matches)
   - Adds the `Copilot` label to the PR
   - Creates the label if it doesn't exist
   - Posts a comment notifying that Copilot review has been enabled

4. **Skip** (if email doesn't match)
   - Logs that the email is not in the allowed list
   - No action is taken on the PR

## Configuration

### Modifying Allowed Emails

To add or remove email addresses from the allowed list, edit the workflow file:

`.github/workflows/auto-copilot-review.yml`

Locate the `allowedEmails` array in the "Check if email is in allowed list" step:

```javascript
const allowedEmails = [
  'xue.wang@myob.com',
  'example1@test.com',
  'example2@test.com'
];
```

Add or remove email addresses as needed.

## Permissions Required

The workflow requires the following permissions:
- `pull-requests: write` - To add labels and comments to PRs
- `contents: read` - To read repository content and commits

## Dependencies

- `actions/github-script@v7` - Used for executing GitHub API operations

## Troubleshooting

### Workflow Not Running
- Ensure the workflow file is in `.github/workflows/` directory
- Check that the repository has Actions enabled
- Verify permissions are correctly set in the workflow

### Email Not Detected
- The email is extracted from the commit author information
- If commits are made with different email addresses, the most recent commit's email is used
- Ensure git is configured with the correct email: `git config user.email`

### Label Not Applied
- Check the workflow run logs in the Actions tab
- Verify the creator's email matches exactly (case-insensitive) with an entry in the allowed list
- Ensure the workflow has `pull-requests: write` permission

## Notes

- Email matching is case-insensitive
- The workflow only runs on PR open/reopen events, not on updates
- If the `copilot` label doesn't exist, the workflow will create it automatically

## Passwords
- this is "passwords"
