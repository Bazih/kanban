defmodule Kanban.KVStore do
  @moduledoc """
  KVStore is the key => value store
  Available methods:
  - insert key with value
  - update value by key
  - request the value of a specific key
  - delete a specific key and its value
  """

  # @doc """

  # ## Examples

  #     iex> Kanban.KVStore.start_link(%{})
  #     iex> GenServer.call(Kanban.KVStore, {:get, "hello"})
  #     "Key not found"
  #     iex> GenServer.cast(Kanban.KVStore, {:insert, "hello", "world"})
  #     :ok
  #     iex> GenServer.call(Kanban.KVStore, {:get, "hello"})
  #     "world"
  #     iex> GenServer.cast(Kanban.KVStore, {:update, "hello", "updated world"})
  #     :ok
  #     iex> GenServer.call(Kanban.KVStore, {:get, "hello"})
  #     "updated world"
  #     iex> GenServer.cast(Kanban.KVStore, {:update, "h", "w"})
  #     :ok
  #     iex> GenServer.call(Kanban.KVStore, {:get, "h"})
  #     "Key not found"
  #     iex> GenServer.cast(Kanban.KVStore, {:delete, "hello"})
  #     :ok
  #     iex> GenServer.call(Kanban.KVStore, {:get, "hello"})
  #     "Key not found"

  # """

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
  def handle_cast({:delete, key}, state) do
    state = Map.delete(state, key)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:insert, key, value}, state) do
    case Map.fetch(state, key) do
      {:ok, _} ->
        {:noreply, state}

      :error ->
        state = Map.put(state, key, value)
        {:noreply, state}
    end
  end

  @impl GenServer
  def handle_cast({:update, key, value}, state) do
    case Map.fetch(state, key) do
      {:ok, _} ->
        state =
          Map.update!(
            state,
            key,
            fn _ -> value end
          )

        {:noreply, state}

      :error ->
        {:noreply, state}
    end
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    Map.fetch(state, key)

    case Map.fetch(state, key) do
      {:ok, _} ->
        {:reply, Map.get(state, key), state}

      :error ->
        {:reply, "Key not found", state}
    end
  end
end
