# Install

## 🧩 1. Update your system

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 🔑 2. Install prerequisites

Elasticsearch requires `curl`, `apt-transport-https`, and `gnupg`:

```bash
sudo apt install apt-transport-https curl gnupg -y
```

---

## 📦 3. Add Elastic’s GPG key

```bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
```

---

## 🗂️ 4. Add the Elasticsearch APT repository

Create the repository file:

```bash
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
```

---

## 🔄 5. Update package lists again

```bash
sudo apt update
```

---

## ⚙️ 6. Install Elasticsearch

You can install a specific version using:

```bash
sudo apt install elasticsearch=8.16.0
```

If you want to verify available versions:

```bash
apt list -a elasticsearch
```

---

## 🧰 7. Enable and start the Elasticsearch service

```bash
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
```

Check status:

```bash
sudo systemctl status elasticsearch.service
```

---

## 🔍 8. Verify installation
Check version
```sh
curl -X GET "localhost:9200/"
```

Run:

```bash
curl -u elastic https://localhost:9200 -k
```

> 📝 During installation, Elasticsearch 8.x automatically generates:
>
> * A temporary password for the `elastic` user
> * Certificates for TLS encryption
> * A `config/elasticsearch.yml` with security enabled by default

To find the generated password:

```bash
sudo grep "password for the elastic user" /var/lib/elasticsearch/elastic-stack.yml 2>/dev/null || sudo grep "password for the elastic user" /usr/share/elasticsearch/config/elasticsearch-*.log
```

When Elasticsearch starts for the first time, it *usually* generates a password for the built-in `elastic` user automatically.
But if the service was started **non-interactively** (e.g., via `systemctl`), so Elasticsearch couldn’t tell if a terminal was attached — and **skipped password creation** for security reasons.
So now, you just need to **manually create one**.

---

### 🔐 Step 1. Set (or reset) the `elastic` user password

Run this as **root or with sudo**:

```bash
sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic
```

You’ll get output like:

```
This tool will reset the password of the [elastic] user.
Please confirm that you would like to continue [y/N] y
Password for the [elastic] user successfully reset.
New value: 2rjLq3TtQ6mU4z3mG5bV
```

👉 Copy and save that password securely — you’ll use it for all API calls and Kibana access.

---

### 🧪 Step 2. Test the connection

Now run:

```bash
curl -u elastic http://localhost:9200 -k
```

When prompted, enter the password you just generated.

Expected response:

```json
{
  "name" : "debian",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "...",
  "version" : {
    "number" : "8.16.0"
  },
  "tagline" : "You Know, for Search"
}
```

---

### ⚙️ Step 3 (optional). Disable security for local development

If you don’t want to deal with passwords or HTTPS locally, edit:

```bash
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Add these lines at the bottom:

```yaml
xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
```

Then restart Elasticsearch:

```bash
sudo systemctl restart elasticsearch
```

Now you can connect simply with:

```bash
curl http://localhost:9200
```


## ⚙️ 9. (Optional) Configure Elasticsearch

Edit the main config file:

```bash
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Common settings:

```yaml
cluster.name: my-application
node.name: node-1
network.host: 0.0.0.0   # or your private IP

```

Then restart:

```bash
sudo systemctl restart elasticsearch
```

---

## 🧪 10. Test connection password

```bash
curl -k -u elastic https://localhost:9200
```

Expected output:

```json
{
  "name" : "node-1",
  "cluster_name" : "my-application",
  "cluster_uuid" : "qpFZMEp4TCqCBmX-A5X9Uw",
  "version" : {
    "number" : "8.16.0",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "12ff76a92922609df4aba61a368e7adf65589749",
    "build_date" : "2024-11-08T10:05:56.292914697Z",
    "build_snapshot" : false,
    "lucene_version" : "9.12.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}

```
## 11. Disable auto start
On **Debian (and other systemd-based Linux systems)**, Elasticsearch is configured as a **systemd service**, which means it will automatically start at boot unless you disable it.

Here’s how you can **stop Elasticsearch from auto-starting**:

```bash
sudo systemctl disable elasticsearch
```

You should see:

```
Removed /etc/systemd/system/multi-user.target.wants/elasticsearch.service.
```

That means it’s disabled successfully.

---

Verify it’s disabled

```bash
systemctl is-enabled elasticsearch
```

Expected output:

```
disabled
```

---

(Optional) Re-enable later

If you ever want it to auto-start again:

```bash
sudo systemctl enable elasticsearch
```

# Change elasticsearch jvm setting to use only 1 GB of memory.
> /etc/elasticsearch/jvm.options
```sh
sudo nano /etc/elasticsearch/jvm.options
```
```
-Xms1g
-Xmx1g
```
Make sure the file permission is correct
```sh
sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch
```
# Check log for error msg
```sh
sudo journalctl -u elasticsearch.service -b
```