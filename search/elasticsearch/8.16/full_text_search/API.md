
# **Checks you can do**
```sh
curl -X GET "localhost:9200/_cat/indices?v"
```
1. **Inspect documents in an index** (e.g., your main index):

```bash
curl -X GET "localhost:9200/index-name/_search?pretty&size=5"
```

* Returns the first 5 documents.

2. **Check mappings** (field types):

```bash
curl -X GET "localhost:9200/index-name/_mapping?pretty"
```

3. **Check index settings**:

```bash
curl -X GET "localhost:9200/index-name/_settings?pretty"
```

4. **If your app is using suggestions**:

* It probably writes to `suggestion-index-*`.
* You can check one of these with the same `_search` query.

# Suggestion
Test suggestion with an example query "milw"
```sh
curl -X POST "localhost:9200/suggestion-index-name/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "_source": ["suggest"], 
  "query": {
    "multi_match": {
      "query": "milw",
      "type": "bool_prefix",
      "fields": [
        "suggest",
        "suggest._2gram",
        "suggest._3gram"
      ]
    }
  }
}'
```
# Script
```sh
# deleting all non internal indexes that has a doc count less than 7262
for index in $(curl -s -X GET "localhost:9200/_cat/indices?h=index,docs.count" | awk '$2<7262 {print $1}'); do
  # Skip internal indices
  if [[ $index == .* ]]; then
    # echo "Skipping internal index $index"
    continue
  fi

  echo "Deleting $index..."
  # Uncomment the next line to actually delete
  curl -X DELETE "localhost:9200/$index"
  echo ""
done
```