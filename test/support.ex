defmodule GeoBounds.Tests.Support do
  @moduledoc """
  Helper methods for the test suite
  """


  # Get state of a BEAM process
  def get_state(pid) do
    :sys.get_state(pid)
  end


  # Capture IO
  defdelegate capture_io(fun),  to: ExUnit.CaptureIO
  defdelegate capture_log(fun), to: ExUnit.CaptureLog

end
