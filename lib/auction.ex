defmodule Auction do
  use GenServer
  defstruct tags: [], current_price: 0, duration_seconds: 60, article: {}

  def start_link(tags, starting_price, duration_seconds, article) do
    # you may want to register your server with `name: __MODULE__`
    # as a third argument to `start_link`
    GenServer.start_link(
      __MODULE__,
      %Auction{tags: tags, current_price: starting_price, duration_seconds: duration_seconds, article: article}
    )
  end

  def has_tag?(auction, tag) do
    Enum.member?(auction.tags, tag)
  end

  def register_bid(pid, buyer, price_offered) do
    GenServer.cast(pid, {:register_bid, buyer, price_offered})
  end

  def init(auction) do
    {:ok, auction}
  end

  def handle_cast({:register_bid, _buyer, price_offered}, auction) do
    auction =
      if price_offered > auction.current_price do
        %{ auction | current_price: price_offered }
        # NOTIFY NEW BID
      else
        auction
      end
    {:noreply, auction}
  end
end
