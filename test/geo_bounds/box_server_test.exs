defmodule GeoBounds.Tests.BoxServer do
  use ExUnit.Case, async: true

  alias GeoBounds.BoxServer
  alias GeoBounds.BoundedBox
  alias GeoBounds.Tests.Support


  setup do
    {:ok, pid} = BoxServer.start_link
    %{pid: pid}
  end


  describe "#add" do
    @box %BoundedBox{top: 1, bottom: 2, left: 3, right: 4}
    test "adds the boundedbox to the state list", %{pid: pid} do
      assert []     == Support.get_state(pid)
      assert :ok    == BoxServer.add(@box)
      assert [@box] == Support.get_state(pid)
    end
  end

end
