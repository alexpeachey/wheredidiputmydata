defmodule GenServerSession do
  use Application

  @moduledoc """
  Session tracking using a GenServer
  """

  def start(_type, _args) do
    GenServerSession.Supervisor.start_link(name: GenServerSession.Supervisor)
  end
end
