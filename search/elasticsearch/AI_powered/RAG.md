# RAG (Retrieval-Augmented Generation)

* **Purpose:** Generate answers grounded in retrieved documents.
* **How it works:**

  1. Query → embedding → retrieve relevant documents (just like semantic search).
  2. Feed the retrieved documents **plus the query** into a language model.
  3. The language model **generates a coherent answer** that cites or is based on the retrieved content.
* **Output:** A generated answer or explanation, not just a list of documents.
* **Example:**
  You ask: “Best ways to prune apple trees.”
  RAG might return:

  > “To prune apple trees, remove dead branches in late winter, thin crowded areas to allow light in, and cut back overly long branches to encourage fruit growth. Sources: [Doc1], [Doc2].”

✅ RAG = **semantic search + generation**. It’s a combination of retrieval and text generation.
