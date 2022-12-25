defmodule Kanban.KVStore do
  @moduledoc """
  KVStore is the key => value store
  Available methods:
  - insert key with value
  - update value by key
  - request the value of a specific key
  - delete a specific key and its value
  """

  @doc """

  ## Examples

      iex> Kanban.KVStore.start_link(%{})
      iex> GenServer.call(Kanban.KVStore, {:insert, "hello", "world"})
      %{"hello" => "world"}
      iex> GenServer.call(Kanban.KVStore, {:insert, "hello", "world"})
      "The key already exists"
      iex> GenServer.call(Kanban.KVStore, {:update, "hello", "updated world"})
      %{"hello" => "updated world"}
      iex> GenServer.call(Kanban.KVStore, {:update, "h", "w"})
      "Key not found"
      iex> GenServer.call(Kanban.KVStore, {:get, "hello"})
      "updated world"
      iex> GenServer.call(Kanban.KVStore, {:get, "h"})
      nil
      iex> GenServer.call(Kanban.KVStore, {:delete, "hello"})
      %{}
      iex> GenServer.call(Kanban.KVStore, {:delete, "hello"})
      "Key not found"

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
  def handle_call({:insert, key, value}, _from, state) do
    case Map.fetch(state, key) do
      {:ok, _} ->
        {:reply, "The key already exists", state}

      :error ->
        state = Map.put(state, key, value)
        {:reply, state, state}
    end
  end

  @impl GenServer
  def handle_call({:update, key, value}, _from, state) do
    case Map.fetch(state, key) do
      {:ok, _} ->
        state =
          Map.update(
            state,
            key,
            value,
            fn _ -> value end
          )

        {:reply, state, state}

      :error ->
        {:reply, "Key not found", state}
    end
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl GenServer
  def handle_call({:delete, key}, _from, state) do
    case Map.fetch(state, key) do
      {:ok, _} ->
        state = Map.delete(state, key)
        {:reply, state, state}

      :error ->
        {:reply, "Key not found", state}
    end
  end
end
