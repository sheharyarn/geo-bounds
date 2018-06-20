defmodule GeoBounds.Tests.Support do
  @moduledoc """
  Helper methods for the test suite
  """


  # Get state of a BEAM process
  def get_state(pid) do
    :sys.get_state(pid)
  end

end
