defmodule BenchData do
  def items(total, error_every \\ 10) do
    for i <- 1..total do
      op =
        if rem(i, error_every) == 0 do
          %{_id: i, error: %{reason: :boom}}
        else
          %{_id: i}
        end

      %{index: op}
    end
  end
end
