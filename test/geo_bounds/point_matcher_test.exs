defmodule GeoBounds.Tests.PointMatcher do
  use ExUnit.Case, async: false

  alias GeoBounds.BoxServer
  alias GeoBounds.Location
  alias GeoBounds.BoundedBox
  alias GeoBounds.PointMatcher
  alias GeoBounds.Tests.Support



  setup do
    BoxServer.start_link([])
    PointMatcher.start_link([])

    BoxServer.add(BoundedBox.new({0, 2},  {2, 0}))
    BoxServer.add(BoundedBox.new({4, 6},  {6, 4}))
    BoxServer.add(BoundedBox.new({8, 10}, {10, 8}))

    :ok
  end



  describe "#match" do
    @point Location.new(-5, -5)
    test "discards point if no matching boundingbox is found"  do
      assert %{} == Support.get_state(PointMatcher)
      assert :ok == PointMatcher.match(@point)
      assert %{} == Support.get_state(PointMatcher)
    end


    @point Location.new(1, 1)
    @box BoundedBox.new({0, 2},  {2, 0})
    test "saves point with bounding box if matches" do
      assert %{} == Support.get_state(PointMatcher)
      assert :ok == PointMatcher.match(@point)

      assert %{@point => @box} == Support.get_state(PointMatcher)
    end


    test "raises error for invalid value" do
      assert_raise FunctionClauseError, fn -> PointMatcher.match(:invalid) end
    end
  end



  describe "#list" do
    setup do
      PointMatcher.match(Location.new(1, 1))
      PointMatcher.match(Location.new(2, 2))
      PointMatcher.match(Location.new(3, 3))

      :ok
    end

    test "returns the internal map state of the process" do
      assert Support.get_state(PointMatcher) == PointMatcher.list
    end
  end

end

