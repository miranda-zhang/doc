# check remotes

```sh
git remote -v
```

usually you will see just

```
origin    git@github.com:you/yourfork.git
```

---

# add upstream

```sh
git remote add upstream git@bitbucket.org:someproject.git
```

# Restore
```sh
# 1️⃣ Make sure you are on your PR branch
git checkout my-pr-branch

# 2️⃣ Reset the file to match main branch (or target branch)
git restore --source master config/config.exs

# 3️⃣ Stage the reverted file
git add path/to/file

# 4️⃣ Commit the revert
git commit -m "Revert changes"

# 5️⃣ Push the change to update the PR
git push
```
# Log
```sh
git log -2 --pretty=%B
```
# Config autoSetupRemote
always set the upstream automatically the first time you push a new branch
```sh
git config --global push.autoSetupRemote true
```

# No verify
```sh
git commit -am "msg" --no-verify
```
# Rebase

## Don’t do a regular merge

```bash
git pull upstream master
```

* This **merges** upstream changes into your branch.
* Git creates a merge commit.
* All commits from master that weren’t in your branch appear in your PR.
* This is why your PR showed other people’s code.


## Optional: make `pull` always rebase

You can configure Git so that `git pull` automatically rebases instead of merging:

```bash
# Only rebase your own feature branches
git config --global pull.rebase true

# But protect orgin main/master from rebasing
git config branch.master.rebase false
# (or branch.main.rebase false)
```

## Fix PR with other ppl's change

### 1. **Check your branch’s history**

Run:

```bash
git log --oneline --graph --decorate
```

* Look for **your commits** vs **other people’s commits**.
* Note the commit hashes of your work — these are what you want in the PR.

---

### 2. **Create a backup branch (optional but safe)**

```bash
git branch backup-my-pr
```

* This ensures you can always go back if something goes wrong.

---

### 3. **Rebase interactively onto `upstream/master`**

Assuming `upstream` is the main repo and `master` is the target branch:

```bash
git fetch upstream
git rebase -i upstream/master
```

* In the editor:

  * Keep (`pick`) only your commits.
  * Drop (`d`) other people’s commits that accidentally got pulled in.
* Save and exit. Resolve any conflicts if prompted.

---

# **Force-push your cleaned branch to your PR**

```bash
git push origin your-branch-name --force-with-lease
```
# Get rid of large file from commit history
```sh
. ~/Documents/workspace/venvg/git-tools-venv/bin/activate
git filter-repo --path semantic_search/python/docs_with_embeddings.jsonl --invert-paths
git remote add origin https://github.com/miranda-zhang/web_st.git
git push origin main --force
git log main --oneline
```
# Local ignore file
In `.git/info/exclude`

Same as `.gitignore` usage
# gitconfig
Git allows you to **include a config file conditionally**.

## Step 1: Create host-specific configs

For GitHub:

```ini
# ~/.gitconfig-github
[user]
    name = GitHub Name
    email = your_github_email@example.com
```

```ini
# ~/.gitconfig-bitbucket
[user]
    name = Your Bitbucket Name
    email = your_bitbucket_email@example.com

# Optional: set Bitbucket-specific aliases
[alias]
    co = checkout
    br = branch
    st = status

```
### Step 2: Edit global `~/.gitconfig` to include conditionally

```ini
[includeIf "gitdir:~/projects/github/"]
    path = ~/.gitconfig-github

[includeIf "gitdir:~/projects/bitbucket/"]
    path = ~/.gitconfig-bitbucket

# Optional: set default push behavior
[pull]
	rebase = true
[push]
	autoSetupRemote = true
[http]
	postBuffer = 524288000
	maxRequestBuffer = 1000M
```

* `gitdir:` matches the repo folder.
* Every repo under `~/projects/github/` will use GitHub credentials, etc.

> Note: `gitdir:` must **end with a slash** (`/`).

*(Requires Git 2.13+ for `includeIf`)*

* This method automatically switches user/email based on the remote URL.

## Verify effective config

Inside a repo:

```bash
git config user.name
git config user.email
```
It should show the host-specific config.

# Delete

### 1. **Delete a local branch**

```bash
git branch -d <branch-name>
```

* Use `-d` if the branch has been **fully merged**.
* Use `-D` to **force delete** even if it hasn’t been merged:

```bash
git branch -D <branch-name>
```
---

### 2. **Delete a remote branch**

```bash
git push origin --delete <branch-name>
```

* This tells the remote (`origin`) to remove the branch.

# PR
```sh
git fetch --all
git merge upstream/master
git checkout -b newbranch
git checkout my-feature-branch
git rebase -i upstream/master
git push --force-with-lease
git push origin my-feature-branch --force-with-lease
git rebase -i HEAD~2
git commit --amend -m "New commit message here" 
git commit -am "msg" --no-verify
```
