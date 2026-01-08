# **What is Meta-Programming?**

**Meta-programming** is **writing code that writes code**.

* In other words, your program can **generate, modify, or inject code at compile-time** instead of runtime.
* This lets you **reduce boilerplate**, create **domain-specific languages (DSLs)**, and make your code more flexible.

Elixir has **macros** as its main meta-programming tool.

# **Example: Simple Macro**

```elixir
defmodule MyMacros do
  defmacro say_hello(name) do
    quote do
      IO.puts("Hello, #{unquote(name)}!")
    end
  end
end

defmodule Test do
  require MyMacros

  MyMacros.say_hello("World")  # => prints "Hello, World!"
end
```

## Explanation:

* `defmacro` → defines a macro
* `quote do ... end` → returns code as a **data structure** instead of executing it immediately
* `unquote` → injects runtime values into that code

Basically, the macro **generates new code at compile-time**.

# **Why Meta-Programming is Useful**

**Reduce repetitive code**:
Instead of writing the same functions over and over, a macro can generate them.
