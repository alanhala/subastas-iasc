defmodule Auction.Supervisor do
  use DynamicSupervisor

  def start_link(init_args) do
    DynamicSupervisor.start_link(__MODULE__, [init_args], name: __MODULE__)
  end

  def start_child(child_args) do
    child_spec = %{
      id: Auction,
      start: {Auction, :start_link, [child_args]},
      restart: :transient,
      shutdown: :brutal_kill,
      type: :worker,
      modules: [Auction],
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def init([init_args]) do
    DynamicSupervisor.init(max_children: 10, strategy: :one_for_one)
  end
end
