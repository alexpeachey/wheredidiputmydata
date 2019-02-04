defmodule MnesiaSession.Setup do
  alias MnesiaSession.Session

  @moduledoc """
  Useful functions for setting up Mnesia for use in this project.
  """

  def create_schema() do
    case schema_exists?() do
      true ->
        {:ok, :already_created}

      false ->
        Enum.map(Node.list(), fn n -> Node.spawn_link(n, &:mnesia.stop/0) end)
        :mnesia.stop()
        :mnesia.create_schema(nodes())
        :mnesia.start()
        Enum.map(Node.list(), fn n -> Node.spawn_link(n, &:mnesia.start/0) end)
    end
  end

  def create_session_table() do
    case table_exists?() do
      true ->
        {:ok, :already_created}

      false ->
        :mnesia.create_table(:session, attributes: Session.fields(), disc_copies: nodes())
    end
  end

  def add_node(name) do
    :mnesia.change_table_copy_type(:schema, name, :disc_copies)
    :mnesia.add_table_copy(:schema, name, :disc_copies)
    :mnesia.add_table_copy(:session, name, :disc_copies)
  end

  def nodes(), do: [node() | Node.list()]

  def schema_exists?() do
    :mnesia.table_info(:schema, :disc_copies) != []
  end

  def table_exists?() do
    Enum.member?(:mnesia.system_info(:tables), :session)
  end
end
