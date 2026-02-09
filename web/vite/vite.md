# What Is **Vite**?
- [Vite official site](https://vite.dev/guide/)
**Vite** is a **build tool + development server**.

### How Vite works:

* In **development**:

  * Serves source files directly using **native ESM**.
  * Transforms code (e.g. TypeScript, JSX, Vue SFCs) **on the fly**.
  * Instant updates with **Hot Module Replacement (HMR)**.
* In **production**:

  * Bundles your code using **Rollup** into optimized chunks for deployment.

### Example:

```bash
npm create vite@latest my-app
cd my-app
npm run dev
```

Vite will:

* Serve your app instantly via ESM.
* Handle imports like `import React from 'react'` by pre-bundling dependencies.
* Optimize output for production with tree-shaking, minification, etc.

---

## 🔍 Comparison Summary

| Feature              | **ES Modules (ESM)**                       | **Vite**                                  |
| -------------------- | ------------------------------------------ | ----------------------------------------- |
| **What it is**       | JavaScript language standard               | Development + build tool                  |
| **Who runs it**      | Browser or Node.js                         | Developer (CLI tool)                      |
| **Purpose**          | Define how to structure JS imports/exports | Speed up dev server & build process       |
| **Build step?**      | None required                              | Yes (for production)                      |
| **Performance**      | Slow in large projects (many files)        | Fast via dependency pre-bundling + Rollup |
| **HMR (Hot Reload)** | Not built-in                               | Yes                                       |
| **Transpilation**    | No                                         | Yes (TypeScript, JSX, etc.)               |
| **Plugins**          | No                                         | Yes (Rollup ecosystem)                    |

---

## 🧠 Analogy

* **ES Modules** = the *grammar* for how JavaScript files talk to each other.
* **Vite** = a *tool* that speaks that grammar fluently, but adds speed, optimization, and a great developer experience.


# 🌳 What Is Tree-Shaking?

**Tree-shaking** is the process of **removing unused (“dead”) code** from your JavaScript bundle.

The name comes from the idea of *“shaking a tree so that dead leaves fall off”* — meaning:

> You keep only the parts of your code (and your dependencies) that are actually used (imported and referenced).

---

## 🧩 Example

### Source code:

```js
// utils.js
export function add(a, b) {
  return a + b;
}

export function subtract(a, b) {
  return a - b;
}

// main.js
import { add } from './utils.js';

console.log(add(2, 3));
```

### What happens during tree-shaking:

* The bundler (like **Vite/Rollup/Webpack**) analyzes that `subtract` is **never imported**.
* It removes it from the final bundle.

✅ **Resulting bundle:**

```js
function add(a, b) {
  return a + b;
}
console.log(add(2, 3));
```

---

## ⚙️ How It Works (Under the Hood)

Tree-shaking relies on **static analysis** of your imports and exports.

* ES Modules (ESM) are **static** — meaning imports/exports can be determined at build time.

  ```js
  import { something } from './file.js';
  ```

  The bundler knows exactly what’s being imported — no dynamic behavior.

* In contrast, **CommonJS** (`require`) is dynamic, making it harder to tree-shake reliably:

  ```js
  const module = require(someVar); // cannot be statically analyzed
  ```

## ⚠️ Caveats

Tree-shaking doesn’t always work if:

* Code has **side effects** (e.g. modifies globals, logs, runs immediately).
* You’re using **CommonJS (`require`)** modules.
* The library doesn’t mark `"sideEffects": false` in its `package.json`.
* Dynamic imports or exports confuse the static analyzer.

Example:

```js
// not tree-shakeable
import * as utils from './utils.js';
console.log(utils[Math.random() > 0.5 ? 'add' : 'subtract'](1, 2));
```
