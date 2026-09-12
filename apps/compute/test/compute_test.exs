defmodule ComputeTest do
  use ExUnit.Case
  doctest Compute

  test "greets the world" do
    assert Compute.hello() == :world
  end
end
