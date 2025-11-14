# Minimal example of a simple API endpoint written in **Elixir + Phoenix**

[Phoenix offical docs](https://hexdocs.pm/phoenix/up_and_running.html)

We’ll build a tiny endpoint:
👉 `GET /api/hello` → returns JSON `{ "message": "Hello, world!" }`

---

## 1 Create a new Phoenix project

First, make sure you have Elixir (and Erlang) installed, then install Phoenix’s generator:

```bash
mix archive.install hex phx_new
```

| Part                  | Meaning                                                                                                                                        |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **`mix`**             | The Elixir **build tool and project manager** (similar to `npm` for Node.js or `pip` for Python). It comes with Elixir.                        |
| **`archive.install`** | A `mix` task that installs a reusable package (an "archive") globally on your system.                                                          |
| **`hex`**             | Refers to [**Hex.pm**](https://hex.pm) — the official package registry for Elixir and Erlang (like `npm` for JavaScript or `PyPI` for Python). |
| **`phx_new`**         | The name of the package that contains the **Phoenix project generator** — basically a tool that can scaffold a new Phoenix web app.            |

---

It tells `mix` to:

> “Install the Phoenix project generator (`phx_new`) globally from the Hex package registry.”

After it runs, you get access to a new `mix` task called `phx.new`.

So you can now run:

```bash
mix phx.new my_app
```

and it will automatically generate a fully functional Phoenix application — including directories, configuration, dependencies, and starter code.

---

### 🧩 Example output

When you run:

```bash
mix archive.install hex phx_new
```

you’ll see something like:

```
Resolving Hex dependencies...
New archive "phx_new-1.7.10.ez" installed at:
~/.mix/archives/phx_new-1.7.10
```

Now you can create a project:

```bash
mix phx.new hello_world
```

---

### ⚙️ Optional version pinning

If you want a specific Phoenix generator version (for example `1.7.10`), you can specify it:

```bash
mix archive.install hex phx_new 1.7.10
```

---

### 📦 Where it installs to

The archive (a `.ez` file) is stored in:

```
~/.mix/archives/
```

It’s similar to installing a global CLI tool.

---

✅ **In short:**

`mix archive.install hex phx_new`
→ downloads and installs the Phoenix app generator globally,
so you can run `mix phx.new your_app_name` to create new Phoenix projects.

---

## 2 Generate a new app (API-only, no HTML)

```bash
mix phx.new hello_api --no-html --no-assets
cd hello_api
```

Install dependencies:

```bash
mix deps.get
```

---

## ⚙️ 2. Add a simple route

Open **`lib/hello_api_web/router.ex`** and add a route inside the `/api` scope:

```elixir
defmodule HelloApiWeb.Router do
  use HelloApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HelloApiWeb do
    pipe_through :api

    get "/hello", HelloController, :index
  end
end
```

Let’s unpack that Elixir code line by line — so you understand *exactly* what’s going on under the hood.


### 🧱 1. `defmodule HelloApiWeb.Router do`

This defines a **module** (a namespaced container for functions, like a class in other languages).
It’s the **Router module** for your web app — responsible for mapping **incoming HTTP requests** (like `/api/hello`) to the **correct controller actions**.

---

### ⚙️ 2. `use HelloApiWeb, :router`

This line “injects” Phoenix’s **router behavior** into this module.

* Think of it as “include router functionality here.”
* It gives you access to Phoenix macros like `pipeline`, `scope`, `get`, `post`, etc.

Without this, the router DSL (domain-specific language) wouldn’t work.

---

### 🧩 3. `pipeline :api do ... end`

A **pipeline** is a **series of plugs** (middleware) that will be applied to requests in a certain scope.

Here, you define a pipeline named `:api`:

```elixir
pipeline :api do
  plug :accepts, ["json"]
end
```

This means:

* All routes using this pipeline will only accept `application/json` requests.
* Phoenix will automatically reject or convert other content types.

You can define multiple pipelines, e.g.:

* `:browser` → for HTML routes (uses sessions, CSRF protection, etc.)
* `:api` → for JSON APIs (lightweight, stateless)

---

### 🧩 4. `scope "/api", HelloApiWeb do ... end`

A **scope** groups routes under a common URL prefix and module namespace.

Here:

* All routes will start with `/api`
* Controllers are looked up in the `HelloApiWeb` namespace

So a route defined as:

```elixir
get "/hello", HelloController, :index
```

actually maps to:

```
GET /api/hello → HelloApiWeb.HelloController.index/2
```

When an HTTP GET request is made to the path /api/hello,
Phoenix should call the function index/2 (the index action function with 2 args)
inside the module HelloApiWeb.HelloController to handle it.

---

## 🧩 5. `pipe_through :api`

This line tells Phoenix:

> “Apply the plugs defined in the `:api` pipeline before handling these routes.”

So it connects the pipeline to this scope — meaning all routes inside will accept JSON requests.

---

## 🧩 6. `get "/hello", HelloController, :index`

This defines the actual route:

| HTTP Method | Path         | Controller        | Action  |
| ----------- | ------------ | ----------------- | ------- |
| `GET`       | `/api/hello` | `HelloController` | `index` |

That means when someone visits `/api/hello`, Phoenix will call:

```elixir
HelloApiWeb.HelloController.index(conn, params)
```

(where `conn` is the connection struct and `params` are query params or request data)

---

## 🧠 Putting it all together

When a request comes in:

1. `GET /api/hello`
2. Phoenix finds it in the router (under `/api` scope)
3. It applies the `:api` pipeline (which ensures JSON)
4. It calls `HelloApiWeb.HelloController.index/2`
5. That function sends a JSON response (like `{"message": "Hello, world!"}`)

---

## 💡 Analogy (if you know Express or FastAPI)

| Phoenix                                 | Express (Node.js)               | FastAPI (Python)           |
| --------------------------------------- | ------------------------------- | -------------------------- |
| `pipeline`                              | `app.use(middleware)`           | `Depends()` or middleware  |
| `scope "/api"`                          | `app.use('/api', router)`       | `APIRouter(prefix='/api')` |
| `get "/hello", HelloController, :index` | `router.get('/hello', handler)` | `@app.get("/hello")`       |

So Phoenix’s router is very similar in concept — just more declarative and functional.

---

Would you like me to explain what the **`plug`** system is (the middleware layer that powers pipelines and controllers in Phoenix)?

---

## 🧩 3. Create the controller

Create a new file at **`lib/hello_api_web/controllers/hello_controller.ex`**:

```elixir
defmodule HelloApiWeb.HelloController do
  use HelloApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "Hello, world!"})
  end
end
```

---

## 4. Make sure db authentication is correct

```bash
sudo -i -u postgres
```

> “Log me in as the `postgres` Linux user, which owns the PostgreSQL server process and has admin privileges for the database.”

Now you’re ready to manage PostgreSQL directly.

---

### 🪟 1. Open the PostgreSQL prompt

Once you’re in the `postgres` user shell, run:

```bash
psql
```

You should now see a prompt like:

```
postgres=#
```

This means you’re connected to the database as the `postgres` superuser.

---

### 🔑 2. Check or reset the password

To ensure Phoenix can connect, reset the password for the `postgres` DB role:

```sql
ALTER USER postgres PASSWORD 'postgres';
```

✅ This sets the password to `"postgres"`, which matches Phoenix’s default `config/dev.exs`.

---

### 💾 3. Verify your databases

You can list all databases:

```sql
\l
```

You should see something like:

```
Name           | Owner    | Encoding
---------------+-----------+----------
hello_api_dev  | postgres | UTF8
postgres       | postgres | UTF8
template1      | postgres | UTF8
```

If your Phoenix app’s database (e.g. `hello_api_dev`) isn’t there, no problem — you can create it later using:

```bash
mix ecto.create
```

---

### 🚪 4. Exit psql

When you’re done, type:

```sql
\q
```

And then exit the `postgres` shell:

```bash
exit
```

---

### 🧪 5. Test that the new password works

Back in your normal user shell, try:

```bash
psql -U postgres -h localhost
```

When prompted for a password, enter:

```
postgres
```

If it logs in successfully → your Phoenix app should now connect fine.

---

✅ **Summary**

You did:

```bash
sudo -i -u postgres
```

Now do inside that shell:

```bash
psql
ALTER USER postgres PASSWORD 'postgres';
\q
exit
```

Then test it:

```bash
psql -U postgres -h localhost
```

If that works, run:

```bash
mix ecto.create
mix phx.server
```

Your Phoenix app should now connect cleanly 🎉

---

## ▶️ 5. Run the server
Start your Phoenix server:

```bash
mix phx.server
```

You’ll see:

```
[info] Running HelloApiWeb.Endpoint with cowboy 2.9.0 at 0.0.0.0:4000
```

Now open your browser or use `curl`:

```bash
curl http://localhost:4000/api/hello
```

Output:

```json
{"message":"Hello, world!"}
```

---

## 🧠 What just happened

| Component          | Purpose                                     |
| ------------------ | ------------------------------------------- |
| `Router`           | Defines routes and maps them to controllers |
| `HelloController`  | Handles HTTP logic for `/api/hello`         |
| `json(conn, data)` | Sends a JSON response                       |
| `mix phx.server`   | Runs the web server (Cowboy)                |

# Formatter

The **`.formatter.exs`** file is part of Elixir’s built-in **code formatter system**.

It tells Elixir **how to automatically format your code** when you run:

```bash
mix format
```

Let’s unpack it clearly 👇

---

### 🧩 What `.formatter.exs` is

It’s a **configuration file** that controls:

* which files get formatted
* optional style preferences (like line length, import sorting, etc.)

It’s written in Elixir syntax (not JSON or YAML), so it looks like this:

```elixir
# .formatter.exs
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
]
```

---

### ⚙️ 1. `inputs` – which files to format

This is the most common setting.

It tells the formatter *where to look* for `.ex` and `.exs` files.

```elixir
inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
```

✅ means:

* format the main files (`mix.exs`, `.formatter.exs`)
* format everything in `config/`, `lib/`, and `test/` (and all subfolders)

---

### ✏️ 2. Other optional settings

You can also customize formatting behavior.
Here are common ones:

```elixir
[
  # Line length before wrapping
  line_length: 100,

  # Keep some function calls on one line
  locals_without_parens: [plug: 1, get: 2, post: 2],

  # Which files to format
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
]
```

---

### 🧠 3. Why use it

* **Consistency:** everyone on your team formats code the same way
* **Automation:** `mix format` can be run before commits or in CI
* **Safety:** it doesn’t change logic — only code layout (spaces, newlines, indentation)

Example:

```elixir
# before
defmodule Demo do
 def hello,do:IO.puts("Hi")
end

# after `mix format`
defmodule Demo do
  def hello, do: IO.puts("Hi")
end
```

---

### 🧰 4. Typical workflow

```bash
# Format everything
mix format

# Check what would change (without writing)
mix format --check-formatted

# Format only specific files
mix format lib/my_app/*.ex
```

---

✅ **In short**

| Setting                  | Purpose                                         |
| ------------------------ | ----------------------------------------------- |
| `.formatter.exs`         | Defines code formatting rules                   |
| `inputs:`                | Tells the formatter which files to format       |
| `line_length:`           | Controls wrapping width                         |
| `locals_without_parens:` | Keeps chosen functions cleaner (no parentheses) |

---

# Tips

- Double "ctrl+c" to stop server

# Test
In a standard **Phoenix/Elixir project**, your test modules should go under the `test/` directory, mirroring the namespace of the module you’re testing.

For the `Aurora.Payment.PayByBank` module, the test file should be:

```
test/aurora/payment/pay_by_bank_test.exs
```

---

### **Steps:**

1. Create the folder structure if it doesn’t exist:

```bash
mkdir -p test/aurora/payment
```

2. Create the test file:

```bash
touch test/aurora/payment/pay_by_bank_test.exs
```

3. Paste your test module inside:

```elixir
defmodule Aurora.Payment.PayByBankTest do
  use ExUnit.Case, async: true
  alias Aurora.Repo

  # ...rest of your tests
end
```
4. Update DB credential
> config/test.exs

5. Run the test:

```bash
mix test test/aurora/payment/pay_by_bank_test.exs
```

### 1️⃣ Run all tests

```bash
mix test
```

* This will automatically find all files in the `test/` directory ending with `_test.exs`.
* It runs all tests and prints a summary (number of tests, failures, and time).

---

### 2️⃣ Run tests with more info

```bash
mix test --trace
```

* Runs tests **one by one**, showing the module and test name.
* Useful for debugging failing tests.

---

### 3️⃣ Run a single test file

```bash
mix test test/aurora_web/controllers/pay_by_bank_controller_test.exs
```

* Only runs the specified file.
* Faster when iterating on a single test module.

---

### 4️⃣ Run a specific test inside a file

```bash
mix test test/aurora_web/controllers/pay_by_bank_controller_test.exs:42
```

* Runs the test that **starts at line 42**.
* Useful for focused debugging.

---

### 5️⃣ Additional tips

* Make sure your **Phoenix server is stopped** when running tests (tests run in isolation).
* Tests run in the **`test` environment** by default. You can confirm with:

```bash
MIX_ENV=test mix test
```

* Use `mix test --failed` to re-run only failing tests.

# Environment
### 1. **`config/config.exs`**

* This is the **base configuration** for all environments.
* It often includes lines like:

```elixir
import_config "#{Mix.env()}.exs"
```

This line tells Elixir to load the environment-specific config (`dev.exs`, `prod.exs`, `test.exs`, `staging.exs`) **after** the base config.

---

### 2. **Environment-specific files**

* `dev.exs` → Development environment
* `prod.exs` → Production environment
* `test.exs` → Test environment
* `staging.exs` → Staging environment

These files **override** settings from `config.exs` as needed.

---

### 3. **`runtime.exs`**

* Loaded at runtime (not compile-time).
* Useful for configuration that depends on environment variables or secrets that are only available at runtime.
* Still can differentiate between environments:

```elixir
if config_env() == :prod do
  # prod-only runtime config
end
```

---

### 4. **How the environment is chosen**

The environment is determined by `Mix.env()`:

* When you run commands like `mix phx.server` or `iex -S mix`, it defaults to `:dev`.
* You can override it with:

```bash
MIX_ENV=prod mix phx.server
```

* This will load `config.exs` → `prod.exs` → `runtime.exs` in that order.

---

✅ **Summary:**

* `config/config.exs` decides which env-specific file to load (via `import_config "#{Mix.env()}.exs"`).
* `MIX_ENV` is the variable that determines which environment (`dev`, `prod`, `test`, `staging`) is active.
* `runtime.exs` handles runtime-specific configs, often for secrets or dynamic settings.

Here’s a clear diagram showing the **load order of configuration files in an Elixir/Phoenix project**:

```
                     ┌───────────────┐
                     │ config/config.exs │
                     └───────────────┘
                              │
                              ▼
            ┌────────────────────────────────┐
            │ import_config "#{Mix.env()}.exs" │
            └────────────────────────────────┘
                              │
          ┌─────────┬───────────┬─────────────┐
          ▼         ▼           ▼             ▼
     dev.exs     test.exs     prod.exs     staging.exs
          │         │           │             │
          └─────────┴───────────┴─────────────┘
                              │
                              ▼
                     ┌───────────────┐
                     │ config/runtime.exs │
                     └───────────────┘
```

### **Priority (highest → lowest)**

1. **`runtime.exs`** – Can override both environment and base config.
2. **Environment-specific config (`dev.exs`, `prod.exs`, etc.)** – Overrides base config.
3. **`config.exs`** – Base/default config, lowest priority.

# Why runtime.exs is needed
### 1. **prod.exs** – compile-time configuration

* Files like `prod.exs` are **read at compile time**, when you build your release or run `mix phx.server` in prod.
* That means any configuration values are **baked into the compiled app**.
* If you put credentials (like API keys, DB passwords) here, they will be fixed at compile time.
* **Problem:** For releases or Docker images, you often want to supply **different credentials for each environment** (staging, production, etc.) **without rebuilding the app**. Hardcoding them in `prod.exs` makes that harder.

---

### 2. **runtime.exs** – runtime configuration

* `runtime.exs` is executed **when the app starts**, not when it’s compiled.
* This allows you to:

  * Read environment variables (`System.get_env/1`).
  * Change credentials or secrets dynamically depending on the environment.
  * Avoid committing secrets into your repository.
* Example:

```elixir
# runtime.exs
if config_env() == :prod do
  database_url = System.fetch_env!("DATABASE_URL")
  config :my_app, MyApp.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end
```

Here, the database URL and pool size are determined **when the app boots**, not when it’s compiled.

---

### 3. **Why it matters for secrets**

* Hardcoding secrets in `prod.exs` is risky:

  * They could accidentally get checked into Git.
  * Changing them requires **recompiling** the app.
* Using `runtime.exs` + environment variables:

  * Keeps secrets out of your code.
  * Lets you deploy the same release to multiple environments.
  * Plays nicely with Docker, Kubernetes, or Heroku-style setups.

---

### ✅ Summary

| Feature                  | `prod.exs`                   | `runtime.exs`   |
| ------------------------ | ---------------------------- | --------------- |
| Evaluated                | Compile-time                 | Runtime         |
| Can use environment vars | Limited (requires `Mix.env`) | Fully supported |
| Good for secrets         | ❌                            | ✅               |
| Change without rebuild   | ❌                            | ✅               |

---

In short: **put credentials in `runtime.exs` because they’re sensitive and often environment-specific, and you want them evaluated at runtime, not baked into your compiled code.**
