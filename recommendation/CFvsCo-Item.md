# Collaborative Filtering (CF)

**Definition:**
Collaborative filtering predicts what a user might like based on **past behavior of many users**, without requiring item metadata. It assumes that similar users like similar items.

**Types:**

1. **User-based CF** – Find users similar to the target user and recommend items they liked.
2. **Item-based CF** – Find items similar to the items the user liked, and recommend them.

**Example:**

* User A likes movies X, Y, Z.
* User B likes X, Y.
* Predict that User B might like Z because similar users liked it.

**Pros:**

* Doesn’t need item metadata.
* Captures complex patterns in user behavior.

**Cons:**

* Cold start problem (new users or items).
* Sparse data can hurt performance.

# Co-Item (Co-Occurrence) / Item Co-Occurrence

**Definition:**
Co-item recommendation is based on **items that appear together** in user interactions (often a simpler form of item-based CF). It doesn’t explicitly measure “similarity” using vectors—it just counts co-occurrences.

**Example:**

* Many users who bought item A also bought item B.
* Recommend B to a user who bought A.

**Pros:**

* Very simple and scalable.
* Works well with large datasets where exact similarity computation is expensive.

**Cons:**

* Doesn’t consider user similarity.
* Can miss [nuanced patterns](NuancedPatterns.md); only captures frequent co-occurrences.

---

# **Key Differences**

| Feature             | Collaborative Filtering                 | Co-Item / Co-Occurrence              |
| ------------------- | --------------------------------------- | ------------------------------------ |
| Based on            | User behavior patterns (similarity)     | Item co-occurrence counts            |
| Focus               | Users & items                           | Items only                           |
| Complexity          | Medium to high (similarity computation) | Low (just count co-occurrences)      |
| Cold start problem  | Yes (new users/items)                   | Yes (new items, rare co-occurrences) |
| Recommendation type | Personalized                            | Often item-to-item                   |
| Example in practice | Netflix user-based recommendations      | Amazon “frequently bought together”  |
