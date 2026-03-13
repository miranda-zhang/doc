## **BM25 in Elasticsearch**

* Elasticsearch uses **BM25** as its default similarity scoring algorithm for full-text queries.
* This applies unless you explicitly change the similarity in your mapping.
* [BM25](./bm25.ipynb) is a ranking function based on **term frequency, inverse document frequency, and field length normalization**.

## **`multi_match` query types**

`multi_match` is a wrapper for matching a query string across multiple fields. Its `type` determines **how the scores from multiple fields are combined**.

### a) `"best_fields"`

```json
{
  "multi_match": {
    "query": "search text",
    "fields": ["title", "description"],
    "type": "best_fields"
  }
}
```

* Searches across all specified fields.
* Uses the **score from the single field that matches best**.
* Default scoring (BM25) is applied per field.
* Use when you want the **best single-field match** to determine relevance.

### b) `"cross_fields"`

```json
{
  "multi_match": {
    "query": "search text",
    "fields": ["title", "description"],
    "type": "cross_fields"
  }
}
```

* Treats multiple fields as **one combined field**.
* Useful for cases where the query might span multiple fields (`first_name` + `last_name`).
* BM25 is still used internally, but **scores are combined across fields**.
* Better when each field only contains part of the query terms.

---

✅ **In short:**

* Both `"best_fields"` and `"cross_fields"` are BM25-based by default.
* The `type` only affects **how scores from multiple fields are combined**, not the underlying scoring algorithm itself.
