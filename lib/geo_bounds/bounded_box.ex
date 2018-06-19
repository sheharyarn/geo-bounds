defmodule GeoBounds.BoundedBox do
  defmodule InvalidData, do: defexception [:message]
  defstruct [:latitude, :longitude]

  alias GeoBounds.Coordinate
  alias GeoBounds.BoundedBox


  @moduledoc """
  A struct representation of axis-aligned bounded boxes along
  with helper functions to see if a point lies inside the
  box.
  """




  # Public API
  # ----------


  @doc "Return a new Bounded Box"
  def new(%Coordinate{} = c1, %Coordinate{} = c2) do
  end

  def new(_, _) do
    raise BoundedBox.InvalidData, message: "Invalid coordinates specified"
  end



  @doc "Check if a coordinate lies inside a bbox"
  def inside?(%BoundedBox{} = box, %Coordinate{} = c) do
  end

end
