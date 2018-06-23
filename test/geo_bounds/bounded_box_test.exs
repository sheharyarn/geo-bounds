defmodule GeoBounds.Tests.BoundedBox do
  use ExUnit.Case, async: true

  alias GeoBounds.Location
  alias GeoBounds.BoundedBox


  describe "#new" do
    test "raises error for invalid data" do
      assert_raise BoundedBox.InvalidData, fn ->
        BoundedBox.new("xyz", 40)
      end

      assert_raise BoundedBox.InvalidData, fn ->
        BoundedBox.new(%Location{longitude: 15, latitude: 42}, {17, 40})
      end
    end


    @top_right   %Location{longitude: 78, latitude: 34}
    @bottom_left %Location{longitude: 75, latitude: 32}
    test "returns a bounded_box struct for valid coordinates" do
      assert box = %BoundedBox{} = BoundedBox.new(@top_right, @bottom_left)

      assert box.top    == @top_right.latitude
      assert box.right  == @top_right.longitude
      assert box.bottom == @bottom_left.latitude
      assert box.left   == @bottom_left.longitude
    end


    @top_right   {78, 34}
    @bottom_left {75, 32}
    test "works for coordinates in tuple form" do
      {right, top}   = @top_right
      {left, bottom} = @bottom_left

      assert box = %BoundedBox{} = BoundedBox.new(@top_right, @bottom_left)

      assert box.top    == top
      assert box.right  == right
      assert box.bottom == bottom
      assert box.left   == left
    end
  end



  describe "#inside?" do
    setup do
      top_right   = Location.new(48.819864, 2.481386)
      bottom_left = Location.new(48.799860, 2.461385)

      [box: BoundedBox.new(top_right, bottom_left)]
    end


    @point Location.new(48.803260, 2.479775)
    test "returns true if the point lies inside the box", %{box: box} do
      assert BoundedBox.inside?(box, @point)
    end


    @point Location.new(48.847172, 2.386597)
    test "returns false if the point lies outside the box", %{box: box} do
      refute BoundedBox.inside?(box, @point)
    end
  end

end
