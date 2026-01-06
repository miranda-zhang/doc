# Benchee
## 1️⃣ What “warm-up” is on the BEAM

Elixir (Erlang VM) is a **JIT-like environment**:

* When you run a function for the first time:

  * Closures are allocated
  * Pattern matches are compiled and optimized
  * Module and protocol dispatch paths are initialized
* The first few runs are slower because the VM is “warming up” these paths.
* Garbage collector (GC) may also run differently on first executions.

If you benchmark immediately, the **first run is not representative**.


## 2️⃣ How Benchee handles warm-up

Benchee has a **`warmup` option**:

```elixir
Benchee.run(
  %{"reduce_while" => reduce_while_fun},
  warmup: 5,  # seconds
  time: 10    # seconds
)
```

What happens:

1. Benchee runs each function repeatedly for the **warmup period** (5 seconds in this case).
2. This **forces the VM to JIT / optimize / compile protocols**.
3. **After warmup**, Benchee measures execution time for the `time:` period (10 seconds here).

✅ This means the benchmark times are **less influenced by first-run initialization**.

---

## 3️⃣ What warm-up cannot fix

* It cannot remove **all sources of variability**, such as:

  * GC happening during the timed run
  * OS thread scheduling
  * CPU cache effects
* Microsecond-level benchmarks (<1 µs) may still fluctuate a lot, especially with tiny workloads.
* Protocols that **aren’t consolidated** can still add a tiny runtime overhead.

  * You can fix that with:

```bash
MIX_ENV=prod mix do compile, compile.protocols
```

---

## 4️⃣ Practical advice

* Use **warmup** in Benchee to reduce first-run bias.
* Use **protocol consolidation** in prod mode to minimize dispatch overhead.
* Benchmark **sufficiently large workloads** to reduce noise.
* Don’t benchmark single-microsecond functions and expect extremely stable results — small deviations are normal.
