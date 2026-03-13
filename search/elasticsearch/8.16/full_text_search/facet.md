# ⭐ **What is Faceted Search (with Elasticsearch)?**

**Faceted search** is a search technique where results can be filtered and narrowed down using **facets** — metadata categories such as *brand*, *price range*, *color*, *category*, etc.

It creates an interactive search experience similar to Amazon, eBay, or Airbnb where users refine results by clicking filters.

---

# ⭐ **How Elasticsearch Implements Faceted Search**

Elasticsearch provides faceted search through **aggregations**, not the old “facets API” (removed after ES 1.x).

## 🔹 You use **aggregations** to:

* Count documents by attribute
* Build filter buckets
* Return facets along with your search results

This allows the frontend to show filter counts like:

* Brand

  * Nike (120)
  * Adidas (95)
  * Puma (44)

* Color

  * Black (200)
  * White (150)
  * Blue (100)

* Price

  * $0–50 (80)
  * $50–100 (60)
  * $100–200 (20)

---

# ⭐ Example Elasticsearch Faceted Search Query

```json
{
  "query": {
    "bool": {
      "must": [
        { "match": { "name": "running shoes" } }
      ],
      "filter": [
        { "term": { "category": "shoes" } }
      ]
    }
  },
  "aggs": {
    "brand_facet": {
      "terms": { "field": "brand.keyword", "size": 20 }
    },
    "color_facet": {
      "terms": { "field": "color.keyword", "size": 20 }
    },
    "price_range_facet": {
      "range": {
        "field": "price",
        "ranges": [
          { "key": "low", "to": 50 },
          { "key": "mid", "from": 50, "to": 100 },
          { "key": "high", "from": 100 }
        ]
      }
    }
  }
}
```

---

# ⭐ What the Query Does

### **Search results**

* Finds "running shoes" in the `name` field
* Filters the category to `shoes`

### **Facets returned**

* **brand_facet** → counts for each brand
* **color_facet** → counts for each color
* **price_range_facet** → bucketed price ranges

Your UI uses these to build sidebar filters.

---

# ⭐ Why Faceted Search is Useful

* Fast filtering of large datasets
* Great UX for ecommerce / real estate / job search
* Provides real-time counts
* Supports hierarchical facets (e.g., category trees)
