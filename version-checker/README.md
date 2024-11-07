# Version Checker Custom Image

## Purpose
A sophisticated Docker image designed for automated version and commit tracking in GitHub repositories, enabling precise change detection and workflow triggering in CI/CD pipelines.

## Features
- Granular repository folder change detection
- GitHub API integration
- Flexible configuration via environment variables
- Lightweight Python-based implementation
- Easy integration with CI/CD workflows

## Environment Variables

### Repository Configuration
- `REPO` (required)
  - GitHub repository in "username/repository" format
  - Example: `REPO=HellKaiser45/gazette-du-sorcier`

- `FOLDER` (optional, default: root)
  - Specific folder to monitor for changes
  - Enables tracking of subdirectory modifications
  - Example: `FOLDER=frontend`

- `BRANCH` (optional, default: "main")
  - Specific branch to check for commits
  - Supports monitoring different branches
  - Example: `BRANCH=develop`

### Authentication and Output
- `GITHUB_TOKEN` (required)
  - Personal access token for GitHub API authentication
  - Must have repository read permissions
  - Supports fine-grained access control

- `OUTPUT_FOLDER` (optional, default: "/version-checker")
  - Directory to store last known commit information
  - Allows customizable tracking location
  - Example: `OUTPUT_FOLDER=/custom/version/path`

## Scripts

### `version_check.py`
- Primary Python script for commit change detection
- Fetches latest commit using GitHub API
- Compares current commit with last known commit
- Outputs "changed" or "unchanged"
- Supports automatic last commit tracking

### `build_and_push.sh`
- Builds Docker image for version-checker
- Handles GitHub Container Registry login
- Supports optional source labeling
- Pushes image with version and latest tags

## Workflow Integration

### Docker Direct Run
```bash
docker run -e REPO=HellKaiser45/gazette-du-sorcier \
           -e FOLDER=frontend \
           -e GITHUB_TOKEN=your_github_token \
           -v /local/path/to/version:/version-checker \
           version-checker
```

### Argo Workflow Example
Refer to `version-check-workflow.yaml` for a complete Argo Workflow demonstrating:
- Repository version checking
- Conditional workflow step execution
- Secret-based token management

## Detailed Workflow Behavior

### Change Detection Process
1. Retrieve latest commit SHA for specified repository and folder
2. Compare with previously stored commit
3. Output detection result:
   - "changed": New commit detected
   - "unchanged": No new commits

### Commit Tracking
- Automatically saves latest commit SHA
- Supports persistent tracking across container restarts
- Configurable output location

## Use Cases
- Trigger deployments on code changes
- Monitor specific project subdirectories
- Implement conditional CI/CD workflows
- Automate dependency updates
- Track repository evolution

## Build Instructions
```bash
docker build -t version-checker .
```

## Security Considerations
- Use read-only GitHub tokens
- Limit token scope to specific repositories
- Never commit tokens to version control
- Rotate tokens periodically
- Use secure secret management

## Performance and Limitations
- Lightweight Python implementation
- GitHub API rate limit considerations
- Single repository/folder tracking per container
- Requires network connectivity

## Troubleshooting
- Verify GitHub token permissions
- Check network and API accessibility
- Validate repository and folder names
- Ensure proper environment variable configuration

## Prerequisites
- Docker
- GitHub personal access token
- Basic understanding of CI/CD workflows
- Python 3.10+ runtime (for local development)

## Advanced Configuration
- Supports complex repository structures
- Flexible branch and folder monitoring
- Customizable output and tracking mechanisms

## Error Handling
- Comprehensive logging
- Graceful error management
- Clear error messages for misconfiguration
