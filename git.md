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

### 4. **Force-push your cleaned branch to your PR**

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
git fetch upstream
git checkout -b newbranch
git checkout my-feature-branch
git fetch --all
git rebase -i upstream/master
git push --force-with-lease
git push origin my-feature-branch --force-with-lease
git rebase -i HEAD~2
```
