defmodule GeoBounds.BoundedBox do
  defmodule InvalidData, do: defexception [:message]
  defstruct [:top, :bottom, :left, :right]

  alias GeoBounds.Location
  alias GeoBounds.BoundedBox


  @moduledoc """
  A struct representation of axis-aligned bounded boxes along
  with helper functions to see if a point lies inside the
  box.
  """




  # Public API
  # ----------


  @doc "Return a new Bounded Box for given coordinates"
  def new(%Location{} = c1, %Location{} = c2) do
    {bottom, top} = minimax(c1.latitude,  c2.latitude)
    {left, right} = minimax(c1.longitude, c2.longitude)

    %BoundedBox{top: top, bottom: bottom, left: left, right: right}
  end

  def new({_, _} = c1, {_, _} = c2) do
    new(Location.new(c1), Location.new(c2))
  end

  def new(_, _) do
    raise BoundedBox.InvalidData, message: "Invalid coordinates specified"
  end



  @doc "Check if a coordinate lies inside a bounded box"
  def inside?(%BoundedBox{} = box, %Location{} = point) do
    (point.latitude  <= box.top)    &&
    (point.latitude  >= box.bottom) &&
    (point.longitude <= box.right)  &&
    (point.longitude >= box.left)
  end




  # Private Helpers
  # ---------------


  # Get the min and max of two numbers
  defp minimax(x, y) when is_number(x) and is_number(y) do
    {min(x, y), max(x, y)}
  end


end
