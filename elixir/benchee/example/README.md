# Example
```sh
mix deps.get

# 1. Force compilation
mix compile --force

# 2. Consolidate protocols for best benchmark accuracy
MIX_ENV=prod mix do compile, compile.protocols

mix run bench/benchmark.exs
```
```
Operating System: Linux
CPU Information: Intel(R) Core(TM) i5-4570S CPU @ 2.90GHz
Number of Available Cores: 4
Available memory: 15.51 GB
Elixir 1.16.2
Erlang 25.3.2.10
JIT enabled: true

Benchmark suite executing with the following configuration:
warmup: 5 s
time: 10 s
memory time: 0 ns
reduction time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 45 s
Excluding outliers: false

Benchmarking reduce_while ...
Benchmarking stream_filter ...
Benchmarking stream_transform ...
Calculating statistics...
Formatting results...

Name                       ips        average  deviation         median         99th %
reduce_while            669.25        1.49 ms    ±37.99%        1.34 ms        3.91 ms
stream_filter           406.95        2.46 ms    ±13.87%        2.40 ms        4.29 ms
stream_transform        167.16        5.98 ms    ±15.36%        5.75 ms       10.56 ms

Comparison: 
reduce_while            669.25
stream_filter           406.95 - 1.64x slower +0.96 ms
stream_transform        167.16 - 4.00x slower +4.49 ms
```

## 1️⃣ Benchmark numbers

```
Name                       ips        average  deviation         median         99th %
reduce_while            669.25        1.49 ms    ±37.99%        1.34 ms        3.91 ms
stream_filter           406.95        2.46 ms    ±13.87%        2.40 ms        4.29 ms
stream_transform        167.16        5.98 ms    ±15.36%        5.75 ms       10.56 ms
```

* **ips** = iterations per second
* **average** = average time per run in milliseconds
* **deviation** = variability
* **median** = 50th percentile
* **99th percentile** = outliers

### Observations

1. **`reduce_while` is fastest** — single-pass, early termination, minimal allocations.
2. **`stream_filter` is ~1.6× slower** — extra closure overhead, map/filter operations, but still reasonable.
3. **`stream_transform` is ~4× slower** — more flexible but heavier stream machinery.


## 2️⃣ Why deviations differ

* `reduce_while` deviation ±38% is high because **runtime is very small (1–2 ms)**. Minor system scheduling and CPU interrupts create a large percentage deviation.
* Stream benchmarks are slightly longer, so their deviations are smaller percentages.

