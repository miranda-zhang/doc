# Ecto
- [Ecto official doc](https://hexdocs.pm/ecto/getting-started.html)

**Ecto** is Elixir’s main **database wrapper and query generator**, kind of like **ActiveRecord (Ruby on Rails)** or **SQLAlchemy (Python)**, but designed to fit Elixir’s functional style.

Let’s unpack what that means and give examples 👇

---

### 🧩 What Ecto does

Ecto is made up of **four main parts**:

1. **Ecto.Repo** — the interface to your database

   * Handles connecting, reading, writing, and transactions.
   * Think of it as your *database client*.

2. **Ecto.Schema** — maps Elixir structs to database tables

   * Defines how your Elixir data maps to rows in a database.

3. **Ecto.Changeset** — handles data validation and casting

   * Useful when creating or updating records safely.

4. **Ecto.Query** — provides a composable way to build SQL queries

   * Generates SQL under the hood in a functional, safe way.

---

### 🏦 Example: connecting to a database

```elixir
# lib/my_app/repo.ex
defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.Postgres
end
```

This tells Ecto to connect to PostgreSQL (but it could also be MySQL, SQLite, etc.).

---

### 📄 Example: defining a schema (table model)

```elixir
# lib/my_app/accounts/user.ex
defmodule MyApp.Accounts.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :age, :integer
    timestamps()
  end
end
```

This maps the **users** table to a struct:

```elixir
%MyApp.Accounts.User{
  email: "test@example.com",
  age: 25
}
```

---

### ✏️ Example: inserting data

```elixir
alias MyApp.{Repo, Accounts.User}

user = %User{email: "test@example.com", age: 25}
Repo.insert(user)
```

Ecto will automatically generate and run the SQL:

```sql
INSERT INTO users (email, age, inserted_at, updated_at) VALUES ('test@example.com', 25, NOW(), NOW());
```

---

### 🔍 Example: querying data

Using the **Ecto.Query** DSL:

```elixir
import Ecto.Query

query = from u in User, where: u.age > 18, select: u.email
Repo.all(query)
```

Generates:

```sql
SELECT email FROM users WHERE age > 18;
```

---

### 🧰 Databases supported

Ecto works with multiple adapters:

* ✅ PostgreSQL (`Ecto.Adapters.Postgres`)
* ✅ MySQL (`Ecto.Adapters.MyXQL`)
* ✅ SQLite (`Ecto.Adapters.SQLite3`)
* ✅ MSSQL and others (through third-party adapters)

---

### 💡 Summary

| Concept       | Purpose                                       |
| ------------- | --------------------------------------------- |
| **Repo**      | Connects to and interacts with the database   |
| **Schema**    | Maps Elixir structs to database tables        |
| **Changeset** | Validates and prepares data for insert/update |
| **Query**     | Builds SQL safely and composably              |

---

That snippet is from an Elixir **`.formatter.exs`** file — it defines which files the **Elixir code formatter** should process when you run:

```bash
mix format
```

Let’s break it down:

```elixir
# Default Elixir project rules
inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
```

### 🧩 Explanation

* **`inputs:`**
  Lists all files or directories the formatter should check and format.

* **`"{mix,.formatter}.exs"`**
  This means both `mix.exs` and `.formatter.exs` files will be included.

* **`"{config,lib,test}/**/*.{ex,exs}"`**
  This expands to include all `.ex` and `.exs` files inside:

  * `config/`
  * `lib/`
  * `test/`

  recursively (`**/*` means all subdirectories too).

### 🧰 In summary

This rule tells Elixir’s formatter to automatically format:

* your main project file (`mix.exs`)
* the formatter config itself (`.formatter.exs`)
* all code and test files under `config`, `lib`, and `test`.

---

If you wanted to include other folders (like `scripts` or `priv`), you could extend it like this:

```elixir
inputs: [
  "{mix,.formatter}.exs",
  "{config,lib,test,scripts}/**/*.{ex,exs}"
]
```
# Migration

### 1️⃣ Roll back the migration

From your terminal, run:

```bash
mix ecto.rollback -n 1
```

* `-n 1` rolls back the last migration only.
* This will drop the table created by that migration.

---

### 2️⃣ Update the migration

Modify your migration file to include defaults for timestamps, e.g.:

```elixir
timestamps(
  default: fragment("NOW()"),
  null: false
)
```

---

### 3️⃣ Run the migration again

```bash
mix ecto.migrate
```

---

### ⚠️ Important notes

* If the table had **any data**, rolling back will delete it. Make sure you don’t need it, or back it up first.
* After adding `default: fragment("NOW()")`, PostgreSQL will automatically set `inserted_at` and `updated_at` for any new rows, avoiding the `not_null_violation`.
