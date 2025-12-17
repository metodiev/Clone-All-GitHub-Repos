#!/bin/bash

# Usage:
# ./clone_all_repos_ghe.sh <enterprise_base_url> <username> <token>
#
# Example:
# ./clone_all_repos_ghe.sh https://github.company.com metodiev ghp_xxxxx

BASE_URL="$1"
USERNAME="$2"
TOKEN="$3"

if [ -z "$BASE_URL" ] || [ -z "$USERNAME" ] || [ -z "$TOKEN" ]; then
  echo "Usage: $0 <enterprise_base_url> <username> <token>"
  exit 1
fi

API_URL="$BASE_URL/api/v3"

mkdir -p "$USERNAME"
cd "$USERNAME" || exit 1

PAGE=1
PER_PAGE=100

while true; do
  RESPONSE=$(curl -s \
    -H "Authorization: token $TOKEN" \
    -H "Accept: application/vnd.github+json" \
    "$API_URL/users/$USERNAME/repos?per_page=$PER_PAGE&page=$PAGE")

  if [ "$(echo "$RESPONSE" | jq length)" -eq 0 ]; then
    break
  fi

  echo "$RESPONSE" | jq -r '.[].clone_url' | while read -r REPO_URL; do
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

echo "✅ Done cloning repositories for GitHub Enterprise user: $USERNAME"
