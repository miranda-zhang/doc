# `text` type

* **Purpose:** Designed for **full-text search**.
* **Analysis:** Text fields are **analyzed**, meaning Elasticsearch will:

  * Break the text into tokens (words) using an **analyzer**.
  * Lowercase words, remove punctuation, and optionally apply stemming.
* **Use case:** Searching inside large bodies of text, like product names, descriptions, or blog posts.
* **Example:**

  ```json
  {
    "name": {
      "type": "text",
      "analyzer": "en_default_analyzer"
    }
  }
  ```

  * `"Samsung Galaxy S21"` → tokens: `["samsung", "galaxy", "s21"]`
  * You can search for `"Galaxy"` and it will match the document.

---

# `keyword` type

* **Purpose:** Designed for **exact matches, sorting, and aggregations**.
* **No analysis:** The field is **not broken into tokens**; it is stored as-is.
* **Use case:** IDs, codes, tags, or fields where you want exact matches or faceted search.
* **Example:**

  ```json
  {
    "sku": { "type": "keyword" }
  }
  ```

  * `"ABC123"` must be queried exactly as `"ABC123"` to match.
  * Useful for filters like `term`, `terms`, or aggregations.

---

# **Key differences in behavior**

| Feature               | text                 | keyword |
| --------------------- | -------------------- | ------- |
| Tokenized / Analyzed  | Yes                  | No      |
| Full-text search      | ✅                    | ❌       |
| Exact match / filter  | ❌                    | ✅       |
| Sorting / aggregation | ❌ (needs `.keyword`) | ✅       |
| Example query         | `match`              | `term`  |
