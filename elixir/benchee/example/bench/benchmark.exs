
length = 50_000
items = BenchData.items(length, 10)
# sample_limit = 5      # early-exit behavior
sample_limit = length  # full traversal overhead

reduce_while_fun = fn ->
  Enum.reduce_while(items, {[], 0}, fn item, {acc, count} ->
    op = item[:index]

    case op do
      %{error: error, _id: id} ->
        acc = [Map.put(error, :_id, id) | acc]
        count = count + 1

        if count >= sample_limit do
          {:halt, Enum.reverse(acc)}
        else
          {:cont, {acc, count}}
        end

      _ ->
        {:cont, {acc, count}}
    end
  end)
end

stream_filter_fun = fn ->
  items
  |> Stream.map(& &1[:index])
  |> Stream.filter(&match?(%{error: _}, &1))
  |> Stream.map(fn %{error: e, _id: id} -> Map.put(e, :_id, id) end)
  |> Enum.take(sample_limit)
end

stream_transform_fun = fn ->
  items
  |> Stream.transform([], fn item, acc ->
    case item[:index] do
      %{error: e, _id: id} ->
        {[Map.put(e, :_id, id)], acc}

      _ ->
        {[], acc}
    end
  end)
  |> Enum.take(sample_limit)
end

Benchee.run(
  %{
    "stream_filter" => stream_filter_fun,
    "reduce_while" => reduce_while_fun,
    "stream_transform" => stream_transform_fun,
  },
  warmup: 5,
  time: 10
)
