defmodule Kanban.ProcessTest do
  use ExUnit.Case
  doctest Kanban.Process

  test "+" do
    {:ok, _pid} = Kanban.Process.start_link(10)
    v1 = GenServer.call(Kanban.Process, {:+, 1})
    assert 11 = v1
    v2 = GenServer.call(Kanban.Process, {:+, 4})
    assert 15 = v2
  end
end
