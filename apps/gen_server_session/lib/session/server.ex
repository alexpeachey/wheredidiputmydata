defmodule GenServerSession.Server do
  use GenServer
  alias GenServerSession.Session

  @type state :: %{
          required(String.t()) => Session.t()
        }

  @spec start_link(state()) :: {:ok, pid()}
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @spec init(state()) :: {:ok, state()}
  def init(state) do
    {:ok, state}
  end

  def handle_call({:store, session}, _from, state) do
    {
      :reply,
      session,
      Map.put(state, session.id, session)
    }
  end

  def handle_call({:fetch, id}, _from, state) do
    {
      :reply,
      Map.get(state, id),
      state
    }
  end

  def handle_call({:remove, id}, _from, state) do
    {
      :reply,
      :ok,
      Map.delete(state, id)
    }
  end
end
