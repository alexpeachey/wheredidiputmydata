defmodule GenServerSessionTest do
  use ExUnit.Case
  doctest GenServerSession

  test "greets the world" do
    assert GenServerSession.hello() == :world
  end
end
