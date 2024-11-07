# Git Clone Custom Image

## Purpose
A lightweight, flexible Docker image designed for secure and automated Git repository cloning within CI/CD pipelines, supporting various cloning scenarios and workflow integrations.

## Features
- Secure GitHub repository cloning
- Flexible branch and commit selection
- Workspace management
- Lightweight Alpine-based image
- Easy integration with CI/CD workflows

## Environment Variables

### Authentication and Repository Configuration
- `GITHUB_USERNAME` (required)
  - GitHub username of the repository owner
  - Example: `GITHUB_USERNAME=myorganization`

- `REPOSITORY_NAME` (required)
  - Name of the GitHub repository to clone
  - Example: `REPOSITORY_NAME=my-project`

- `GITHUB_TOKEN` (required)
  - Personal access token for GitHub authentication
  - Must have appropriate repository access permissions
  - Supports read-only and specific repository access

### Optional Cloning Parameters
- `BRANCH` (optional)
  - Specific branch to checkout after cloning
  - If not provided, defaults to repository's default branch
  - Example: `BRANCH=develop`

- `OUTPUT_DIR` (optional, default: `/workspace`)
  - Directory where the repository will be cloned
  - Allows customization of clone destination
  - Example: `OUTPUT_DIR=/path/to/clone`

## Scripts

### `clone.sh`
- Primary entrypoint script for repository cloning
- Validates required environment variables
- Cleans workspace before cloning
- Supports branch-specific checkout
- Lists cloned repository contents

### `run_clone.sh`
- Wrapper script for easy local Docker execution
- Configurable parameters
- Handles Docker container run with mounted volume
- Provides default values for quick setup

### `build_and_push.sh`
- Builds Docker image for git-clone
- Supports optional source labeling
- Handles GitHub Container Registry login
- Pushes image with version and latest tags

## Workflow Integration

### Docker Direct Run
```bash
docker run -e GITHUB_USERNAME=your-username \
           -e REPOSITORY_NAME=your-repo \
           -e GITHUB_TOKEN=your-token \
           -e BRANCH=main \
           -v /local/path:/workspace \
           ghcr.io/hellkaiser45/git-clone:latest
```

### Argo Workflow Example
Refer to `git-clone-workflow.yaml` for a complete Argo Workflow example demonstrating:
- Repository cloning
- Secret-based token management
- Workspace volume mounting

## Environment Variable Configuration

### Local Development
1. Edit `run_clone.sh`:
```bash
GITHUB_USERNAME="your-username"
REPOSITORY_NAME="your-repo"
GITHUB_TOKEN="your_personal_access_token"
BRANCH="main"
OUTPUT_DIR="./cloned_repo"
```

2. Run the script:
```bash
./run_clone.sh
```

## Build Instructions
```bash
docker build -t git-clone .
```

## Security Considerations
- Use read-only GitHub tokens
- Limit token scope to specific repositories
- Never commit tokens to version control
- Use environment variables or secure secret management
- Rotate tokens periodically

## Prerequisites
- Docker
- GitHub personal access token
- Basic understanding of Git and Docker

## Use Cases
- CI/CD pipeline repository cloning
- Automated repository backup
- Continuous integration testing
- Workflow automation
- Development environment setup

## Troubleshooting
- Ensure GitHub token has correct permissions
- Verify repository name and username
- Check network connectivity
- Validate environment variable configuration

## Performance and Limitations
- Lightweight image (based on alpine/git)
- Supports public and private repositories
- Single repository cloning per container instance
