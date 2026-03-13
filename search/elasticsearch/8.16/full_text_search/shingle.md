# 1️⃣ What a shingle is

A **shingle** is basically a **sequence of consecutive tokens** (n-gram of words).

* Instead of splitting a sentence into individual words, shingles combine **2, 3, or more consecutive words** into a token.
* Useful for **phrase matching** and **partial phrase search**.

Example:

Input text:

```
refrigerated air compressor
```

* Standard tokenizer → tokens:

```
["refrigerated", "air", "compressor"]
```

* Shingle filter with `min_shingle_size: 2, max_shingle_size: 3` → tokens:

```
["refrigerated air", "air compressor", "refrigerated air compressor"]
```

Now, **phrase queries** can match shingles even if the user types a subset of the phrase.

---

# 2️⃣ Elasticsearch Shingle Filter Example

Mapping already has this filter:

```elixir
"shingle_filter" => %{
  "type" => "shingle",
  "min_shingle_size" => 2,
  "max_shingle_size" => 3,
  "output_unigrams" => false,
  "output_unigrams_if_no_shingles" => true
}
```

* `min_shingle_size = 2` → start with 2-word shingles
* `max_shingle_size = 3` → up to 3-word shingles
* `output_unigrams = false` → don’t include single words unless `output_unigrams_if_no_shingles` is true

This is applied in analyzer:

```elixir
"en_shingle_analyzer" => %{
  "type" => "custom",
  "tokenizer" => "standard",
  "filter" => ["lowercase", "search_synonym", "keyword_marker", "shingle_filter"]
}
```

So any text analyzed with `en_shingle_analyzer` will automatically produce multi-word shingles.

---

# 3️⃣ Benefits

* Queries like `"refrigerated air compressor"` will match:

  * `"refrigerated air compressor"` (exact phrase)
  * `"air compressor"` (partial phrase)
  * `"refrigerated air"` (partial phrase)

* Improves ranking for **long multi-word queries** in descriptive fields (`name`, `category`, `subcategory`).
---

# Use cases

1. **Shingles + edge n-grams** → support partial phrases AND partial words (autocomplete for phrases).
2. **Shingles + synonyms** → `"cold gal"` → `"cold galvanizing"` will also generate multi-word shingles for ranking.
3. **Shingles for concatenated words** → use with `concat_filter` to catch `"aircompressor"` → `"air compressor"`.

---

**How a phrase query flows through the analyzers and filters**:

* tokenization → char filters → shingles → synonyms → edge n-grams → final tokens for BM25 + embedding scoring
