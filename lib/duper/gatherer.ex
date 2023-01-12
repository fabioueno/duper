defmodule Duper.Gatherer do
  @moduledoc """
  The server that both starts and determines when things have completed. When
  they do, it fetches the results and reports on them.
  """

  use GenServer

  # API

  def start_link(worker_count) do
    GenServer.start_link(__MODULE__, worker_count, name: __MODULE__)
  end

  def done do
    GenServer.cast(__MODULE__, :done)
  end

  def result(path, hash) do
    GenServer.cast(__MODULE__, {:result, path, hash})
  end

  # GenServer Callbacks

  def init(worker_count) do
    Process.send_after(self(), :kickoff, 0)
    {:ok, worker_count}
  end

  def handle_cast(:done, _worker_count = 1) do
    report_results()
    System.halt(0)
  end

  def handle_cast(:done, worker_count) do
    {:noreply, worker_count - 1}
  end

  def handle_cast({:result, path, hash}, worker_count) do
    Duper.Results.add_hash_for(path, hash)
    {:noreply, worker_count}
  end

  def handle_info(:kickoff, worker_count) do
    Enum.each(1..worker_count, fn _ -> Duper.WorkerSupervisor.add_worker() end)
    {:noreply, worker_count}
  end

  # Private functions

  defp report_results do
    IO.puts("Results:\n")
    Enum.each(Duper.Results.find_duplicates(), &IO.inspect/1)
  end
end
