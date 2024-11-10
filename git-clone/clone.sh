#!/bin/sh
set -e

# Check required environment variables
if [ -z "$GITHUB_USERNAME" ] || [ -z "$REPOSITORY_NAME" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_USERNAME, REPOSITORY_NAME, and GITHUB_TOKEN must be provided"
    exit 1
fi

# Use OUTPUT_DIR if provided, otherwise default to /workspace
OUTPUT_DIR="${OUTPUT_DIR:-/workspace}"

# Clone repository
git clone https://${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}.git "$OUTPUT_DIR"

# Optional: checkout specific branch or commit if provided
if [ ! -z "$BRANCH" ]; then
    cd "$OUTPUT_DIR"
    git checkout "$BRANCH"
fi

# List contents of cloned repository
ls -la "$OUTPUT_DIR"
