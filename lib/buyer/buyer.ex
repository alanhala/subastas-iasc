defmodule Buyer do
  use GenServer
  defstruct id: nil, name: nil, ip: nil, interested_tags: []

  def start_link(buyer) do
    GenServer.start_link(__MODULE__, buyer)
  end

  def new_auction_created(pid) do
    GenServer.cast(pid, {:new_auction_created})
  end

  def is_interested_in?(buyer, tags) do
    Enum.any?(buyer.interested_tags, fn interested_tag ->  Enum.member?(tags, interested_tag) end)
  end

  def init(buyer) do
    {:ok, buyer}
  end

  def handle_cast({:new_auction_created}, buyer) do
    IO.puts "HMMM new auction. Nice!"
    {:noreply, buyer}
  end
end
