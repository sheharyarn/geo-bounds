defmodule GeoBounds.Location do
  defmodule InvalidData, do: defexception [:message]
  defstruct [:latitude, :longitude]

  alias GeoBounds.Location


  @moduledoc """
  A struct representation of geo-coordinates
  """

  @latitude  %{max: +90,  min: -90}
  @longitude %{max: +180, min: -180}




  # Public API
  # ----------


  @doc "Return a new struct for given lat/longs"
  def new({long, lat}) do
    new(long, lat)
  end

  def new(long, lat) do
    validate_latitude!(lat)
    validate_longitude!(long)

    %Location{latitude: lat, longitude: long}
  end





  # Private Helpers
  # ---------------


  # Raise error if latitude is invalid
  defp validate_latitude!(lat) do
    case is_number(lat) && (lat <= @latitude.max) && (lat >= @latitude.min) do
      true -> :ok
      false ->
        raise Location.InvalidData, message: "Invalid value for Latitude"
    end
  end


  # Raise error if longitude is invalid
  defp validate_longitude!(long) do
    case is_number(long) && (long <= @longitude.max) && (long >= @longitude.min) do
      true -> :ok
      false ->
        raise Location.InvalidData, message: "Invalid value for Longitude"
    end
  end





  # Protocol Implementation
  # -----------------------

  defimpl String.Chars, for: __MODULE__ do
    def to_string(point) do
      "#Location<#{point.longitude}, #{point.latitude}>"
    end
  end


end
