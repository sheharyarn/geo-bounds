defmodule GeoBounds.BoxServer do
  use GenServer

  alias GeoBounds.Coordinate
  alias GeoBounds.BoundedBox


  @moduledoc """
  GenServer process that acts as a repo for storing
  bounded boxes and finding ones for a given point.
  """




  ## Public API
  ## ----------


  @doc "Start the GenServer"
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end



  @doc "Add a new bounding box to the server"
  def add(%BoundedBox{} = box) do
    GenServer.cast(__MODULE__, {:add, box})
  end



  @doc "Find a box inside which the given point lies in"
  def find(%Coordinate{} = point) do
    GenServer.call(__MODULE__, {:find, point})
  end





  ## Callbacks
  ## ---------


  # Initialize State with empty list
  @doc false
  def init(:ok) do
    {:ok, []}
  end



  # Handle cast for :add
  @doc false
  def handle_cast({:add, box}, boxes) do
    boxes = [box | boxes]
    {:noreply, boxes}
  end



  # Handle call for :find
  @doc false
  def handle_call({:find, point}, _from, boxes) do
    box = Enum.find(boxes, &BoundedBox.inside?(&1, point))

    {:reply, box, boxes}
  end


end

