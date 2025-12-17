# Clone All GitHub Repositories Scripts

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![GitHub Repo Size](https://img.shields.io/github/repo-size/<USERNAME>/<REPO>.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/<USERNAME>/<REPO>.svg)
![GitHub issues](https://img.shields.io/github/issues/<USERNAME>/<REPO>.svg)
![GitHub forks](https://img.shields.io/github/forks/<USERNAME>/<REPO>.svg?style=social)
![GitHub stars](https://img.shields.io/github/stars/<USERNAME>/<REPO>.svg?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/<USERNAME>/<REPO>.svg?style=social)


This repository contains two Bash scripts for **cloning all repositories** from a GitHub user or GitHub Enterprise user.

- clone_all_repos.sh – Clones all **public repositories** from a standard GitHub user.  
- clone_all_repos_ghe.sh – Clones all **public and private repositories** from a GitHub Enterprise user using a personal access token.  

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