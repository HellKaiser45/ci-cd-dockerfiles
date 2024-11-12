#!/bin/bash
set -e

# Debug: Print all passed arguments
echo "All arguments: $@"

# Variables
REGISTRY="${REGISTRY:-ghcr.io}"
USERNAME="${USERNAME:-HellKaiser45}"  # Converted to lowercase
USERNAME=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]')
IMAGE_NAME="${IMAGE_NAME:-version-checker}"  # Already lowercase
VERSION="${VERSION:-1.0.0}"  # Default version

# Debug: Capture GitHub token and version from arguments
for arg in "$@"; do
    case "$arg" in
        GITHUB_TOKEN=*)
            GITHUB_TOKEN="${arg#*=}"
            ;;
        VERSION=*)
            VERSION="${arg#*=}"
            ;;
    esac
done

# Debug prints
echo "GitHub Token Length: ${#GITHUB_TOKEN}"
echo "Version: ${VERSION}"

REPO_OWNER="${USERNAME}"
REPO_NAME="${REPO_NAME:-ci-cd-dockerfiles}"

# Prepare build command with optional source label
BUILD_COMMAND="docker build -t ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}"

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
