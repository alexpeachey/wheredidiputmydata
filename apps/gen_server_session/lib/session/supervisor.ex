defmodule GenServerSession.Supervisor do
  @moduledoc """
  A supervisor to restart the GenServer storing the sessions should it die.
  """

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {GenServerSession.Server, %{}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
