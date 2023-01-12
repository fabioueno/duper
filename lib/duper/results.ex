defmodule Duper.Results do
  @moduledoc """
  Holds the results of the scanning in memory.
  """

  use GenServer

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def add_hash_for(path, hash) do
    GenServer.cast(__MODULE__, {:add, path, hash})
  end

  def find_duplicates do
    GenServer.call(__MODULE__, :find_duplicates)
  end

  # GenServer Callbacks

  def init(:no_args) do
    {:ok, %{}}
  end

  def handle_cast({:add, path, hash}, results) do
    results = Map.update(results, hash, [path], fn existing -> [path | existing] end)
    {:noreply, results}
  end

  def handle_call(:find_duplicates, _from, results) do
    {:reply, hashes_with_more_than_one_path(results), results}
  end

  # Private functions

  defp hashes_with_more_than_one_path(results) do
    results
    |> Enum.filter(fn {_hash, paths} -> length(paths) > 1 end)
    |> Enum.map(&elem(&1, 1))
  end
end
