# Neo4j

Check the status:

```bash
sudo systemctl status neo4j
```

Access Neo4j Browser

[http://localhost:7474](http://localhost:7474)

```bash
neo4j version
```

Neo4j CLI:
```bash
cypher-shell -u neo4j -p neo4j
```

Edit config:
```sh
sudo nano /etc/neo4j/neo4j.conf
sudo systemctl restart neo4j
```
# Log
```sh
sudo tail -f /var/log/neo4j/debug.log
awk '$1 > "2025-12-01" && /Exception/' /var/log/neo4j/debug.log

sudo cp /var/log/neo4j/debug.log /var/log/neo4j/debug.log.$(date +%Y%m%d_%H%M%S) && sudo truncate -s 0 /var/log/neo4j/debug.log
```
