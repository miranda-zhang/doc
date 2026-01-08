# **What is a DSL?**

A **DSL** is a **mini-language created for a specific domain** or purpose.

* Unlike a general-purpose language like Elixir, Python, or Java, a DSL is **tailored to a problem area**.
* It makes code **more expressive, readable, and concise** in that domain.

**Examples in real life:**

* SQL → querying databases (a DSL for data queries)
* Regex → pattern matching in strings
* HTML → describing web page structure

In Elixir, DSLs are often **built using macros**.

# **Why use DSLs?**

1. **Expressiveness**: Makes the code read like **natural language** for that domain.
2. **Less boilerplate**: You write less repetitive code.
3. **Error reduction**: The DSL enforces rules in its domain.
4. **Maintainability**: Code becomes **self-documenting**.

# **Elixir DSL Example: Phoenix Router**

```elixir
defmodule MyAppWeb.Router do
  use Phoenix.Router

  scope "/", MyAppWeb do
    get "/hello", HelloController, :index
    post "/users", UserController, :create
  end
end
```

* This looks almost like a **mini-language for defining routes**.
* Behind the scenes, Phoenix uses **macros** to transform these declarations into Elixir code that sets up HTTP routing.

# **Simple Custom DSL in Elixir**

```elixir
defmodule MyDSL do
  defmacro command(name) do
    quote do
      def unquote(name)() do
        IO.puts("Running command #{unquote(name)}")
      end
    end
  end
end

defmodule Test do
  require MyDSL

  MyDSL.command(:start)
  MyDSL.command(:stop)
end

Test.start()  # => "Running command start"
Test.stop()   # => "Running command stop"
```

✅ What happens here:

* `MyDSL.command(:start)` generates a **function at compile-time**.
* You just declare **what you want**, the DSL handles the repetitive code.

# **Analogy**

* Regular programming language → a hammer (general-purpose, can do many things)
* DSL → a screwdriver for a specific type of screw (customized, easier for that task)

---

💡 **Rule of Thumb**:

> If you find yourself writing a lot of repetitive, domain-specific code, consider building a **DSL** to make it expressive and concise.
