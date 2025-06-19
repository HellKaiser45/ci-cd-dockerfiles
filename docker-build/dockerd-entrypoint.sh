#!/bin/bash
set -e

# Start Docker daemon in the background
dockerd &

# Wait for Docker daemon to start
while (! docker info >/dev/null 2>&1); do
  echo "Waiting for Docker daemon to start..."
  sleep 1
done

echo "Docker daemon is running."

# Set default environment variables
REGISTRY="${REGISTRY:-ghcr.io}"
USERNAME=$(echo "${USERNAME:-HellKaiser45}" | tr '[:upper:]' '[:lower:]')
IMAGE_NAME=$(echo "${IMAGE_NAME:-version-checker}" | tr '[:upper:]' '[:lower:]')
GITHUB_TOKEN="${GITHUB_TOKEN:?Error: GITHUB_TOKEN is required}"
REPO_OWNER=$(echo "${REPO_OWNER:-$USERNAME}" | tr '[:upper:]' '[:lower:]')
REPO_NAME=$(echo "${REPO_NAME:-$IMAGE_NAME}" | tr '[:upper:]' '[:lower:]')
DOCKERFILE_PATH="${DOCKERFILE_PATH:-/workspace}"
BUILD_ARGS="${BUILD_ARGS:-}"

# Debug: Print out all relevant paths and variables
echo "Current working directory: $(pwd)"
echo "Dockerfile path: $DOCKERFILE_PATH"
echo "Contents of Dockerfile path:"
ls -la "$DOCKERFILE_PATH"

# Find Dockerfile
DOCKERFILE=""
for dir in "$DOCKERFILE_PATH" "/workspace" "/"; do
  if [ -f "$dir/Dockerfile" ]; then
    DOCKERFILE="$dir/Dockerfile"
    break
  fi
done

# Check if Dockerfile was found
if [ -z "$DOCKERFILE" ]; then
  echo "Error: Dockerfile not found in $DOCKERFILE_PATH or common locations"
  exit 1
fi

# Fetch the latest version from GitHub releases/tags
get_latest_version() {
  local version=$(curl -s \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/tags" |
    jq -r '.[0].name // "0.0.0"' | sed 's/^v//')

  echo "$version"
}

# Increment version
increment_version() {
  local version="$1"
  local major=$(echo "$version" | cut -d. -f1)
  local minor=$(echo "$version" | cut -d. -f2)

  minor=$((minor + 1))

  # Handle version rollover (e.g., 1.9 -> 1.10)
  if [ "$minor" -eq 10 ]; then
    major=$((major + 1))
    minor=0
  fi

  echo "${major}.${minor}"
}

# Get current version
CURRENT_VERSION=$(get_latest_version)

# Increment version
NEW_VERSION=$(increment_version "$CURRENT_VERSION")

# Determine build context
BUILD_CONTEXT=$(dirname "$DOCKERFILE")

# Build the Docker image
docker build "$BUILD_ARGS" -f "$DOCKERFILE" -t "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${NEW_VERSION}" "$BUILD_CONTEXT"

# Login to container registry
echo "$GITHUB_TOKEN" | docker login "$REGISTRY" -u "$USERNAME" --password-stdin

# Push the image with new version tag
docker push "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${NEW_VERSION}"

# Tag and push latest
docker tag "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${NEW_VERSION}" "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest"
docker push "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest"

echo "Image ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${NEW_VERSION} built and pushed successfully!"

# Terminate the container after successful build and push
exit 0
