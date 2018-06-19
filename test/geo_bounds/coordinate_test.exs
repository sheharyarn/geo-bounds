defmodule GeoBounds.Tests.Coordinate do
  use ExUnit.Case, async: true
  alias GeoBounds.Coordinate


  describe "#new" do
    @valid {-73.974, 40.764}
    test "unpacks two item tuples as coordinates" do
      assert %Coordinate{} = Coordinate.new(@valid)
    end


    @valid %{long: -73.974, lat: 40.764}
    test "returns a coordinate struct for valid values" do
      assert coord = %Coordinate{} = Coordinate.new(@valid.long, @valid.lat)
      assert coord.longitude == @valid.long
      assert coord.latitude == @valid.lat
    end


    test "raises error for invalid data types" do
      assert_raise Coordinate.InvalidData, fn -> Coordinate.new("long", 40) end
      assert_raise Coordinate.InvalidData, fn -> Coordinate.new(17, :lat) end
    end


    test "raises error if values are out of range" do
      assert_raise Coordinate.InvalidData, fn -> Coordinate.new(0, -95) end
      assert_raise Coordinate.InvalidData, fn -> Coordinate.new(185, 0) end
    end
  end

end
