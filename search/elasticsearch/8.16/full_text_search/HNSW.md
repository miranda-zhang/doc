# Hierarchical Navigable Small World graph
HNSW stands for **Hierarchical Navigable Small World graph**.
It’s a **fast approximate nearest-neighbor (ANN)** algorithm widely used in vector search engines (Elasticsearch, OpenSearch, Pinecone, Milvus, FAISS, Vespa, etc.).

Here’s the short and practical explanation:

---

# 🚀 **What HNSW Actually Does**

When you search for similar embeddings (vectors), you want the *closest* vectors.

But if you have **millions** of embeddings, doing a brute-force search is too slow.

HNSW speeds this up by organizing vectors in a graph structure so that Elasticsearch (or any vector DB) can jump through “shortcuts” instead of scanning everything.

---

# 📚 Why is it called HNSW?

### **Hierarchical**

The algorithm builds *multiple layers*.
Top layers contain very few “key” nodes (like landmarks).
Bottom layers contain all vectors.

Search starts at the top and “falls down” toward the best region.

---

### **Navigable**

You can move from one vector to its neighbors—like navigating a graph.

---

### **Small World**

Borrowed from graph theory:
any node can be reached through a small number of hops (like “6 degrees of separation”).

---

# 🔍 How Search Works (Simplified)

Let’s say you insert 1 million vector embeddings:

* HNSW links each vector to its nearest neighbors.
* At query time:

  1. Start at a high level (few nodes)
  2. Greedily walk toward closer neighbors
  3. Drop to lower layers for more accurate results
  4. Stop when the nearest vectors are found

This gives **99% accurate results at ~100x speed-up**.

---

# 🧠 Why Elasticsearch Uses HNSW

Because it:

* is fast
* works well with high-dimensional embeddings
* has predictable latency
* supports incremental insertion
* is memory efficient

That’s why ES 8.x, OpenSearch, and most other vector DBs use it.

---

# 🧪 Tiny Example

Imagine a search for similar items:

You search for the embedding of:

```
"red cordless drill"
```

Instead of scanning all documents, HNSW:

* jumps to a “hardware tools” region in the vector graph
* then walks to neighbors representing drills
* returns the closest matches almost instantly

---

# ✔ Summary

**HNSW = a graph-based ANN algorithm for fast vector similarity search.**
It’s the backbone of Elasticsearch’s **kNN** search.
