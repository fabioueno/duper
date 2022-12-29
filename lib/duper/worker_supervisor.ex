defmodule Duper.WorkerSupervisor do
  use DynamicSupervisor

  # API

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def add_worker do
    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, Duper.Worker)
  end

  # Server

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end