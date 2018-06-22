defmodule GeoBounds do
  use Application


  @moduledoc """
  The Application Supervision Tree
  """



  # Public API
  # ----------

  @doc "Start the Application"
  def start(_type, _args) do
    children =
      :geo_bounds
      |> Application.get_env(:env)
      |> children()

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end



  # Private Helpers
  # ---------------

  defp children(:test), do: []
  defp children(_env) do
    [
      GeoBounds.BoxServer,
    ]
  end

end
