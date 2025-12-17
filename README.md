# Clone All GitHub Repositories Scripts

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![GitHub Repo Size](https://img.shields.io/github/repo-size/<USERNAME>/<REPO>.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/<USERNAME>/<REPO>.svg)
![GitHub issues](https://img.shields.io/github/issues/<USERNAME>/<REPO>.svg)
![GitHub forks](https://img.shields.io/github/forks/<USERNAME>/<REPO>.svg?style=social)
![GitHub stars](https://img.shields.io/github/stars/<USERNAME>/<REPO>.svg?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/<USERNAME>/<REPO>.svg?style=social)


This repository contains two Bash scripts for **cloning all repositories** from a GitHub user or GitHub Enterprise user.

- Clone specific repositories by **prefix**  
- Clone only repositories in a specific **programming language**  
- Supports both **public** and **private repos** (with token)  
- Works with GitHub and can be adapted for GitHub Enterprise

Both scripts handle **pagination** and skip repositories that are already cloned.


## Features

- Clones **all repositories** from a given user.  
- Handles GitHub pagination (supports users with 100+ repositories).  
- Can clone **HTTPS or SSH URLs**.  
- Skips repositories that already exist in the target folder.  
- Supports **private repositories** on GitHub Enterprise using a token.  


## Prerequisites

- git installed  
- curl installed  
- jq installed (for parsing JSON)  
- Optional: GitHub personal access token (required for private repositories or Enterprise)  


## Features

- Clone **all repos** from a user  
- Filter repos by **name prefix**  
- Filter repos by **primary language** (Java, C#, etc.)  
- Skip **already cloned repos**  
- Supports **pagination** for users with 100+ repos  
- Works with **GitHub Enterprise** (requires token)  

## Usage

### 1. Standard GitHub User

```bash
chmod +x clone_all_repos.sh
./clone_all_repos.sh <github_username>
```

### Example 

```bash 
./clone_all_repos.sh metodiev
```

### GitHub Enterprise User

```bash
chmod +x clone_all_repos_ghe.sh
./clone_all_repos_ghe.sh <enterprise_base_url> <github_username> <personal_access_token>
```

```bash
./clone_all_repos_ghe.sh https://github.company.com metodiev ghp_xxxxx
```

This will:

- Connect to your GitHub Enterprise server via the API.
- Clone all repositories (public and private) for the specified user.
- Skip already cloned repositories.

### Clone Filtered repos

Clone repos starting with project

```bash
./clone_filtered_repos.sh torvalds project- ""
```

Clone only Java repos:

```bash
./clone_filtered_repos.sh torvalds "" Java
```


Clone only .NET/C# repos:

```bash
./clone_filtered_repos.sh torvalds "" "C#"

```

Clone private Java repos from GitHub Enterprise:

```bash
./clone_filtered_repos.sh johndoe "" Java ghp_xxxxx
```

### Notes

- Prefix and language filters can be combined.
- For GitHub Enterprise, set API_URL="https://<your-ghe>/api/v3/users/$USERNAME/repos".
- kips repos that already exist in the target folder.
- Language filtering uses GitHub API's primary language field.

## Diagram:

```mermaid
flowchart TD
    A[Start Script] --> B[Check Username]
    B --> C[Check Filters]
    C --> D{Prefix Filter?}
    D -->|Yes| E[Skip repos not matching prefix]
    D -->|No| F[Continue]
    E --> F
    F --> G{Language Filter?}
    G -->|Yes| H[Skip repos not matching language]
    G -->|No| I[Continue]
    H --> I
    I --> J{Already Cloned?}
    J -->|Yes| K[Skip repo]
    J -->|No| L[Clone repo via git]
    K --> M[Next repo]
    L --> M
    M --> N[Next page of repos?]
    N -->|Yes| B
    N -->|No| O[End]

