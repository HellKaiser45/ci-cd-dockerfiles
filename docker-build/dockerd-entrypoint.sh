#!/bin/bash
set -e

# Start Docker daemon in the background
dockerd &

# Wait for Docker daemon to start
while (! docker info > /dev/null 2>&1); do
    echo "Waiting for Docker daemon to start..."
    sleep 1
done

echo "Docker daemon is running."

# Set default environment variables
REGISTRY="${REGISTRY:-ghcr.io}"
USERNAME="${USERNAME:-HellKaiser45}"
IMAGE_NAME="${IMAGE_NAME:-version-checker}"
GITHUB_TOKEN="${GITHUB_TOKEN:?Error: GITHUB_TOKEN is required}"
REPO_OWNER="${REPO_OWNER:-}"
REPO_NAME="${REPO_NAME:-}"
DOCKERFILE_PATH="${DOCKERFILE_PATH:?Error: DOCKERFILE_PATH is required}"
VERSION_FILE_PATH="${VERSION_FILE_PATH:?Error: VERSION_FILE_PATH is required}"

# Read last version from last_commit.txt
if [ ! -f "$VERSION_FILE_PATH/last_commit.txt" ]; then
    echo "Error: last_commit.txt not found in $VERSION_FILE_PATH"
    exit 1
fi

CURRENT_VERSION=$(cat "$VERSION_FILE_PATH/last_commit.txt")

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

NEW_VERSION=$(increment_version "$CURRENT_VERSION")

# Change to the Dockerfile directory
cd "$DOCKERFILE_PATH"

# Build the Docker image
docker build -t "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${NEW_VERSION}" .

# Login to container registry
echo "$GITHUB_TOKEN" | docker login "$REGISTRY" -u "$USERNAME" --password-stdin

# Push the image with new version tag
docker push "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${NEW_VERSION}"

# Tag and push latest
docker tag "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${NEW_VERSION}" "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest"
docker push "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest"

# Update last_commit.txt with new version
echo "$NEW_VERSION" > "$VERSION_FILE_PATH/last_commit.txt"

echo "Image ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${NEW_VERSION} built and pushed successfully!"

# Terminate the container after successful build and push
exit 0
