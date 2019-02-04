defmodule ETSSession.Supervisor do
  @moduledoc """
  A supervisor to restart the GenServer that holds reference to the ETS table should it die.
  """

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {ETSSession.Session, %{}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
