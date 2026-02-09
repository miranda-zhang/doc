# Kibana (official Elasticsearch UI)

Kibana is the web UI for Elasticsearch.

```bash
# On Linux
sudo apt install kibana

# Or download from https://www.elastic.co/downloads/kibana
```

You can start it as a **system service**:

```bash
sudo systemctl enable kibana
sudo systemctl start kibana
```

Check status:

```bash
sudo systemctl status kibana
```

http://localhost:5601

That’s the **Kibana UI** where you can explore your Elasticsearch cluster, run queries in **Dev Tools**, and visualize data.

# Log
```bash
sudo journalctl -u kibana | grep -i error
```

* `-i` → case-insensitive (matches `ERROR`, `Error`, etc.)
* To **follow in real-time**:

```bash
sudo journalctl -u kibana -f | grep -i error
```
# setting
```sh
sudo nano /etc/kibana/kibana.yml
sudo systemctl restart kibana
```
## Create service token
```sh
sudo /usr/share/elasticsearch/bin/elasticsearch-service-tokens create elastic/kibana kibana-token
```

## Configure encryption key for Kibana
```sh
openssl rand -base64 32
```
Edit your Kibana config:

```yaml
xpack.encryptedSavedObjects.encryptionKey: "PASTE_VALUE_HERE"
# xpack.reporting.encryptionKey: "PASTE_VALUE_HERE"
# xpack.security.encryptionKey: "PASTE_VALUE_HERE"
```
## APM
```yaml
xpack.apm.enabled: false
```
