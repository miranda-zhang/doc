# Neo4j
## 🧠 What **Neo4j** Is

**Neo4j** is a **graph database** — meaning it stores data as **nodes** and **relationships** instead of traditional tables (like MySQL or PostgreSQL).

It’s designed for data that’s **highly connected**, such as:

* Social networks (people connected to people)
* Knowledge graphs (concepts linked together)
* Recommendation systems (users → items → tags)
* Fraud detection (transactions between accounts)
* Network topology (computers and connections)

---

## 🧩 The Core Idea

Instead of **rows and columns**, you have:

| Concept                | In Neo4j         | Example                         |
| ---------------------- | ---------------- | ------------------------------- |
| **Row / Record**       | **Node**         | `(:Person {name: "Alice"})`     |
| **Foreign key / join** | **Relationship** | `(Alice)-[:FRIEND]->(Bob)`      |
| **Table**              | **Label**        | `:Person`, `:Movie`, `:Company` |
| **Column / field**     | **Property**     | `{name: "Alice", age: 30}`      |

Relationships are **first-class citizens** — fast, stored directly with nodes — so queries like “find all friends of friends of Alice” are **much faster** than doing SQL joins.

---

## 💬 Example Graph

Imagine:

```
(:Person {name: "Alice"})-[:FRIEND]->(:Person {name: "Bob"})
(:Person {name: "Alice"})-[:LIKES]->(:Movie {title: "Inception"})
```

You can query it using Neo4j’s query language **Cypher**:

```cypher
MATCH (a:Person {name: "Alice"})-[:FRIEND]->(b)
RETURN b.name;
```

➡️ Output:

```
Bob
```

Or:

```cypher
MATCH (p:Person)-[:LIKES]->(m:Movie)
RETURN p.name, m.title;
```

---

## ⚙️ Components

| Component         | Description                                                       |
| ----------------- | ----------------------------------------------------------------- |
| **Neo4j Server**  | The core database engine                                          |
| **Neo4j Browser** | Web UI for queries and visualization (on `http://localhost:7474`) |
| **Bolt protocol** | Binary protocol used by apps/drivers (`bolt://localhost:7687`)    |
| **Cypher**        | Query language (like SQL for graphs)                              |
| **Drivers**       | Libraries for Python, Java, JavaScript, Elixir, etc.              |

---

## 🧰 Typical Use Cases

| Use case                    | Why Neo4j fits                                             |
| --------------------------- | ---------------------------------------------------------- |
| **Social networks**         | People and relationships are a natural graph               |
| **Recommendation engines**  | “People like you liked…” involves traversing relationships |
| **Fraud detection**         | Suspicious account networks, money flows                   |
| **Knowledge graphs**        | Semantic connections between entities                      |
| **Network & IT management** | Devices, connections, dependencies                         |

---

## 🧮 Example Query Power

SQL:

```sql
SELECT f2.name
FROM friends f1
JOIN friends f2 ON f1.friend_id = f2.id
WHERE f1.name = 'Alice';
```

Cypher:

```cypher
MATCH (a:Person {name:'Alice'})-[:FRIEND]->()-[:FRIEND]->(fof)
RETURN fof.name;
```

— clear, intuitive, and **mirrors the graph itself**.

---

## 🚀 Summary

| Feature            | Neo4j Strength                                   |
| ------------------ | ------------------------------------------------ |
| **Data model**     | Graph (nodes + relationships)                    |
| **Query language** | Cypher                                           |
| **Speed**          | Excellent for connected data (traversals)        |
| **Storage**        | ACID-compliant, persistent                       |
| **Access**         | Browser UI + Bolt protocol                       |
| **Best for**       | Networks, relationships, recommendations, graphs |

# Useful commands
```bash
sudo systemctl start neo4j
sudo systemctl restart neo4j
```

Once running, open a browser and go to:

👉 [http://localhost:7474](http://localhost:7474)

Check log:
```bash
sudo journalctl -u neo4j -n 50 --no-pager
```
