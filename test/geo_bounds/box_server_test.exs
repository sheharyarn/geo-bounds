defmodule GeoBounds.Tests.BoxServer do
  use ExUnit.Case, async: false

  alias GeoBounds.BoxServer
  alias GeoBounds.Coordinate
  alias GeoBounds.BoundedBox
  alias GeoBounds.Tests.Support



  setup do
    {:ok, pid} = BoxServer.start_link([])
    %{pid: pid}
  end



  describe "#add" do
    @box %BoundedBox{top: 1, bottom: 2, left: 3, right: 4}
    test "adds the boundedbox to the state list", %{pid: pid} do
      assert []     == Support.get_state(pid)
      assert :ok    == BoxServer.add(@box)
      assert [@box] == Support.get_state(pid)
    end


    test "raises error for invalid value" do
      assert_raise FunctionClauseError, fn -> BoxServer.add(:invalid) end
    end
  end



  describe "#find" do
    setup(context) do
      box_1 = BoundedBox.new({0, 2}, {2, 0})
      box_2 = BoundedBox.new({4, 6}, {6, 4})

      BoxServer.add(box_1)
      BoxServer.add(box_2)

      Map.put(context, :box, box_2)
    end


    @point Coordinate.new(5, 5)
    test "returns a box if given point is inside one", %{box: box} do
      assert BoxServer.find(@point) == box
    end


    @point Coordinate.new(10, 10)
    test "returns nil if point isn't inside any box" do
      refute BoxServer.find(@point)
    end
  end


end
