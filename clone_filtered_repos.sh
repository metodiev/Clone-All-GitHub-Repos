#!/bin/bash

# Usage:
# ./clone_filtered_repos.sh <username> [prefix] [language] [token]
# Example:
# ./clone_filtered_repos.sh metodiev project- Java
# ./clone_filtered_repos.sh github_enterprise_user "" C# ghp_xxxxx

USERNAME="$1"
PREFIX="$2"        # optional, leave empty "" if not used
LANG="$3"          # optional, leave empty "" if not used
TOKEN="$4"         # optional for private repos

if [ -z "$USERNAME" ]; then
    echo "Usage: $0 <username> [prefix] [language] [token]"
    exit 1
fi

mkdir -p "$USERNAME"
cd "$USERNAME" || exit 1

PAGE=1
PER_PAGE=100

API_URL="https://api.github.com/users/$USERNAME/repos"

while true; do
    if [ -z "$TOKEN" ]; then
        REPOS=$(curl -s "$API_URL?per_page=$PER_PAGE&page=$PAGE")
    else
        REPOS=$(curl -s -H "Authorization: token $TOKEN" "$API_URL?per_page=$PER_PAGE&page=$PAGE")
    fi

    if [ "$(echo "$REPOS" | jq length)" -eq 0 ]; then
        break
    fi

    echo "$REPOS" | jq -c '.[]' | while read -r repo; do
        NAME=$(echo "$repo" | jq -r '.name')
        LANGUAGE=$(echo "$repo" | jq -r '.language')
        CLONE_URL=$(echo "$repo" | jq -r '.clone_url')

        # Filter by prefix
        if [ -n "$PREFIX" ] && [[ "$NAME" != $PREFIX* ]]; then
            continue
        fi

        # Filter by language
        if [ -n "$LANG" ] && [[ "$LANGUAGE" != "$LANG" ]]; then
            continue
        fi

        # Skip if already cloned
        if [ -d "$NAME" ]; then
            echo "Skipping $NAME (already exists)"
        else
            echo "Cloning $NAME (Language: $LANGUAGE)..."
            git clone "$CLONE_URL"
        fi
    done

    PAGE=$((PAGE + 1))
done

echo "Done cloning filtered repositories for user: $USERNAME"
