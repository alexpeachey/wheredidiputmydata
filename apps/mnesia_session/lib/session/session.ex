defmodule MnesiaSession.Session do
  require Record
  alias MnesiaSession.{Session, Store}

  @moduledoc """
  A session management system using Mnesia to store state.
  """

  Record.defrecord(:session, id: nil, name: nil, location: nil, started_at: nil)
  @type t :: record(:session)
  @type session_map :: %{
          id: String.t(),
          name: String.t(),
          location: String.t(),
          started_at: DateTime.t()
        }

  @spec start(String.t(), String.t()) :: Session.t()
  def start(name, location) do
    instance =
      session(
        id: Ecto.UUID.generate(),
        name: name,
        location: location,
        started_at: Timex.now()
      )

    Store.write(instance)
    instance
  end

  @spec fetch(String.t()) :: Session.t() | nil
  def fetch(session_id) do
    case Store.read(:session, session_id) do
      {:atomic, [instance]} -> instance
      {:atomic, []} -> nil
    end
  end

  @spec stop(String.t()) :: :ok
  def stop(session_id) do
    Store.delete(:session, session_id)
    :ok
  end

  @spec fields() :: list(:atom)
  def fields(), do: [:id, :name, :location, :started_at]

  @spec to_map(Session.t()) :: Session.session_map()
  def to_map(record), do: Enum.into(session(record), %{})
end
