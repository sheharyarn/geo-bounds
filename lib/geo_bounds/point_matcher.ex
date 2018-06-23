defmodule GeoBounds.PointMatcher do
  use GenServer

  alias GeoBounds.Coordinate
  alias GeoBounds.BoundedBox
  alias GeoBounds.BoxServer


  @moduledoc """
  GenServer process that tries to find a bounding box
  for a given point from BoxServer. If found, it stores
  a reference to the box against the point. If not,
  discards the point.

  The BoxServer GenServer must be started before-hand.
  """




  ## Public API
  ## ----------


  @doc "Start the GenServer"
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end



  @doc "Match a point. If found, store it. If not, discard it."
  def match(%Coordinate{} = point) do
    GenServer.cast(__MODULE__, {:match, point})
  end



  @doc "Match a point pair"
  def match(%Coordinate{} = origin, %Coordinate{} = destination) do
    match(origin)
    match(destination)
  end



  @doc "List all matched points"
  def list do
    GenServer.call(__MODULE__, :list)
  end

end


