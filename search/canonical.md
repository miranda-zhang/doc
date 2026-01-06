# What are **duplicate content penalties** in search engines?

Search engines (Google, Bing) **do not like multiple URLs showing the same content**.

## Example of duplicate content

All of these show the same products:

```
/search?q=heat+jackets
/search?q=jackets+heated
/category/cordless-tools/jackets
```

From Google’s perspective:

* Which one should rank?
* Which one is “the real page”?

## What happens if you don’t fix it?

Search engines may:

* Split ranking signals across URLs
* Index the “wrong” page
* Lower visibility of all of them
* Ignore some pages entirely

This is often called a **“duplicate content penalty”** (not a literal fine, but ranking loss).

---

# What does `<link rel="canonical">` do?

This HTML tag tells search engines:

> “This page is a duplicate — **this is the one you should treat as the original**.”

## Example

If the user visits:

```
/search?q=heat+jackets
```

Your HTML might include:

```html
<link rel="canonical" href="https://example.com/category/cordless-tools/jackets">
```

## What search engines do with it

* Index **only** the canonical URL
* Consolidate SEO value (links, ranking)
* Avoid duplicate content issues

# Big-picture summary

| Concept                         | Purpose                                |
| ------------------------------- | -------------------------------------- |
| **Cache**                   | Fast, in-memory canonical cache avoid hitting DB everytime|
| **Canonical URLs**              | Define the “official” page             |
| **Duplicate content penalties** | SEO ranking loss from duplicates       |
| `<link rel="canonical">`        | Tell search engines which URL to index |

