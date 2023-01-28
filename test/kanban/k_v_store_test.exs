defmodule Kanban.KVStoreTest do
  use ExUnit.Case
  doctest Kanban.KVStore

  test ":get, when requested key does not exist" do
    {:ok, _pid} = Kanban.KVStore.start_link(%{})
    result = GenServer.call(Kanban.KVStore, {:get, "hello"})
    assert "Key not found" = result
  end

  test ":get, when requested key exists" do
    {:ok, _pid} = Kanban.KVStore.start_link(%{"hello" => "world"})
    result = GenServer.call(Kanban.KVStore, {:get, "hello"})
    assert "world" = result
  end

  test ":insert, when the key to be inserted is not found" do
    {:ok, _pid} = Kanban.KVStore.start_link(%{})
    GenServer.cast(Kanban.KVStore, {:insert, "test", "happy"})
    result = GenServer.call(Kanban.KVStore, {:get, "test"}) 
    assert "happy" = result
  end

  test ":insert, when the inserted key is found" do
    {:ok, _pid} = Kanban.KVStore.start_link(%{"hello" => "world"})
    GenServer.cast(Kanban.KVStore, {:insert, "hello", "new world"})
    result = GenServer.call(Kanban.KVStore, {:get, "hello"}) 
    assert "world" = result
  end

  test ":update, when the key to be updated is not found" do
    {:ok, _pid} = Kanban.KVStore.start_link(%{})
    GenServer.cast(Kanban.KVStore, {:update, "hello", "world"})
    result = GenServer.call(Kanban.KVStore, {:get, "hello"})
    assert "Key not found" = result
  end

  test ":update, when the updated key is found" do
    {:ok, _pid} = Kanban.KVStore.start_link(%{"hello" => "world"})
    GenServer.cast(Kanban.KVStore, {:update, "hello", "updated world"})
    result = GenServer.call(Kanban.KVStore, {:get, "hello"})
    assert "updated world" = result
  end

  test ":delete, when the key to be deleted does not exist" do
    {:ok, _pid} = Kanban.KVStore.start_link(%{})
    GenServer.cast(Kanban.KVStore, {:delete, "hello"})
    result = GenServer.call(Kanban.KVStore, {:get, "hello"})
    assert "Key not found" = result
  end

  test ":delete, when the key to be deledet exists" do
    {:ok, _pid} = Kanban.KVStore.start_link(%{"hello" => "world"})
    GenServer.cast(Kanban.KVStore, {:delete, "hello"})
    result = GenServer.call(Kanban.KVStore, {:get, "hello"})
    assert "Key not found" = result
  end
end
