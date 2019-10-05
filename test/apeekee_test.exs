defmodule ApeekeeTest do
  use ExUnit.Case
  doctest Apeekee

  test "greets the world" do
    assert Apeekee.hello() == :world
  end
end
