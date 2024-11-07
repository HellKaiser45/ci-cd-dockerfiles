#!/usr/bin/env python3
import os
import sys
import urllib.request
import json
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_latest_commit(repo, folder, branch, token):
    """Fetch the latest commit for a specific folder in a repository."""
    try:
        url = f"https://api.github.com/repos/{repo}/commits?path={folder}&sha={branch}"
        headers = {
            "Authorization": f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28"
        }
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response:
            commits = json.loads(response.read().decode())

        if not commits:
            logging.error("No commits found.")
            return None

        return commits[0]["sha"]
    except Exception as e:
        logging.error(f"Error fetching latest commit: {e}")
        return None

def compare_commits(latest_commit, known_commit):
    """Compare latest and known commits."""
    return "changed" if latest_commit != known_commit else "unchanged"

def save_commit(filepath, commit):
    """Save the commit to a file."""
    try:
        directory = os.path.dirname(filepath)
        os.makedirs(directory, exist_ok=True)
        with open(filepath, "w") as f:
            f.write(commit)
        logging.info(f"Commit {commit} saved to {filepath}")
    except Exception as e:
        logging.error(f"Error saving commit: {e}")

def get_known_commit(filepath):
    """Read the known commit from a file."""
    try:
        with open(filepath, "r") as f:
            return f.read().strip()
    except FileNotFoundError:
        logging.info(f"No previous commit file found at {filepath}")
        return None
    except Exception as e:
        logging.error(f"Error reading known commit: {e}")
        return None

def main():
    # Environment variables for configuration
    repo = os.getenv("REPO")
    folder = os.getenv("FOLDER", "")
    branch = os.getenv("BRANCH", "main")
    token = os.getenv("GITHUB_TOKEN")
    default_version = os.getenv("DEFAULT_VERSION", "1.0.0")

    # Output folder with configurable environment variable and default
    output_folder = os.getenv("OUTPUT_FOLDER", "/version-checker")
    known_commit_filename = "last_commit.txt"
    known_commit_file = os.path.join(output_folder, known_commit_filename)

    if not all([repo, token]):
        logging.error("Missing required environment variables: REPO or GITHUB_TOKEN")
        sys.exit(1)

    # Ensure output folder exists
    os.makedirs(output_folder, exist_ok=True)

    latest_commit = get_latest_commit(repo, folder, branch, token)

    if not latest_commit:
        logging.error("Could not retrieve latest commit")
        sys.exit(1)

    known_commit = get_known_commit(known_commit_file)

    # If no previous commit file exists, create with default version
    if known_commit is None:
        logging.info(f"Creating initial version file with default version: {default_version}")
        save_commit(known_commit_file, default_version)
        print("changed")
        sys.exit(0)

    result = compare_commits(latest_commit, known_commit)

    if result == "changed":
        save_commit(known_commit_file, latest_commit)

    print(result)

if __name__ == "__main__":
    main()
