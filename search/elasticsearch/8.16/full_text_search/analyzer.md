# What an Analyzer Does
https://www.elastic.co/guide/en/elasticsearch/reference/8.16/analyzer.html

An **analyzer** in Elasticsearch is a combination of:

1. **Character filters** – modify the text before tokenizing (like removing HTML tags)
2. **Tokenizer** – splits text into terms/tokens (usually by whitespace, punctuation, etc.)
3. **Token filters** – modify tokens (lowercasing, stemming, removing stop words, etc.)

The choice of analyzer determines **how Elasticsearch interprets your text for indexing and searching**.

---

# `standard` Analyzer

* **Default analyzer** in Elasticsearch.
* Tokenizes text based on **Unicode word boundaries**.
* Lowercases tokens.
* **No language-specific processing** (no stemming or stop word removal for a specific language).
* Example:

```json
PUT /test_standard
{
  "mappings": {
    "properties": {
      "content": {
        "type": "text",
        "analyzer": "standard"
      }
    }
  }
}
```

**Behavior:**

Text: `"The quick brown foxes jumped over the lazy dogs."`

Tokens:

```
["the", "quick", "brown", "foxes", "jumped", "over", "the", "lazy", "dogs"]
```

✅ Good for general-purpose text.
❌ No stemming → `"jump"` and `"jumped"` are different tokens.

---

# `english` Analyzer

* Built-in **language-specific analyzer**.
* Includes:

  * Lowercasing
  * Stop word removal (e.g., "the", "and", "is")
  * **Stemming** (reduces words to their root: `"jumped" → "jump"`, `"running" → "run"`)
* Uses the **English stop word list** by default.
* Example:

```json
PUT /test_english
{
  "mappings": {
    "properties": {
      "content": {
        "type": "text",
        "analyzer": "english"
      }
    }
  }
}
```

**Behavior:**

Text: `"The quick brown foxes jumped over the lazy dogs."`

Tokens:

```
["quick", "brown", "fox", "jump", "lazi", "dog"]
```

Notice:

* `"the"` is removed (stop word)
* `"foxes" → "fox"` (stemming)
* `"lazy" → "lazi"` (stemming may create root forms that are slightly altered)

✅ Great for **English-language full-text search**.
❌ Not good if you need **exact token matches** (like tags or codes).

---

# When to Use Which

| Analyzer   | Use Case                                                                        |
| ---------- | ------------------------------------------------------------------------------- |
| `standard` | General-purpose text, multi-language content, exact word matching               |
| `english`  | English full-text search where stemming and stop words improve search relevance |

**Example:**

* Search for `"jump"`:

  * `standard` → will **not match** `"jumped"`
  * `english` → **will match** `"jumped"` because of stemming

---

💡 **Tip:** If you have a field that needs **both exact and full-text search**, you can use **multi-fields**:

```json
"description": {
  "type": "text",
  "analyzer": "english",
  "fields": {
    "raw": { "type": "keyword" }
  }
}
```

* `description` → full-text search with stemming
* `description.raw` → exact matches or aggregations
