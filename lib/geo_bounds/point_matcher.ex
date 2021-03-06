defmodule GeoBounds.PointMatcher do
  use GenServer
  require Logger

  alias GeoBounds.Location
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
  def match(%Location{} = point) do
    GenServer.call(__MODULE__, {:match, point})
  end



  @doc "Match a point pair"
  def match(%Location{} = origin, %Location{} = destination) do
    {
      match(origin),
      match(destination),
    }
  end



  @doc "List all matched points"
  def list do
    GenServer.call(__MODULE__, :list)
  end





  ## Callbacks
  ## ---------


  # Initialize State with empty map
  @doc false
  def init(:ok) do
    {:ok, %{}}
  end



  # Handle call for :match
  @doc false
  def handle_call({:match, point}, _from, map) do
    box = BoxServer.find(point)
    map =
      if box do
        Logger.debug("Saved #{point} against #{box}")
        Map.put(map, point, box)
      else
        Logger.debug("Discarded #{point} - No BoundedBox found")
        map
      end

    {:reply, box, map}
  end



  # Handle call for :list
  @doc false
  def handle_call(:list, _from, map) do
    {:reply, map, map}
  end


end


