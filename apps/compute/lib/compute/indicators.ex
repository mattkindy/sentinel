defmodule Compute.Indicators do
  @moduledoc """
  Numerical indicator functions. Plain Elixir for now, Nx later.

  All functions take plain lists and return `{:ok, result}`
  or `{:error, reason}` tuples
  """

  @doc """
  Simple moving average over `series` with the given `window`.

  Returns `{:ok, averages}` when `window` is a positive integer no larger
  than the series length; the result has `length(series) - window + 1`
  elements. Returns `{:error, "invalid input"}` for any other window or
  a series shorter than the window.

  ## Examples

      iex> Compute.Indicators.sma([1.0, 2.0, 3.0, 4.0], 2)
      {:ok, [1.5, 2.5, 3.5]}

      iex> Compute.Indicators.sma([1.0], 0)
      {:error, "invalid input"}

  """
  @spec sma([number()], integer()) :: {:ok, [float()]} | {:error, String.t()}
  def sma(series, window)
      when is_list(series) and is_integer(window) and window > 0 and length(series) >= window do
    result =
      series
      |> Enum.chunk_every(window, 1, :discard)
      |> Enum.map(fn chunk -> Enum.sum(chunk) / window end)

    {:ok, result}
  end

  def sma(_series, _window), do: {:error, "invalid input"}
end
