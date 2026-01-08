# **What is ETS?**

**ETS** stands for **Erlang Term Storage**.

It’s basically an **in-memory storage system** built into the BEAM (the Erlang/Elixir VM) that lets processes **store and access data very fast**.

* Think of it like a **super-fast, in-memory database** that lives inside your Elixir app.
* Data can be **shared between processes**, unlike regular process state (like in a GenServer) which is private.

# **Key Features**

1. **In-memory** → Very fast reads and writes.
2. **Concurrent access** → Multiple processes can read/write safely.
3. **Flexible tables** → You can have different types of tables:

   * `:set` → unique keys (like a map)
   * `:bag` → duplicate keys allowed
   * `:ordered_set` → sorted by key
4. **Large data storage** → Can store thousands or millions of items without slowing down.
5. **Optional persistence** → Usually in-memory only, but can be backed up if needed.

# **Basic ETS Example in Elixir**

```elixir
# Create a table
:ets.new(:my_table, [:named_table, :public, :set])

# Insert key-value pairs
:ets.insert(:my_table, {:foo, 123})
:ets.insert(:my_table, {:bar, 456})

# Read a value
:ets.lookup(:my_table, :foo)
# => [{:foo, 123}]

# Delete a value
:ets.delete(:my_table, :bar)
```

**Notes:**

* `:named_table` → gives the table a global name, so any process can access it.
* `:public` → any process can read/write (other options: `:protected`, `:private`).
* `:set` → unique keys, like a map.
