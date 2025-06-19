#!/bin/bash
set -e

REGISTRY="${REGISTRY:-ghcr.io}"
USERNAME="${USERNAME:-HellKaiser45}"
IMAGE_NAME="${IMAGE_NAME:-docker-build}"
VERSION="${VERSION:-1.0.0}"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
REPO_OWNER="${REPO_OWNER:-}"
REPO_NAME="${REPO_NAME:-}"
BUILD_ARGS="${BUILD_ARGS:-}"

USERNAME=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]')

# Make scripts executable
chmod +x dockerd-entrypoint.sh
chmod +x build_and_push.sh

# Prepare build command with optional source label
BUILD_COMMAND="docker build ${BUILD_ARGS} -t ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION} -t ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest"

# Add source label only if both REPO_OWNER and REPO_NAME are non-empty
if [ -n "$REPO_OWNER" ] && [ -n "$REPO_NAME" ]; then
  REPO_OWNER=$(echo "$REPO_OWNER" | tr '[:upper:]' '[:lower:]')
  BUILD_COMMAND="${BUILD_COMMAND} --label org.opencontainers.image.source=https://github.com/${REPO_OWNER}/${REPO_NAME}"
fi

# Validate GitHub token if pushing
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Warning: No GitHub token provided. Image will be built but not pushed."
  # Build the Docker image
  $BUILD_COMMAND .
else
  # Login to GitHub Container Registry
  echo "$GITHUB_TOKEN" | docker login ${REGISTRY} -u ${USERNAME} --password-stdin

  # Build the Docker image
  $BUILD_COMMAND .

  # Push the image
  docker push ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}

  # Optional: Tag as latest
  docker tag ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION} ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest
  docker push ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest

  echo "Image ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION} built and pushed successfully!"
fi
