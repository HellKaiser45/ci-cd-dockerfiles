# CI/CD Workflow with Argo and Custom Containers

## Overview
This project implements a CI/CD pipeline using Argo Workflows and custom containers for each stage of the process.

## Prerequisites
- Kubernetes Cluster
- Argo Workflows installed
- GitHub Token
- Docker/GitHub Container Registry access

## Configuration Files
- `workflow.yaml`: Defines the Argo Workflow steps
- `secrets-and-volumes.yaml`: Configures Kubernetes secrets and persistent volumes

## Setup Steps

### 1. Configure Secrets
Edit `secrets-and-volumes.yaml` and fill in the placeholders:

#### Git Credentials
- `username`: Your GitHub username
- `repo-name`: Name of the repository to clone
- `full-repo-name`: Repository in `owner/repo` format
- `token`: GitHub personal access token

#### Docker Credentials
- `username`: Your Docker/GitHub username
- `image-name`: Name of the image to build
- `token`: GitHub personal access token for container registry

### 2. Apply Secrets and Volumes
```bash
kubectl apply -f secrets-and-volumes.yaml
```

### 3. Submit Argo Workflow
```bash
argo submit workflow.yaml
```

## Workflow Steps
1. Clone Repository
2. Check Version
3. Build and Push Container
4. Clear Shared Volume

## Troubleshooting
- Ensure all secrets are correctly configured
- Verify Argo Workflows is properly installed
- Check Kubernetes RBAC permissions

## Notes
- Customize the workflow and secrets as needed
- Adjust volume sizes and access modes if required
