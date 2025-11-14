### 1) check remotes

```sh
git remote -v
```

usually you will see just

```
origin    git@github.com:you/yourfork.git
```

---

### 2) add upstream

```sh
git remote add upstream git@bitbucket.org:someproject.git
```

(or use https url if you want)

---

### 3) fetch

```sh
git fetch --all
```

---

### 4) merge/rebase what you want

example: update your local main from upstream main:

```sh
git checkout master
git pull upstream master
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

### 1️⃣ Don’t do a regular merge

```bash
git pull upstream master
```

* This **merges** upstream changes into your branch.
* Git creates a merge commit.
* All commits from master that weren’t in your branch appear in your PR.
* This is why your PR showed other people’s code.


### Optional: make `pull` always rebase

You can configure Git so that `git pull` automatically rebases instead of merging:

```bash
# Only rebase your own feature branches
git config --global pull.rebase true

# But protect orgin main/master from rebasing
git config branch.master.rebase false
# (or branch.main.rebase false)
```

### 4️⃣ Workflow summary

1. **Fetch latest master**

```bash
git fetch upstream
```

2. **Rebase your branch**

```bash
git rebase upstream/master
```

3. **Resolve any conflicts**
4. **Force push to your fork**

```bash
git push --force-with-lease origin your-branch
```

---

💡 Pro tip: If you always rebase your feature branches on top of upstream master before pushing, your PRs will **never accidentally include other people’s commits**.
You can safely remove a Git branch **both locally and remotely** with the following commands:

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
* Example:

```bash
git push origin --delete new_env_var4local
```

---

### 3. **Optional: clean up references locally**

After deleting a remote branch, you can remove stale references:

```bash
git fetch --prune
```

* This removes deleted branches from `git branch -r` listings.

# 
```sh
git pull upstream master
git checkout -b newbranch
git push
```