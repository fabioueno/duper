defmodule Duper.PathFinder do
  @moduledoc """
  Responsible for returning the paths to each file in the directory tree.
  """

  use GenServer

  # API

  def start_link(root) do
    GenServer.start_link(__MODULE__, root, name: __MODULE__)
  end

  def next_path do
    GenServer.call(__MODULE__, :next_path)
  end

  # GenServer Callbacks

  def init(path) do
    DirWalker.start_link(path)
  end

  def handle_call(:next_path, _from, dir_walker) do
    path =
      case DirWalker.next(dir_walker) do
        [path] -> path
        other -> other
      end

    {:reply, path, dir_walker}
  end
end
