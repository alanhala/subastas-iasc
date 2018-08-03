defmodule Auction.Application do
  use Application

  def start(start_type, start_args) do
    Auction.Supervisor.start_link([])
  end
end
