defmodule ETSSession do
  use Application

  @moduledoc """
  Session tracking using an ETS table
  """

  def start(_type, _args) do
    ETSSession.Supervisor.start_link(name: ETSSession.Supervisor)
  end
end
