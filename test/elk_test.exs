defmodule ElkTest do
  use ExUnit.Case
  doctest Elk

  test "greets the world" do
    assert Elk.hello() == :world
  end
end
