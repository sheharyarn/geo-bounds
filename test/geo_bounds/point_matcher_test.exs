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
      Support.capture_log fn ->
        assert %{} == Support.get_state(PointMatcher)
        assert nil == PointMatcher.match(@point)
        assert %{} == Support.get_state(PointMatcher)
      end
    end


    @point Location.new(1, 1)
    @box BoundedBox.new({0, 2},  {2, 0})
    test "saves point with bounding box if matches" do
      Support.capture_log fn ->
        assert %{}  == Support.get_state(PointMatcher)
        assert @box == PointMatcher.match(@point)

        assert %{@point => @box} == Support.get_state(PointMatcher)
      end
    end


    @p1 Location.new(1, 1)
    @p2 Location.new(3, 3)
    @b1 BoundedBox.new({0, 2}, {2, 0})
    @b2 nil
    test "works for origin, destination pairs" do
      Support.capture_log fn ->
        assert {b1, b2} = PointMatcher.match(@p1, @p2)
        assert b1 == @b1
        assert b2 == @b2
      end
    end


    test "raises error for invalid value" do
      assert_raise FunctionClauseError, fn -> PointMatcher.match(:invalid) end
    end
  end



  describe "#list" do
    setup do
      Support.capture_log fn ->
        PointMatcher.match(Location.new(1, 1))
        PointMatcher.match(Location.new(2, 2))
        PointMatcher.match(Location.new(3, 3))
      end

      :ok
    end

    test "returns the internal map state of the process" do
      Support.capture_log fn ->
        assert Support.get_state(PointMatcher) == PointMatcher.list
      end
    end
  end

end

