# Semantic search
## **1. What semantic search is**

* Traditional search relies on **keyword matching**:

  * `"Milw"` matches `"Milwaukee drill"` because of **prefix/n-gram matching**.
  * `"saw"` matches `"circular saw"` if the token exists.
* **Semantic search** tries to understand the **meaning** behind words, not just exact matches.

  * `"lawnmower"` could match `"garden grass cutter"`.
  * `"impact driver"` could match `"power drill with hammer action"`.

In other words, it’s about **matching concepts rather than literal tokens**.

---

## **2. How semantic search is implemented**

### **a. Vector embeddings + similarity search**

* Each document and query is converted into a **vector** using an AI model (e.g., OpenAI embeddings, BERT, etc.).
* The search finds documents whose vectors are **closest to the query vector** (cosine similarity, etc.).
* This allows **semantic matches**, not just keyword matches.

### **b. Hybrid search**

* Combine **traditional keyword search** (Elasticsearch) with **vector similarity**.
* Elasticsearch 8.x supports **kNN vector search** natively.

---

## **Do you need AI for semantic search?**

* If you want to match based on **meaning rather than exact words**, yes:

  1. Generate **vector embeddings** for your documents using an AI model.
  2. Generate embeddings for the user query.
  3. Store embeddings in Elasticsearch (`dense_vector` field) or use a specialized semantic search engine.
  4. Search by **vector similarity**.

* Options:

  * **Elasticsearch 8.x vector fields + kNN search** (on-prem, no external AI service required).
  * **External AI services** (OpenAI, Cohere, etc.) to generate embeddings, then store/search vectors in Elasticsearch.

---

### **How it compares**

| Feature                    | Keyword-based search | Semantic search   |
| -------------------------- | ---------- | ----------------- |
| Prefix / autocomplete      | ✅          | ✅ (optional)      |
| Synonyms                   | ✅          | ✅ (can combine)   |
| N-grams / shingles         | ✅          | ✅ (can combine)   |
| Understanding meaning      | ❌          | ✅ (AI embeddings) |
| Misspellings / paraphrases | ❌          | ✅                 |

# Example setup
To add **semantic search** to your current Elasticsearch setup, **without changing your existing indices or app**, using **OpenAI embeddings** and Elasticsearch `dense_vector` fields.

---

## **1. Prerequisites**

1. Elasticsearch 8.x (or later) — supports `dense_vector` type and kNN search.
2. OpenAI API key (or any embedding model).
3. Your Elixir app can use **HTTP requests** (`HTTPoison`) or a Python script to generate embeddings.

---

## **2. Create a new “semantic” index**

We will create a **parallel index** that stores embeddings alongside your existing documents:

```bash
curl -X PUT "localhost:9200/aurora-semantic-index" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "properties": {
      "title": { "type": "text" },
      "description": { "type": "text" },
      "embedding": {
        "type": "dense_vector",
        "dims": 1536
      }
    }
  }
}'
```

* `embedding` → stores the vector from AI model (e.g., OpenAI’s 1536-dim embeddings).
* `title`/`description` → human-readable fields you can still search with traditional methods.

---

## **3. Generate embeddings for your documents**

Example in **Python** (but same logic applies in Elixir via HTTP):

```python
import openai
import requests
import json

openai.api_key = "YOUR_OPENAI_API_KEY"

docs = [
    {"id": 1, "title": "Milwaukee Drill", "description": "Cordless drill with hammer function"},
    {"id": 2, "title": "Ryobi Circular Saw", "description": "Electric saw for wood cutting"}
]

for doc in docs:
    # Generate embedding
    emb = openai.Embedding.create(
        model="text-embedding-3-small",
        input=doc["title"] + " " + doc["description"]
    )["data"][0]["embedding"]

    # Index in Elasticsearch
    requests.post(
        "http://localhost:9200/aurora-semantic-index/_doc/" + str(doc["id"]),
        headers={"Content-Type": "application/json"},
        data=json.dumps({
            "title": doc["title"],
            "description": doc["description"],
            "embedding": emb
        })
    )
```

* Each document now has a **vector representation** in Elasticsearch.

---

## **4. Query with semantic search**

We’ll convert the **user query** into an embedding and search by **cosine similarity**:

```python
query = "cordless drill for concrete"

# Get embedding for query
query_emb = openai.Embedding.create(
    model="text-embedding-3-small",
    input=query
)["data"][0]["embedding"]

# kNN search in Elasticsearch
body = {
  "size": 5,
  "query": {
    "script_score": {
      "query": { "match_all": {} },
      "script": {
        "source": "cosineSimilarity(params.query_vector, 'embedding') + 1.0",
        "params": { "query_vector": query_emb }
      }
    }
  }
}

response = requests.get(
    "http://localhost:9200/aurora-semantic-index/_search",
    headers={"Content-Type": "application/json"},
    data=json.dumps(body)
)
print(response.json())
```

* Returns **top 5 documents most semantically similar** to the query.
* `cosineSimilarity` scores the vectors.

---

## **5. Integrating with your Elixir app**

1. Keep your **existing indices (`aurora-index-*`)** for keyword search and suggestions.
2. Add a **new semantic index (`aurora-semantic-index`)** for AI-powered search.
3. In Elixir, you can:

```elixir
alias HTTPoison

# Step 1: Call OpenAI API to get embedding
embedding = MyApp.OpenAI.get_embedding("cordless drill for concrete")

# Step 2: Search Elasticsearch semantic index
body = %{
  "size" => 5,
  "query" => %{
    "script_score" => %{
      "query" => %{ "match_all" => %{} },
      "script" => %{
        "source" => "cosineSimilarity(params.query_vector, 'embedding') + 1.0",
        "params" => %{ "query_vector" => embedding }
      }
    }
  }
} |> Jason.encode!()

{:ok, %HTTPoison.Response{body: resp}} =
  HTTPoison.post("http://localhost:9200/aurora-semantic-index/_search",
                 body,
                 [{"Content-Type", "application/json"}])

IO.inspect(Jason.decode!(resp))
```

* No need to touch your existing indices.
* Keyword + suggestions still work; semantic search is **optional/additive**.

---

## **6. Summary**

* Add a **new semantic index** with `dense_vector` fields.
* Generate **embeddings** for your documents using OpenAI or similar.
* Query by **vector similarity** to retrieve semantically relevant results.
* Can coexist with your current `search_as_you_type` suggestion indices.
