defmodule Duper.Worker do
  @moduledoc """
  Asks the `Duper.PathFinder` for a path, calculates the hash of the resulting
  file's contents, and passes the result to the gatherer.
  """

  use GenServer, restart: :transient

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :noargs)
  end

  # GenServer Callbacks

  def init(:noargs) do
    Process.send_after(self(), :do_one_file, 0)
    {:ok, nil}
  end

  def handle_info(:do_one_file, _) do
    add_result(Duper.PathFinder.next_path())
  end

  # Private functions

  defp add_result(nil) do
    Duper.Gatherer.done()
    {:stop, :normal, nil}
  end

  defp add_result(path) do
    Duper.Gatherer.result(path, hash_of_file_at(path))

    send(self(), :do_one_file)

    {:noreply, nil}
  end

  defp hash_of_file_at(path) do
    File.stream!(path, [], 1024 * 1024)
    |> Enum.reduce(
      :crypto.hash_init(:md5),
      fn block, hash ->
        :crypto.hash_update(hash, block)
      end
    )
    |> :crypto.hash_final()
  end
end
