# Copilot Instructions for ses-templates

## Repository Overview

This repository contains **AWS Simple Email Service (SES) HTML email templates** for the Adatree Consent Management service. The templates are used for sending various consent-related notifications and authentication emails.

**Repository Type:** Static HTML email templates  
**Language:** HTML (XHTML 1.0 Transitional)  
**Size:** Small (~16 HTML template files, ~2870 total lines)  
**No build tools or dependencies required** - This is a pure HTML template repository

## What This Repository Does

The repository maintains email templates for:
- **Consent notifications:** granted, reminder, revoked, withdrawn, expired, extended
- **Authentication:** one-time password (OTP), passwordless login link

Each template exists in two versions:
- **`.html`** - Full readable version with formatting
- **`.min.html`** - Minified version for AWS SES deployment

## Repository Structure

```
/
├── .github/
│   └── copilot-instructions.md (this file)
├── .gitignore
├── LICENSE.md
├── README.md (comprehensive documentation)
├── updateTemplate.sh (deployment script)
├── consent-expired.html / consent-expired.min.html
├── consent-extended.html / consent-extended.min.html
├── consent-granted.html / consent-granted.min.html
├── consent-reminder.html / consent-reminder.min.html
├── consent-revoked.html / consent-revoked.min.html
├── consent-withdrawn.html / consent-withdrawn.min.html
├── one-time-password.html / one-time-password.min.html
└── passwordless-link.html / passwordless-link.min.html
```

## Template Variables (Handlebars Syntax)

All templates use **Handlebars templating syntax** (`{{variable}}`) for dynamic content. Key variables include:

- `{{dataHolderName}}` - Name of the data holder (e.g., "CommBank")
- `{{granteeName}}` - Entity receiving the data
- `{{dashboardLink}}` - URL to consent dashboard
- `{{givenAt}}` - Date consent was given (format: "dd LLLL yyyy")
- `{{sharingEndDate}}` - Date consent expires
- `{{scopes}}` - Array of data cluster scopes (use `{{#each scopes}}{{scope}}{{/each}}`)
- `{{purposes}}` - Array of purposes (use `{{#each purposes}}{{purpose}}{{/each}}`)
- `{{osps}}` - Array of supporting parties with nested properties
- `{{accessFrequency}}` - "once" or "multiple times"
- `{{postUsageAction}}` - "deleting" or "de-identifying"
- `{{postUsageActioner}}` - Entity responsible for post-usage action
- `{{oneTimePassword}}` - OTP code for authentication
- `{{sender}}` - Brand name of sender
- `{{link}}` - Temporary passwordless login URL

## Important: NO Build, Test, or Lint Steps

**This repository has NO automated build, test, or linting infrastructure.**

There are:
- ❌ No package.json or build tools
- ❌ No test framework or test files
- ❌ No linting configuration
- ❌ No GitHub Actions workflows
- ❌ No CI/CD pipelines

When working on this repository:
- **DO NOT** attempt to run `npm install`, `npm test`, or any build commands
- **DO NOT** search for or create test infrastructure
- **DO NOT** add linting tools unless explicitly requested
- Changes are validated manually by reviewing the HTML

## Workflow for Making Changes

### 1. Editing Templates

When modifying email templates:

1. **Edit the readable `.html` file first** (e.g., `consent-granted.html`)
2. **Manually minify** the HTML using an online minifier tool
   - Be careful to preserve necessary spaces in the HTML
   - Do NOT use automated tools that might remove important whitespace
3. **Update the corresponding `.min.html` file** with the minified version
4. **Verify Handlebars syntax** is correct (check all `{{}}` tags)
5. **Check template variable usage** matches the SES Attributes table in README.md

### 2. Testing Templates

**Manual testing only:**
- Use AWS CLI commands from README.md "Cheatsheet" section
- Test with actual AWS SES using the provided `aws ses send-templated-email` examples
- Verify template rendering in email clients

### 3. Deployment

Use the `updateTemplate.sh` script to deploy templates to AWS SES:

```bash
# Dry run to see what would be deployed
./updateTemplate.sh --dry-run <directory>

# Actually deploy templates
./updateTemplate.sh <directory>
```

**Requirements:** 
- AWS CLI must be installed and configured
- Proper AWS credentials with SES permissions
- Templates must be in JSON format for the script (see README for format)

## Key Files to Reference

### README.md (Most Important)
The README contains:
- **Complete template variable reference** (SES Attributes table)
- **Email subject lines** for each template
- **Testing cheatsheet** with AWS CLI examples for each template
- **Troubleshooting** for common SES issues
- **Template data examples** for testing

**Always consult README.md** before making changes to understand:
- What variables each template supports
- Expected data formats
- How to test changes

### updateTemplate.sh
Bash script for batch updating SES templates via AWS CLI.

**Usage:** `./updateTemplate.sh [-d | --dry-run] <directory>`
- Loops through all JSON files in specified directory
- Runs `aws ses update-template --cli-input-json file://<file>` for each
- Use `--dry-run` flag to preview without deploying

## Common Tasks

### Adding a New Template

1. Create `template-name.html` with full HTML structure
2. Use existing templates as reference for structure and styling
3. Include appropriate Handlebars variables from README.md table
4. Minify and create `template-name.min.html`
5. Update README.md:
   - Add entry to "Email Subjects" table
   - Add testing example to "Cheatsheet" section (if applicable)
6. Document any new template variables in README.md "SES Attributes" table

### Modifying Existing Templates

1. Locate the template pair (`.html` and `.min.html`)
2. Edit the `.html` file
3. Re-minify and update `.min.html`
4. If adding/removing variables, update README.md SES Attributes table
5. Test using AWS CLI examples from README.md

### Important Notes When Editing

- **Preserve Handlebars syntax** - Templates use `{{variable}}`, `{{#if condition}}`, `{{#each array}}`
- **Maintain email client compatibility** - Use inline styles, table-based layouts
- **Check for spaces** - Some minification removes necessary spaces; verify carefully
- **Conditional blocks** - Some templates use `{{#if sharingEndDate}}` and `{{#each osps}}`
- **Email header image** - All templates reference Adatree branding imagery from HubSpot CDN

## Architecture Notes

### Template Categories

1. **Consent Templates** (6 templates)
   - More complex with data tables, scopes, purposes, supporting parties
   - Use HubSpot email framework with responsive design
   - Background color: `#cbd6e2`, content background: `#f2f2f2`
   
2. **Authentication Templates** (2 templates)
   - Simpler design
   - OTP template: displays one-time password code
   - Passwordless: provides magic link for login

### HTML Structure

- All consent templates use **XHTML 1.0 Transitional DOCTYPE**
- Heavy use of **conditional comments** for Outlook compatibility
- **Responsive design** with media queries for mobile
- **Table-based layouts** for email client compatibility
- **Inline styles** (required for email)

### Styling Conventions

- Font family: Arial, sans-serif
- Main text color: `#23496d`
- Font size: 15px
- Line height: 175% (mso-line-height-rule)
- Links: `#00a4bd` color with underline
- Images: Adatree branding from HubSpot CDN

## .gitignore

The repository ignores:
- `.idea/` - JetBrains IDE configuration
- `custom` - Custom local files/directories (not tracked in repository)

## No CI/CD or Validation Pipelines

**There are no automated checks before check-in.**

All validation is manual:
- Review HTML for correctness
- Check Handlebars syntax
- Test with AWS SES manually
- Verify rendering in email clients

## Environment Setup

**No special environment setup required.**

To work with this repository:
1. Clone the repository
2. Edit HTML files in any text editor
3. Optionally install AWS CLI for testing (`aws --version` should work)

## Commands Reference

### Git Operations
```bash
# Status and diff (always use --no-pager to avoid issues)
git --no-pager status
git --no-pager diff

# View specific commit
git --no-pager show <commit-sha>
```

### AWS SES Testing (requires AWS CLI)
```bash
# Configure test environment
export tenant=xxxxxx
export src=xxxxxx
export testemail=xxxxxx
export dashboardDomain=xxxxxx

# Send test email (see README.md for complete examples with full template-data)
aws ses send-templated-email \
  --source ${src} \
  --destination ToAddresses=${testemail} \
  --template ${tenant}-consent-granted \
  --template-data '{"granteeName":"Test User","dataHolderName":"Test Bank",...}'

# Update template on AWS
aws ses update-template --cli-input-json file://template.json

# Generate template JSON skeleton
aws ses update-template --generate-cli-skeleton
```

### Deployment Script
```bash
# Dry run
./updateTemplate.sh --dry-run /path/to/json/templates

# Deploy
./updateTemplate.sh /path/to/json/templates
```

## Tips for Efficient Work

1. **Trust these instructions** - Don't search for build/test infrastructure that doesn't exist
2. **Reference README.md first** - It contains the authoritative variable list and examples
3. **Use existing templates as reference** - Copy structure and patterns from similar templates
4. **Minify carefully** - Online tools can break templates by removing necessary spaces
5. **Test incrementally** - Use AWS CLI to verify changes before finalizing
6. **Check Handlebars syntax** - Ensure all `{{}}` tags are properly closed
7. **Maintain pairs** - Always update both `.html` and `.min.html` versions

## What NOT to Do

- ❌ Don't try to run `npm install`, `npm test`, or similar commands
- ❌ Don't create test files or testing infrastructure
- ❌ Don't add linting tools without explicit request
- ❌ Don't search for CI/CD configurations (they don't exist)
- ❌ Don't modify the deployment script unless specifically asked
- ❌ Don't change the HTML structure radically (email clients need table layouts)
- ❌ Don't use external CSS files (email requires inline styles)

## Repository Links and References

- **Deployed templates** are referenced in [adr-platform-deploy repository](https://github.com/Adatree/adr-platform-deploy/blob/main/service-catalog/products/per-tenant-infra/stack-of-stacks.yaml)
- **Template content verification** should match [Confluence documentation](https://adatree.atlassian.net/wiki/x/AQBAGw)
- **Data cluster language** comes from [Consumer Data Standards](https://consumerdatastandardsaustralia.github.io/standards/#consumer-experience)

---

**Summary:** This is a simple HTML template repository with no build system. Edit templates carefully, minify them, test with AWS CLI, and deploy with the provided script. Always reference README.md for variable definitions and testing examples.
