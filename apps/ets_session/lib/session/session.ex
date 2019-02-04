defmodule ETSSession.Session do
  use GenServer
  alias __MODULE__
  defstruct [:id, :name, :location, :started_at]

  @moduledoc """
  A session management system using ETS to store state.
  """

  @sessions :session_store
  @table_options [:set, :public, :named_table, read_concurrency: true]
  @type t :: %Session{
          id: String.t(),
          name: String.t(),
          location: String.t(),
          started_at: DateTime.t()
        }

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec init(:ok) :: {:ok, :ok}
  def init(:ok) do
    :ets.new(@sessions, @table_options)
    {:ok, :ok}
  end

  @spec start(String.t(), String.t()) :: Session.t()
  def start(name, location) do
    session = %Session{
      id: Ecto.UUID.generate(),
      name: name,
      location: location,
      started_at: Timex.now()
    }

    :ets.insert(@sessions, {session.id, session})
    session
  end

  @spec fetch(String.t()) :: Session.t() | nil
  def fetch(session_id) do
    case :ets.lookup(@sessions, session_id) do
      [{^session_id, session}] -> session
      [] -> nil
    end
  end

  @spec stop(String.t()) :: :ok
  def stop(session_id) do
    :ets.delete(@sessions, session_id)
    :ok
  end
end
