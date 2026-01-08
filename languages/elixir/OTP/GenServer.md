# What is `GenServer`?

`GenServer` stands for **Generic Server**. It’s a behavior module in Elixir that abstracts the **common pattern of a server process**. In simpler terms:

* It allows you to create a **process** that **maintains state**, handles **synchronous and asynchronous requests**, and **runs in the background**.
* It’s part of the **OTP (Open Telecom Platform)** framework, which is Elixir/Erlang’s set of tools for building reliable, concurrent applications.

Think of a `GenServer` as a **smart worker process** that you can talk to, tell it to do things, and ask it questions, all while it keeps track of its own internal state.

# Why use `GenServer`?

1. **Stateful processes** – You can keep state across requests.
2. **Concurrency made easy** – Each `GenServer` is its own process, so you avoid shared memory issues.
3. **Fault-tolerance** – Works naturally with supervisors for automatic recovery.
4. **Synchronous and asynchronous calls** – Handle both immediate requests (`call`) and fire-and-forget requests (`cast`).

# Basic Structure

Here’s a minimal `GenServer` example:

```elixir
defmodule Counter do
  use GenServer

  # Client API

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def increment do
    GenServer.cast(__MODULE__, :increment)
  end

  def get_value do
    GenServer.call(__MODULE__, :get)
  end

  # Server Callbacks

  def init(initial_value) do
    {:ok, initial_value}  # initial state
  end

  def handle_cast(:increment, state) do
    {:noreply, state + 1}  # update state asynchronously
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}  # respond with current state
  end
end
```
# How it works

1. `start_link/1` – starts the process with an initial state.
2. `increment/0` – sends an **asynchronous message** (`cast`) to increment the counter.
3. `get_value/0` – sends a **synchronous message** (`call`) to get the current value.
4. `handle_cast/2` – handles async messages and updates state.
5. `handle_call/3` – handles sync messages and can reply.

# **Task vs GenServer**

| Feature           | Task                                         | GenServer                                           |
| ----------------- | -------------------------------------------- | --------------------------------------------------- |
| **Purpose**       | Run a short-lived job asynchronously         | Maintain state, handle requests, long-lived process |
| **State**         | Usually none (ephemeral)                     | Persistent across calls                             |
| **Communication** | Usually sends result back once               | Can handle many calls/casts over time               |
| **Lifecycle**     | Dies after job finishes                      | Can live indefinitely, supervised                   |
| **Supervision**   | Can be supervised, but often fire-and-forget | Usually supervised, integral to [OTP design](OTP.md)          |
| **Use case**      | Background jobs, one-off async tasks         | Servers, caches, counters, DB connection pools      |

## **Example: Why Task isn’t enough**

Imagine you want a **counter** that multiple parts of your app can increment and read:

```elixir
# This doesn’t work well with Task
Task.start(fn -> 
  counter = 0
  counter = counter + 1
  IO.puts(counter)
end)
```

* This `Task` runs **once**, increments the counter, and then dies.
* The next time you want the counter, there’s **no state** left.
* You’d have to store state somewhere else (like [ETS](../ETS.md)), which is unnecessary overhead.

With a **GenServer**, the state **lives inside the process**, so you can:

```elixir
Counter.increment()
Counter.increment()
Counter.get_value()  # => 2
```

The state persists across multiple calls.

---

### **When to use Task**

* Fire-and-forget jobs (send email, make an HTTP request)
* Short-lived async computations
* Parallel processing (like `Task.async_stream`)

### **When to use GenServer**

* Long-lived processes
* Stateful computations (counters, caches, queues)
* Coordinating access to a resource (like a DB connection)
* Handling repeated synchronous or asynchronous messages
