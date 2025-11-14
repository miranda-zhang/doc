# Relay
Offitial docs:
- [Relay with GraphQL](https://relay.dev/docs/tutorial/graphql/)
- [Relay official doc cached](./GraphQLRelay.pdf)
- [Absinthe.Relay](https://hexdocs.pm/absinthe/relay.html)
## 🧩 The big picture

| Term               | What it is                                                                                                        | Where it comes from               |
| ------------------ | ----------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| **Relay**          | A *concept and specification* for how a GraphQL client (like Facebook’s Relay JS) interacts with a GraphQL server | Developed by **Meta (Facebook)**  |
| **Absinthe.Relay** | An *Elixir library* that implements the Relay spec for GraphQL APIs built with **Absinthe**                       | Developed by the Elixir community |


➡️ **Relay** defines how a GraphQL server *should* behave.
➡️ **Absinthe.Relay** is Elixir’s **implementation** of those rules.

---

### 📘 1. What Relay (concept) is

Relay is **a GraphQL client framework** made by Facebook.
It defines a **standardized GraphQL schema structure** that helps the client efficiently:

* paginate large lists (`connections`)
* refer to objects globally (`nodes`)
* manage consistent cache and updates

So Relay isn’t just a library — it’s a **set of conventions** for GraphQL schemas.

Example of Relay-style schema features:

```graphql
{
  node(id: "user:123") {
    id
    ... on User {
      name
    }
  }
}

{
  users(first: 10, after: "cursor123") {
    edges {
      node { id name }
      cursor
    }
    pageInfo {
      hasNextPage
    }
  }
}
```

That’s **Relay spec** in action — things like `node`, `edges`, and `pageInfo` are part of its standardized structure.

---

### 🧰 2. What Absinthe.Relay (implementation) does

[`Absinthe.Relay`](https://hexdocs.pm/absinthe_relay/) extends **Absinthe** (Elixir’s GraphQL library) with macros and helpers that automatically make your schema **Relay-compliant**.

It provides:

* `node interface` — for globally unique object IDs
* `connection` — for cursor-based pagination
* `mutation` macros — for Relay-style mutation input/output wrappers

Example (Elixir):

```elixir
defmodule MyAppWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  node interface do
    resolve_type fn
      %MyApp.Accounts.User{}, _ -> :user
      _, _ -> nil
    end
  end

  node object(:user) do
    field :name, :string
  end

  connection node_type: :user
end
```

Absinthe.Relay then **auto-generates** the proper GraphQL fields for pagination and node resolution.

---

### 🔄 3. How they fit together

| Layer                       | Example                                        | Purpose                                         |
| --------------------------- | ---------------------------------------------- | ----------------------------------------------- |
| **Relay Spec (concept)**    | defines `node`, `connection`, `pageInfo`, etc. | Schema conventions for Relay clients            |
| **Relay JS (client)**       | `relay-runtime`                                | JavaScript client that uses the spec            |
| **Absinthe.Relay (server)** | Elixir library built on `Absinthe`             | Implements those conventions in GraphQL schemas |

---

### ✅ In short

* **Relay** → The **idea/spec** (GraphQL schema conventions)
* **Absinthe.Relay** → The **Elixir server implementation** of those ideas
* **Relay JS** → The **client** that consumes them

---

# 🧩 What are `node`, `edges`, and `pageInfo`?

These are **Relay conventions** that make GraphQL APIs handle:

* **Global IDs** (via `node`)
* **Cursor-based pagination** (via `edges` and `pageInfo`)

They come from the **Relay specification**, but Absinthe.Relay (and other GraphQL servers) implement them.

---

## 🧠 1. `node` — globally unique object access

### Concept

Every object in a Relay-compliant API must have a **global ID**, so the client can refetch it no matter its type or where it appears in the graph.

Think of `node` as a **universal lookup mechanism**.

### Example query

```graphql
{
  node(id: "VXNlcjox") {
    id
    ... on User {
      name
    }
  }
}
```

### Example response

```json
{
  "data": {
    "node": {
      "id": "VXNlcjox",
      "name": "Alice"
    }
  }
}
```

Here, `"VXNlcjox"` is a **base64-encoded global ID** — in this case, it decodes to `"User:1"`.

### In Absinthe.Relay (Elixir)

You define a **node interface** and tell Absinthe how to resolve by ID:

```elixir
node interface do
  resolve_type fn
    %MyApp.Accounts.User{}, _ -> :user
    _, _ -> nil
  end
end

node object(:user) do
  field :name, :string
end
```

Absinthe will automatically add a `node(id: ID!)` field to your schema.


#### 🧩 Context

Relay (the GraphQL spec) requires that **every object that can be fetched individually** implements a **`Node` interface** with a **globally unique ID**.

In Absinthe, this is done using:

* `node interface do ... end` → defines *what a Node is* and how to resolve it.
* `node object(:user) do ... end` → defines a specific *type* (`User`) that implements that interface.

---

#### 🧠 Step-by-step explanation

##### 1. `node interface do ... end`

This defines the **global Node interface**.
Think of it like:

> “All objects that can be fetched by a global ID must follow this interface.”

🔍 What it does:

* **`node interface`** — creates a standard interface with an `id: ID!` field automatically.
* **`resolve_type fn ... end`** — tells Absinthe **how to determine the GraphQL type** of a given struct when resolving a node by its global ID.

So when a client does this:

```graphql
{
  node(id: "VXNlcjox") {
    id
    ... on User {
      name
    }
  }
}
```

Absinthe will:

1. Decode the global ID `"VXNlcjox"` → `"User:1"`.
2. Fetch the `%MyApp.Accounts.User{}` struct from your database.
3. Pass it into the `resolve_type` function.

Then this part runs:

```elixir
%MyApp.Accounts.User{}, _ -> :user
```

and Absinthe knows:

> “Ah, this node is of GraphQL type `:user`.”

That’s how the `node` field can dynamically return **different types** depending on what’s fetched.

---

##### 2. `node object(:user) do ... end`

Now you’re defining **a specific type** (`User`) that implements that Node interface.

```elixir
node object(:user) do
  field :name, :string
end
```

🔍 What this does:

* **`node object(:user)`** means:
  “Define a `User` GraphQL type that automatically includes an `id` field and implements the Node interface.”

* Inside the block, you define the rest of your fields:

  ```elixir
  field :name, :string
  ```

So the resulting GraphQL type looks like this:

```graphql
type User implements Node {
  id: ID!
  name: String
}
```

##### Summary

| Code                            | Purpose                                                                                              |
| ------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `node interface do ... end`     | Defines the global Node interface and tells Absinthe how to resolve any struct’s GraphQL type        |
| `resolve_type fn ... end`       | Determines which GraphQL type corresponds to which Elixir struct                                     |
| `node object(:user) do ... end` | Defines a GraphQL object type that implements the Node interface and automatically has a global `id` |
| `field :name, :string`          | Defines normal fields on the type                                                                    |



### 🧩 More code explaination
 
```elixir
resolve_type fn
  %MyApp.Accounts.User{}, _ -> :user
  _, _ -> nil
end
```

---

#### 🧠 1. What `resolve_type` is

In Absinthe (and Relay), when a client queries something like:

```graphql
{
  node(id: "VXNlcjox") {
    id
    ... on User {
      name
    }
  }
}
```

the server must figure out **what type** that node actually is — in this case, `User`.

That’s what the **`resolve_type` function** does.

Absinthe calls this function **after** it’s fetched a record (like `%MyApp.Accounts.User{}`) and needs to map it to a GraphQL type (like `:user`).

---

#### 🧩 2. Pattern matching explained

Elixir lets you use **pattern matching** directly in anonymous functions (`fn ... end`).

This code defines **two match clauses**:

##### Clause 1:

```elixir
%MyApp.Accounts.User{}, _ -> :user
```

* **`%MyApp.Accounts.User{}`**
  → This pattern matches **any struct of that type**, regardless of its contents.
  (So `%MyApp.Accounts.User{id: 1, name: "Alice"}` will match.)

* **`_`**
  → This is the **second argument** passed to `resolve_type` (usually the Absinthe context), but we’re not using it, so `_` just means “ignore it.”

* **`-> :user`**
  → This tells Absinthe: “If you see a `%MyApp.Accounts.User{}`, the GraphQL type is `:user`.”

---

##### Clause 2:

```elixir
_, _ -> nil
```

This is the **fallback clause** — it matches anything else.

* The two `_` patterns mean “we don’t care what the arguments are.”
* It returns `nil`, which means “Absinthe couldn’t determine a type.”

So, if Absinthe passes a struct that isn’t a `User`, or some unexpected data, this line safely returns `nil`.

---

#### 🧩 3. How it’s used in practice

Let’s imagine your app has multiple node types:

```elixir
%MyApp.Accounts.User{}     → :user
%MyApp.Blog.Post{}         → :post
%MyApp.Shop.Product{}      → :product
```

You can extend `resolve_type` easily:

```elixir
resolve_type fn
  %MyApp.Accounts.User{}, _ -> :user
  %MyApp.Blog.Post{}, _ -> :post
  %MyApp.Shop.Product{}, _ -> :product
  _, _ -> nil
end
```

That way, when a query asks for a `node(id: "VXNlcjox")`, Absinthe:

1. Fetches the Elixir struct (`%MyApp.Accounts.User{id: 1}`)
2. Runs this `resolve_type` function
3. Matches it to the clause `%MyApp.Accounts.User{}, _ -> :user`
4. Returns the corresponding GraphQL type `:user`

---

#### 💡 Analogy

Think of it like a type classifier:

```elixir
if value is a %User{} struct → return :user
else → return nil
```

Absinthe uses that information to know **which GraphQL object type** to use when returning the node.

---

## 🧱 2. `edges` — connection items (with metadata)

When you return a list in a Relay-compliant API, you don’t just return an array.
You return a **connection** — an object that includes **edges**, each containing a **node** and a **cursor**.

This enables **cursor-based pagination** (instead of offset-based).

### Example query

```graphql
{
  users(first: 2, after: "cursor123") {
    edges {
      node {
        id
        name
      }
      cursor
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

### Example response

```json
{
  "data": {
    "users": {
      "edges": [
        {
          "node": { "id": "VXNlcjox", "name": "Alice" },
          "cursor": "cursor1"
        },
        {
          "node": { "id": "VXNlcjoy", "name": "Bob" },
          "cursor": "cursor2"
        }
      ],
      "pageInfo": {
        "hasNextPage": true,
        "endCursor": "cursor2"
      }
    }
  }
}
```

So:

* Each **edge** wraps a single item (`node`) plus a **cursor** that marks its position.
* This cursor lets Relay load the **next page** efficiently.

---

## 🧭 3. `pageInfo` — pagination state

`pageInfo` describes whether there’s **more data available** before or after the current page.

Typical fields include:

| Field             | Type    | Description                           |
| ----------------- | ------- | ------------------------------------- |
| `hasNextPage`     | Boolean | Is there another page after this one? |
| `hasPreviousPage` | Boolean | Is there a page before this one?      |
| `startCursor`     | String  | Cursor of the first edge in this page |
| `endCursor`       | String  | Cursor of the last edge in this page  |

### Example

```json
"pageInfo": {
  "hasNextPage": true,
  "hasPreviousPage": false,
  "startCursor": "cursor1",
  "endCursor": "cursor2"
}
```

---

## 🧰 Putting it all together

Visually, it looks like this:

```
Connection
│
├── edges (list)
│     ├── edge
│     │     ├── node (your actual data)
│     │     └── cursor (for pagination)
│     ├── edge
│     │     ├── node
│     │     └── cursor
│     ...
└── pageInfo (pagination metadata)
```

---

## 🧪 Example in Absinthe.Relay (Elixir)

```elixir
connection node_type: :user do
  field :total_count, :integer
end
```

Absinthe automatically generates:

* a `users` field returning a connection object
* `edges` (each with `node` and `cursor`)
* `pageInfo` (with pagination state)

---

✅ **Summary**

| Concept        | Purpose                                        | Example                          |
| -------------- | ---------------------------------------------- | -------------------------------- |
| **`node`**     | Universal way to fetch any object by global ID | `node(id: "VXNlcjox")`           |
| **`edges`**    | Wrap each item in a connection with its cursor | `edges { node { name } cursor }` |
| **`pageInfo`** | Describes pagination state                     | `hasNextPage`, `endCursor`       |

---
Perfect question — you’re digging into **how Absinthe’s macros like `query`, `mutation`, `subscription`, and `field` actually work**.

Let’s unpack this carefully, because understanding these is *key* to writing GraphQL schemas in Elixir.

---

# ⚙️ What Are Absinthe Macros?

When you write:

```elixir
use Absinthe.Schema
```

it **imports macros** that let you declare your GraphQL structure declaratively — almost like a DSL (domain-specific language).

They’re not “regular Elixir functions” — they **generate schema metadata at compile time**.
So Absinthe builds a full GraphQL schema tree from your module when your app compiles.

---

## 🧩 The Core Macros

### 1. `query do ... end`

Defines the **root query type** (entry point for read operations).

Everything under it becomes part of the `Query` object type in GraphQL.

**Example:**

```elixir
query do
  field :hello, :string
  field :users, list_of(:user)
end
```

Equivalent GraphQL schema:

```graphql
type Query {
  hello: String
  users: [User]
}
```

You can think of it like the top-level `GET` endpoints in a REST API — it’s where data fetching begins.

---

### 2. `mutation do ... end`

Defines **write operations** — things that *change* data (create, update, delete).

**Example:**

```elixir
mutation do
  field :create_user, type: :user do
    arg :name, non_null(:string)
    resolve &Resolvers.User.create/3
  end
end
```

Equivalent GraphQL:

```graphql
type Mutation {
  createUser(name: String!): User
}
```

You can have multiple fields here (`updateUser`, `deleteUser`, etc.).
Resolvers typically perform database writes using Ecto.

---

### 3. `subscription do ... end`

Defines **real-time data streams** — clients can subscribe and get pushed updates.
This is more advanced and usually uses Phoenix PubSub under the hood.

**Example:**

```elixir
subscription do
  field :user_created, :user do
    config(fn _, _ -> {:ok, topic: "*"} end)
  end
end
```

Then clients can do:

```graphql
subscription {
  userCreated {
    id
    name
  }
}
```

---

### 4. `field name, type do ... end`

Defines a **field** inside a query, mutation, subscription, or object type.

Each field represents a single property or resolver in the GraphQL API.

**Example:**

```elixir
field :user, :user do
  arg :id, non_null(:id)
  resolve &Resolvers.User.get/3
end
```

Means:

* Field name: `user`
* Return type: `User`
* Takes one argument (`id`)
* Resolver function: `Resolvers.User.get/3`

---

### 5. (Bonus) Type definition macros

You can also define custom types (besides root-level query/mutation/subscription).

#### `object/2`

Defines a GraphQL object type.

```elixir
object :user do
  field :id, :id
  field :name, :string
end
```

GraphQL equivalent:

```graphql
type User {
  id: ID
  name: String
}
```

#### `input_object/2`

For defining structured inputs to mutations:

```elixir
input_object :create_user_input do
  field :name, non_null(:string)
end
```

#### `enum/2`

For fixed sets of values:

```elixir
enum :role do
  value :admin
  value :user
end
```

---

## 🧠 Summary Table

| Macro             | Purpose                   | GraphQL Equivalent          |
| ----------------- | ------------------------- | --------------------------- |
| `query do`        | Read operations           | `type Query { ... }`        |
| `mutation do`     | Write operations          | `type Mutation { ... }`     |
| `subscription do` | Real-time streams         | `type Subscription { ... }` |
| `field`           | A single field definition | `fieldName: Type`           |
| `object`          | Defines a GraphQL type    | `type MyType { ... }`       |
| `input_object`    | Defines an input type     | `input MyInput { ... }`     |
| `enum`            | Enumerated constants      | `enum MyEnum { ... }`       |

---

## 🧬 How It Works Internally

When your schema compiles:

* Absinthe runs macros like `query`, `object`, `field` to build a metadata tree.
* This tree is stored in module attributes.
* At compile time, Absinthe generates a schema struct (a big Elixir map).
* When a request hits `/api/graphql`, Absinthe:

  * Parses the query string.
  * Matches fields against your schema struct.
  * Calls your resolvers dynamically.

So `query do ... end` isn’t just syntax sugar — it’s a schema builder.

---
