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
