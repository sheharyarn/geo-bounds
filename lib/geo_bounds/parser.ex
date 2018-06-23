defmodule GeoBounds.Parser do
  alias GeoBounds.Location
  alias GeoBounds.BoundedBox
  alias GeoBounds.BoxServer
  alias GeoBounds.PointMatcher


  @moduledoc """
  Helper module to read boundingbox pairs or coordinates
  from file
  """

  @root             :code.priv_dir(:geo_bounds)
  @file_pairs       Path.join(@root, "data/pairs.csv")
  @file_coordinates Path.join(@root, "data/coordinates.csv")




  # Public API
  # ----------


  @doc """
  Reads a CSV of coordinates, forms overlapping groups of
  two, creates bounding boxes for each pair and saves them
  to the BoxServer.
  """
  def read_pairs!(file \\ @file_pairs) do
    file
    |> File.stream!                           # Stream the file
    |> CSV.decode!                            # Parse as CSV
    |> Stream.drop(1)                         # Drop the header
    |> Stream.map(&parse_pair!/1)             # Convert to floats
    |> Stream.map(&Location.new/1)            # Convert to coordinates
    |> Stream.chunk_every(2, 1, :discard)     # Make overlapping groups
    |> Stream.map(&create_boundedbox/1)       # Create Bounding Boxes
    |> Stream.map(&BoxServer.add/1)           # Save to BoxServer
    |> Stream.run                             # Execute Stream
  end



  @doc """
  Reads a CSV of coordinates, compares them against boxes
  previously stored and saves the point if it matches
  """
  def match_points!(file \\ @file_coordinates) do
    file
    |> File.stream!                           # Stream the file
    |> CSV.decode!                            # Parse as CSV
    |> Stream.drop(1)                         # Drop the header
    |> Stream.map(&parse_pair!/1)             # Convert to floats
    |> Stream.map(&Location.new/1)            # Convert to coordinates
    |> Stream.map(&PointMatcher.match/1)      # Match points against saved boxes
    |> Stream.run                             # Execute Stream
  end




  # Private Helpers
  # ---------------


  # Parse Floats
  defp parse_float!(string) do
    {num, ""} = Float.parse(string)
    num
  end

  # Parse a pair of lat/long floats
  defp parse_pair!([long, lat]) do
    {parse_float!(long), parse_float!(lat)}
  end

  # Convert coordinate list to boundedbox
  defp create_boundedbox([c1, c2]) do
    BoundedBox.new(c1, c2)
  end

end
