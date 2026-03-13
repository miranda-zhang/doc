# Remotes
check remotes
```sh
git remote -v
```

usually you will see just

```
origin    git@github.com:you/yourfork.git
```
Add a remote
```sh
git remote add feng-wei-aurora-relay git@bitbucket.org:feng-wei/aurora_relay.git
```
Then checkout the remote branch
```sh
git fetch feng-wei-aurora-relay
git checkout -b slider feng-wei-aurora-relay/master
```
# add upstream

```sh
git remote add upstream git@bitbucket.org:someproject.git
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

# Config ssh credential
Edit global `~/.gitconfig` to include conditionally

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
# Diff
```sh
git diff --ignore-space-at-eol
git diff --cached
```
# Delete untracked files
```sh
git clean -n
git clean -f
```
# restore
Discard all local changes in the current directory (working tree only) and restore files to the last committed state (HEAD).
```sh
# old
git checkout -- .
# new
git restore .
```
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
git rebase -i --committer-date-is-author-date upstream/master
git push --force-with-lease
git push origin my-feature-branch --force-with-lease
git rebase -i HEAD~2
git commit --amend -m "New commit message here" 
git commit -am "msg" --no-verify
git reset
```
