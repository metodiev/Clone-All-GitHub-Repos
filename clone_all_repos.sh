#!/bin/bash

# Usage: ./clone_all_repos.sh github_username
# Example: ./clone_all_repos.sh metodiev

USERNAME="$1"

if [ -z "$USERNAME" ]; then
  echo "Usage: $0 <github_username>"
  exit 1
fi

# Create a directory for the user
mkdir -p "$USERNAME"
cd "$USERNAME" || exit 1

PAGE=1
PER_PAGE=100

while true; do
  REPOS=$(curl -s "https://api.github.com/users/$USERNAME/repos?per_page=$PER_PAGE&page=$PAGE")

  # Stop if no repositories are returned
  if [ "$(echo "$REPOS" | jq length)" -eq 0 ]; then
    break
  fi

  echo "$REPOS" | jq -r '.[].clone_url' | while read -r REPO_URL; do
    REPO_NAME=$(basename "$REPO_URL" .git)
    if [ -d "$REPO_NAME" ]; then
      echo "Skipping $REPO_NAME (already exists)"
    else
      echo "Cloning $REPO_NAME..."
      git clone "$REPO_URL"
    fi
  done

  PAGE=$((PAGE + 1))
done

echo "Done, all repos are clone from : $USERNAME"
