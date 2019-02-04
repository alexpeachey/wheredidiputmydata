defmodule GenServerSession.Session do
  alias GenServerSession.{Session, Server}
  defstruct [:id, :name, :location, :started_at]

  @type t :: %Session{
          id: String.t(),
          name: String.t(),
          location: String.t(),
          started_at: DateTime.t()
        }

  @moduledoc """
  A session management system using a GenServer to store state.
  """

  @spec start(String.t(), String.t()) :: Session.t()
  def start(name, location) do
    session = %Session{
      id: Ecto.UUID.generate(),
      name: name,
      location: location,
      started_at: Timex.now()
    }

    GenServer.call(Server, {:store, session})
  end

  @spec fetch(String.t()) :: Session.t() | nil
  def fetch(session_id) do
    GenServer.call(Server, {:fetch, session_id})
  end

  @spec stop(String.t()) :: :ok
  def stop(session_id) do
    GenServer.call(Server, {:remove, session_id})
  end
end
