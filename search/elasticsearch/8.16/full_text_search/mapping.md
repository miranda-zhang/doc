# What is a Mapping in Elasticsearch?

A **mapping** in Elasticsearch is like a **schema for your index**. It defines:

* **Field names** in your documents
* **Data types** for each field (text, keyword, number, date, boolean, etc.)
* **How Elasticsearch should index and store the fields** (analyzed, not_analyzed, etc.)
* Optional **field-level settings** like analyzers, norms, or multi-fields

Without a mapping, Elasticsearch tries to **guess the type automatically** (dynamic mapping), but this can lead to unexpected behavior for numeric or date fields.

# Basic Data Types

| Type        | Use Case                                    |
| ----------- | ------------------------------------------- |
| `text`      | Full-text searchable strings (analyzed)     |
| `keyword`   | Exact values, aggregations, sorting         |
| `integer`   | Whole numbers                               |
| `float`     | Decimal numbers                             |
| `boolean`   | True/False values                           |
| `date`      | Date/time, can define formats               |
| `object`    | JSON objects (nested fields)                |
| `nested`    | Arrays of objects that need query isolation |
| `geo_point` | Lat/lon coordinates for geo queries         |
| `ip`        | IP addresses                                |

# Example Mapping

Suppose you want an index for **products**:

```json
PUT /products
{
  "mappings": {
    "properties": {
      "name": {
        "type": "text",
        "analyzer": "standard"
      },
      "category": {
        "type": "keyword"
      },
      "price": {
        "type": "float"
      },
      "in_stock": {
        "type": "boolean"
      },
      "release_date": {
        "type": "date",
        "format": "yyyy-MM-dd"
      },
      "tags": {
        "type": "keyword"
      },
      "description": {
        "type": "text",
        "analyzer": "english"
      }
    }
  }
}
```

**Explanation**:

* `name` → full-text search (analyzed)
* `category` → exact match (keyword) for filters or aggregations
* `price` → numeric for range queries
* `in_stock` → true/false filter
* `release_date` → date format
* `tags` → array of exact keywords
* `description` → analyzed for English language full-text search

# Multi-Fields (Optional)

If you want a field to be searchable **both analyzed and exact**, you can define **multi-fields**:

```json
"name": {
  "type": "text",
  "fields": {
    "raw": { "type": "keyword" }
  }
}
```

* `name` → analyzed for search
* `name.raw` → exact match for sorting or aggregations

# Tips

1. Define mappings **before indexing data**.
2. Use **keyword** for filtering, sorting, and aggregations.
3. Use **text** for full-text search.
4. Use **nested** if you have arrays of objects and need per-object queries.
5. For semantic search or vectors, you can add `dense_vector` fields.

# More
- [Type: Text vs Keyword](./field_type.md)
- [Type: keyword_marker](./keyword_marker.md)
