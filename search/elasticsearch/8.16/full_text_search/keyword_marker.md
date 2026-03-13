
# 1️⃣ What `keyword_marker` does
```elixir
"keyword_marker" => %{
  "type" => "keyword_marker",
  "keywords" => ["generator"]
}
```

* This is an **analysis filter** that **protects certain tokens from stemming** or other filters that would normally modify them.
* Tokens listed in `"keywords"` are treated as **“keywords”**, meaning they will **not be changed** by filters like `porter_stem` or `snowball`.
* It’s useful for technical terms, model names, or brand/product-specific words that should remain **exact**.

---

# 2️⃣ Example

Suppose you have a document:

```
portable generator
```

* Normal stemming (`porter_stem`) might convert:

  * `"generator"` → `"gener"`

* With `keyword_marker` applied to `"generator"`:

  * `"generator"` stays as `"generator"`
  * `"portable"` → `"port"` (still stemmed)

* Token stream after analysis:

```
["port", "generator"]
```

---

# 3️⃣ Why it’s important

* Prevents **over-stemming** of product-critical words like:

  * `"generator"`
  * `"Makita"` (brand names)

* Helps **exact-match boosting** in BM25 queries.

---

# 4️⃣ How it fits in analyzer

Example from `en_default_analyzer`:

```elixir
"en_default_analyzer" => %{
  "type" => "custom",
  "char_filter" => ["html_strip"],
  "tokenizer" => "en_tokenizer",
  "filter" => [
    "lowercase",
    "search_synonym",
    "keyword_marker",
    "porter_stem"
  ]
}
```

* Step by step:

  1. Strip HTML
  2. Standard tokenization
  3. Lowercase + synonyms
  4. **keyword_marker** → protect `"generator"`
  5. Porter stem → only stems unprotected tokens

---

✅ **Key Takeaway:**

Use `keyword_marker` for any **critical product words or identifiers** that **should not be stemmed or altered** during analysis. This ensures queries containing those words match **exactly** and boosts scoring accuracy.
