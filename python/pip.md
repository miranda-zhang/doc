# tmp run out of space
Even if your venv is in `/home`, pip uses:

* `/tmp` for temporary build files
* `/root/.cache/pip` or `~/.cache/pip` for download cache
* sometimes `/` for unpacking wheels

PyTorch wheels can temporarily extract to **> 2.5 GB**.

So pip is hitting **disk full** even though `/home` is large.

---

# ✅ Fix: force pip to use `/home` for *all* temporary files

Run this inside your venv:

### **1. Create custom cache and temp directories**

```bash
mkdir -p ~/pip_cache
mkdir -p ~/pip_tmp
```

### **2. Install Torch while forcing pip to use /home**

```bash
TMPDIR=~/pip_tmp pip install --cache-dir ~/pip_cache torch --index-url https://download.pytorch.org/whl/cpu
```

### ⚠️ Notice:

* `TMPDIR=~/pip_tmp` forces pip to avoid `/tmp`
* `--cache-dir ~/pip_cache` prevents writes to `/`
* Installing **CPU-only Torch** drastically reduces the size from ~900MB to ~150MB

---

# 🚀 Recommended full sequence (copy/paste)

```bash
cd ~/Documents/workspace
python3 -m venv semantic_env
source semantic_env/bin/activate

mkdir -p ~/pip_cache
mkdir -p ~/pip_tmp

pip install --upgrade pip

TMPDIR=~/pip_tmp pip install --cache-dir ~/pip_cache torch --index-url https://download.pytorch.org/whl/cpu

TMPDIR=~/pip_tmp pip install --cache-dir ~/pip_cache sentence-transformers
```

This will succeed even with small `/` and `/tmp`.
