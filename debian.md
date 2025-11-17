Change to root user
```bash
sudo su
```

Open gui file manager
```bash
xdg-open .
```
xdg comes from "X Desktop Group"

Check sudo right
```bash
sudo whoami
```

which shell is using
```bash
echo $SHELL
```

check mem
```bash
free -h
```

This shows the top 10 memory-hungry processes:
```bash
ps aux --sort=-%mem | head -n 10
```

Find what’s using port `4000` and kill it:

```bash
sudo lsof -i :4000
```

You’ll see something like:

```
beam.smp   12345 mirandazhang   12u  IPv4 0x...  TCP *:4000 (LISTEN)
```

Then kill it:

```bash
kill -9 12345
```

```bash
sudo apt update
sudo apt install -f ./<file>.deb
# If you're on an older Linux distribution, you will need to run this instead:
# sudo dpkg -i <file>.deb
# sudo apt-get install -f # Install dependencies
```

# CPU architecture
To check whether your **Debian system** is running on **ARM** or **Intel (x86/x86_64)** architecture, you can run one of the following commands in the terminal:

---

### 🧩 Option 1: Use `uname -m`

```bash
uname -m
```

**Interpretation:**

* `x86_64` → Intel or AMD 64-bit (most desktops/laptops)
* `i686` or `i386` → Intel 32-bit
* `armv7l` → ARM 32-bit
* `aarch64` → ARM 64-bit

---

### 🧩 Option 2: Use `dpkg --print-architecture`

```bash
dpkg --print-architecture
```

**Output examples:**

* `amd64` → Intel/AMD 64-bit
* `i386` → Intel 32-bit
* `armhf` → ARM 32-bit (hard float)
* `arm64` → ARM 64-bit

---

### 🧩 Option 3: Use `lscpu`

```bash
lscpu
```

This gives detailed CPU information. Look for:

* **Architecture:** (`x86_64`, `arm64`, etc.)
* **Model name:** to identify specific CPU type.

---

### ✅ Example outputs

**Intel/AMD:**

```
$ uname -m
x86_64
$ dpkg --print-architecture
amd64
```

**ARM:**

```
$ uname -m
aarch64
$ dpkg --print-architecture
arm64
```

Check file permissions:
```bash
ls -l /mnt/internal
```

# Disk Space
Clear cached .deb packages in /var/cache/apt/archives
```bash
sudo apt clean
df -h /var
```

See what’s using space in /var

Run this to identify the biggest directories:

```bash
$ sudo du -h --max-depth=1 /var | sort -hr
7.6G	/var
7.3G	/var/lib
$ sudo du -h --max-depth=1 /var/lib | sort -hr | head -10
7.3G	/var/lib
7.0G	/var/lib/postgresql
153M	/var/lib/apt
78M	/var/lib/elasticsearch
69M	/var/lib/dpkg
$ df -h /var /srv 
Filesystem                   Size  Used Avail Use% Mounted on
/dev/mapper/debian--vg-var   9.1G  7.7G  936M  90% /var
/dev/mapper/debian--vg-root   23G  9.1G   13G  43% /
```
You can move PostgreSQL’s data directory to a larger filesystem, e.g. /srv/postgresql or /data.

Example procedure:
```bash
sudo systemctl stop postgresql
sudo rsync -av /var/lib/postgresql /srv/
sudo mv /var/lib/postgresql /var/lib/postgresql.bak
sudo ln -s /srv/postgresql /var/lib/postgresql

sudo mkdir -p /srv/postgresql
sudo mv /var/lib/postgresql.bak/* /srv/postgresql/
sudo chown -R postgres:postgres /srv/postgresql
sudo chmod 700 /srv/postgresql

sudo systemctl restart postgresql
sudo -i -u postgres
psql -h localhost aurora_dev
```

# Add App to Menu and Dash
Add **Postman** to your **Applications menu** and **keep its icon in the Dash** on Debian (or any GNOME-based desktop). Here’s how, step-by-step:

---

### 🧩 1. Move Postman to a good location

If you downloaded Postman manually (e.g. a `.tar.gz` file), it’s best to place it somewhere system-wide:

```bash
sudo mv ~/Downloads/Postman /opt/
```

This puts it in `/opt/Postman`.

---

### ⚙️ 2. Create a `.desktop` launcher file

Create a new launcher so Postman shows up in your **Applications** menu.

```bash
sudo nano /usr/share/applications/postman.desktop
```

Then paste this:

```ini
[Desktop Entry]
Name=Postman
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Type=Application
Categories=Development;
StartupNotify=true
Terminal=false
```

> 💡 Make sure the `Icon` path exists — you can check with
> `ls /opt/Postman/app/resources/app/assets/`
> (sometimes it’s `icon_128x128.png`).

Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

### 🪄 3. Make it executable

```bash
sudo chmod +x /usr/share/applications/postman.desktop
```

Now Postman should appear if you search for it in your **Activities menu**.

---

### 📌 4. Pin it to the dock

Once Postman shows up:

1. Open it from the Activities menu.
2. Right-click the Postman icon in the dock.
3. Select **“Add to Favorites.”**

That pins it to your dock permanently.

---

### ✅ 5. (Optional) Add updates easily

If you ever update Postman manually:

* Just replace `/opt/Postman` with the new extracted folder.
* The launcher and dock shortcut will still work.

# Keyboard short cut
Hides the window (puts it into the “hidden” state)
`Super/Win + H` 

# Symlink

* `ln -s <target> <link>`

  * `<target>` = actual file location
  * `<link>`   = where it should appear

```sh
ln -s ~/.bashrc ~/Documents/workspace/config_files/.bashrc
sudo ln -s /etc/systemd/logind.conf ~/Documents/workspace/config_files/logind.conf 
```
# Auto update
1. Install `unattended-upgrades`:

```bash
sudo apt install unattended-upgrades
```

2. Enable it:

```bash
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

**Important:** Updates happen **while the system is running**, not during shutdown.
# Install Updates
```sh
sudo apt upgrade -y
```
# Auto Power off
> /etc/systemd/logind.conf
```sh
IdleAction=poweroff
IdleActionSec=2h
```
