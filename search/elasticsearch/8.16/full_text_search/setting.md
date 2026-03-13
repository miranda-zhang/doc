# Setting
## Shards & Replicas

```json
"number_of_shards" : "1",
"number_of_replicas" : "0",
```

* **1 primary shard** → all documents are stored in a single shard.
* **0 replicas** → no copies for failover (single-node setup).
* Simple setup, fine for small datasets or dev/testing.

## Analysis

The `analysis` section shows **custom analyzers, tokenizers, and filters**. This defines **how text is indexed and searched**.

### Tokenizers

```elixir
"en_tokenizer" => %{"type" => "standard"}
"en_ngram_tokenizer" => %{"type" => "edge_ngram", "min_gram" => 3, "max_gram" => 10, "token_chars" => ["letter","digit"]}
```

* `standard`: splits words on whitespace/punctuation — good for general text.
* `edge_ngram`: generates partial matches (for autocomplete or fuzzy start-of-word matches).
* **Effect:** `"aircompressor"` → `"air"`, `"airc"`, `"airco"`, … `"aircompressor"`

### Filters

* `en_word_delimiter` → splits camel-case and numbers + letters
* `en_ngram_filter` → edge n-grams for partial matching
* `shingle_filter` → creates multi-word [shingles](./shingle.md) for better phrase matching
* `concat_filter` → removes spaces to allow concatenation matches
* `search_synonym` → handles synonyms 
* [`keyword_marker`](keyword_marker.md)

#### Synonyms

```json
"search_synonym" : {
  "type" : "synonym",
  "synonyms" : ["hikoki,hitachi", "suction,sucker", ...]
}
```

* Maps multiple terms to the same meaning.
* Example: searching for `"hikoki"` also finds `"hitachi"`.

#### Edge n-grams

```json
"en_ngram_filter" : { "type": "edge_ngram", "min_gram": 3, "max_gram": 10 }
```

* Supports **autocomplete / prefix searches**.
* Example: typing `"milw"` matches `"milwaukee"`.

#### Stop words

```json
"en_stop_words" : { "type": "stop", "stopwords": "_english_" }
```

* Common words like `"the"`, `"and"` are ignored.

#### Char filters

* Preprocess text before tokenization.
* Examples: normalize `"12.0Ah"` → `"12Ah"`, handle codes, remove HTML tags.

#### Custom analyzers

* Multiple analyzers for different use cases:

  * `en_default_analyzer` → normal search
  * `keyword_analyzer` → exact match on keywords
  * `en_ngram_analyzer_front` → autocomplete
  * `en_concat_analyzer` → combine multi-word tokens

## **3. Routing / Allocation**

```json
"_tier_preference" : "data_content"
```

* Ensures the index is allocated to **data nodes intended for content storage**.
* Important in multi-tier Elasticsearch setups.

---

## **4. Max result window**

```json
"max_result_window" : "99999"
```

* Allows fetching up to 99,999 results in one search request.
* Useful if your app does deep scrolling or large exports.
