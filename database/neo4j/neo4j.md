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
# Memory
Neo4j mainly uses two memory areas:

| Setting                                                       | Purpose                                                                  |
| ------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `dbms.memory.heap.initial_size` / `dbms.memory.heap.max_size` | Java heap memory for query execution, caching objects                    |
| `dbms.memory.pagecache.size`                                  | OS-level memory mapped cache for storing nodes/relationships efficiently |

**Where to check:** `/etc/neo4j/neo4j.conf` (or via environment variables if using Docker).
* Heap: ~50% of available RAM, but at least enough to run queries without GC bottlenecks.
* Page cache: Large enough to hold frequently accessed parts of the graph.
* Swap usage: Avoid heavy swapping; Neo4j performance drops if it swaps memory.
* Setting the initial and the max heap size to the same value means the JVM will never need to change the heap size. Changing the heap size otherwise involves a full GC, which is desirable to avoid.
* [Script to estimate memory](./memory_estimate.py)
```properties
# Java heap
dbms.memory.heap.initial_size=1G
dbms.memory.heap.max_size=1G
# Page cache
dbms.memory.pagecache.size=256m
```
Edit config
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
Ah! With **~53,000 products**, we’re still talking about a **relatively small graph**, so your settings will likely be fine for **local testing**, but we can think about memory a bit more carefully. Let’s estimate:

---


---

### 2. **Other Considerations**

* If you have **many properties per product** or **images/large blobs**, memory usage grows — but for typical properties (name, price, category, etc.), 256 MB page cache + 1 GB heap is fine.
* Queries that do **massive aggregations or multi-hop traversals** may need more heap, but for basic lookups, filtering, and simple relationships, it will be snappy.

---

### 3. **Suggested Tweaks (Optional)**

For slightly better performance on your small laptop:

```properties
dbms.memory.heap.initial_size=1G
dbms.memory.heap.max_size=1G
dbms.memory.pagecache.size=512m
```

* Doubling page cache gives a little more breathing room for graph storage.
* Still safe on a laptop with 4–8 GB RAM.

---

✅ **Bottom line:**
Your current config **will work fine** for 53k products. If you notice queries hitting disk too much, you can bump **page cache to 512 MB**, but it’s not strictly necessary for testing.

---

If you want, I can give a **very quick Neo4j memory “rule of thumb” for graphs up to a few million nodes**, so you can plan ahead for bigger datasets. That’s handy. Do you want me to do that?
