defmodule Kanban.Process do
  @moduledoc """
  Process to be run
  """

  use GenServer

  @doc false
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:+, value}, _from, state) when is_number(value) do
    state = state + value
    # IO.inspect({msg, from, state}, label: "CALL")
    {:reply, state, state}
  end
end
