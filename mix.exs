defmodule GeoBounds.MixProject do
  use Mix.Project


  def project do
    [
      app: :geo_bounds,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps()
    ]
  end


  def application do
    [extra_applications: [:logger]]
  end


  defp deps do
    [
      {:csv, "~> 2.0.0"},
    ]
  end


  defp elixirc_paths(:test), do: ["lib", "test/support.ex"]
  defp elixirc_paths(_),     do: ["lib"]

end
