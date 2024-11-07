#!/bin/bash

# Default Configuration Parameters
GITHUB_USERNAME="${GITHUB_USERNAME:-HellKaiser45}"
REPOSITORY_NAME="${REPOSITORY_NAME:-Notion-widgets}"
GITHUB_TOKEN="${GITHUB_TOKEN:-your_personal_access_token}"
BRANCH="${BRANCH:-main}"
OUTPUT_DIR="${OUTPUT_DIR:-./cloned_repo}"

# Validate required parameters
if [ -z "$GITHUB_USERNAME" ] || [ -z "$REPOSITORY_NAME" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GitHub username, repository name, and token are required."
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run the Docker container
docker run -e GITHUB_USERNAME="$GITHUB_USERNAME" \
           -e REPOSITORY_NAME="$REPOSITORY_NAME" \
           -e GITHUB_TOKEN="$GITHUB_TOKEN" \
           -e BRANCH="$BRANCH" \
           -e OUTPUT_DIR="/output" \
           -v "$(realpath "$OUTPUT_DIR")":/output \
           ghcr.io/hellkaiser45/git-clone:latest

echo "Repository cloned to $OUTPUT_DIR"
