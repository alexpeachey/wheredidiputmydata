defmodule MnesiaSession.Store do
  @moduledoc """
  Helper utilities to streamline Mnesia access.
  """

  def read(table, key) do
    :mnesia.transaction(fn -> :mnesia.read(table, key) end)
  end

  def write(record) do
    :mnesia.transaction(fn -> :mnesia.write(record) end)
  end

  def delete(table, key) do
    :mnesia.transaction(fn -> :mnesia.delete({table, key}) end)
  end
end
