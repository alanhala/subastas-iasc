defmodule Buyer do
  use GenServer
  defstruct name: nil, ip: nil, interested_tags: []

  def start_link(name, ip, interested_tags) do
    # you may want to register your server with `name: __MODULE__`
    # as a third argument to `start_link`
    GenServer.start_link(__MODULE__, %Buyer{name: name, ip: ip, interested_tags: interested_tags})
  end

  def notify_new_bid(pid) do
    GenServer.cast(pid, {:new_bid})
  end

  def is_interested_in?(buyer, auction) do
    Enum.any?(buyer.interested_tags, fn interested_tag ->  Auction.has_tag?(auction, interested_tag) end)
  end

  def init(buyer) do
    {:ok, buyer}
  end

  def handle_cast({:new_bid}, buyer) do
    IO.puts "New bid received"
    {:noreply, buyer}
  end
end
