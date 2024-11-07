# Docker Build Custom Image

## Purpose
A comprehensive Docker image designed for building, tagging, and pushing Docker images within CI/CD pipelines, with advanced versioning and repository management capabilities.

## Features
- Docker-in-Docker (DinD) support
- Pre-installed tools: curl, jq, git, bash
- Secure Docker daemon startup
- Automated version increment and tracking
- GitHub Container Registry (GHCR) integration
- Flexible build and push workflows

## Environment Variables

### Core Configuration
- `REGISTRY` (default: `ghcr.io`)
  - Container registry to use for image storage
  - Example: `REGISTRY=docker.io`

- `USERNAME` (default: `HellKaiser45`)
  - GitHub/Docker username (automatically converted to lowercase)
  - Example: `USERNAME=myorganization`

- `IMAGE_NAME` (default: `docker-build`)
  - Name of the Docker image to build
  - Example: `IMAGE_NAME=my-custom-image`

### Authentication and Repository
- `GITHUB_TOKEN` (required)
  - Personal access token for GitHub Container Registry authentication
  - Provides credentials for image push operations
  - Must have appropriate repository and package permissions

- `REPO_OWNER` (optional)
  - GitHub repository owner
  - Used for source labeling
  - Example: `REPO_OWNER=MyOrganization`

- `REPO_NAME` (optional)
  - GitHub repository name
  - Used for source labeling
  - Example: `REPO_NAME=my-project`

### Build and Version Tracking
- `DOCKERFILE_PATH` (required for dockerd-entrypoint.sh)
  - Path to the directory containing the Dockerfile
  - Example: `/workspace/my-project`

- `VERSION_FILE_PATH` (required for dockerd-entrypoint.sh)
  - Path to the directory containing `last_commit.txt`
  - Tracks and increments version automatically
  - Example: `/workspace/my-project/version`

## Scripts

### `dockerd-entrypoint.sh`
- Starts Docker daemon
- Manages Docker image build and push workflow
- Automatically increments version
- Supports version rollover (e.g., 1.9 -> 1.10)
- Pushes both version-specific and latest tags

### `build_and_push.sh`
- Flexible Docker image build script
- Supports optional source labeling
- Handles GitHub Container Registry login
- Pushes image with version and latest tags
- Provides warning if no GitHub token is available

## Workflow Integration
Ideal for Argo Workflows and CI/CD pipelines that require:
- Automated Docker image building
- Version management
- Container registry publishing
- Secure credential handling

## Usage Examples

### Basic Docker Build
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -e GITHUB_TOKEN=your_github_token \
           -e USERNAME=your-username \
           -e IMAGE_NAME=my-project \
           -e DOCKERFILE_PATH=/path/to/dockerfile \
           -e VERSION_FILE_PATH=/path/to/version \
           docker-build
```

### Argo Workflow Integration
Refer to `docker-build-workflow.yaml` for a complete Argo Workflow example that demonstrates repository cloning, version increment, and image publishing.

## Security Considerations
- Uses Docker-in-Docker with careful entrypoint management
- Supports secure credential passing via environment variables
- Minimal image footprint
- Automatic lowercase conversion for usernames
- Optional source labeling for improved traceability

## Build Instructions
```bash
docker build -t docker-build .
```

## Requirements
- Docker
- GitHub Personal Access Token (for GHCR)
- Basic understanding of CI/CD workflows
