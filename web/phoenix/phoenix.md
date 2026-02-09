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

## Why runtime.exs is needed
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

# Multiple Phoenix (Elixir) servers 
In Elixir/Erlang, the `:sname` (short node name) allows you to run multiple nodes on the same machine. 

By default, Phoenix runs on port `4000`. To run 2 servers simultaneously, you need to override the port for each:

```bash
PORT=4001 iex --sname server1 -S mix phx.server
PORT=4002 iex --sname server2 -S mix phx.server
epmd -names
```

```elixir
Node.self()
Node.ping(:server1@debian)
Node.list()
```
`hostname` is usually your local machine name

When instance is not start with `--sname`, i.e. in test
```elixir
iex> Node.self()
:nonode@nohost
iex> Node.ping(Node.self())
:pang
```