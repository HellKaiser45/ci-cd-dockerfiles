# Version Checker

## Environment Variables

The script requires the following environment variables:

- `REPO`: The repository name (can be in format `repository` or `username/repository`)
- `FOLDER`: The specific folder within the repository to check for changes
- `BRANCH`: The branch to check (default is 'main')
- `GITHUB_TOKEN`: GitHub personal access token with repository read access
- `GITHUB_USERNAME`: Your GitHub username (used for repository name validation)

### Example Usage

```bash
export GITHUB_USERNAME=YourGitHubUsername
export REPO=your-repository
export FOLDER=path/to/folder
export BRANCH=main
export GITHUB_TOKEN=your_github_token
python version_check.py
```

## Functionality

This script checks for changes in a specific folder of a GitHub repository by comparing commit SHAs. It:
- Retrieves the latest commit SHA for a specified folder
- Compares it with a previously stored commit
- Outputs 'changed' or 'unchanged'
- Saves the latest commit SHA for future comparisons

## Output

The script writes the result to:
- `/tmp/outputs/result`: File containing 'changed' or 'unchanged'
- stdout: Prints 'changed' or 'unchanged'
- `/tmp/version_check.log`: Detailed logging information
