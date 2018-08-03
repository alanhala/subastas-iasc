defmodule Auction do
  use GenServer
  defstruct id: nil, tags: [], current_price: 0, duration_seconds: 60, article: {},
            interested_buyers: [], winner: nil

  def start_link({id, tags, starting_price, duration_seconds, article}) do
    GenServer.start_link(
      __MODULE__,
      %Auction{id: id, tags: tags, current_price: starting_price, duration_seconds: duration_seconds, article: article},
      name: :"auction:#{id}"
    )
  end

  def register_bid(pid, buyer, price_offered) do
    GenServer.call(pid, {:register_bid, {buyer, price_offered}})
  end

  def init(auction) do
    Process.send_after(self(), {:finish}, auction.duration_seconds * 1000)
    {:ok, auction}
  end

  def handle_call({:register_bid, {buyer, price_offered}}, _from, auction) do
    auction =
      if price_offered > auction.current_price do
        GenServer.cast(
          {:global, BuyersRepository},
          {:notify_new_bid, {buyer, price_offered}}
        )
        %{ auction | current_price: price_offered, interested_buyers: [buyer | auction.interested_buyers], winner: buyer }
      else
        auction
      end
    {:reply, :ok, auction}
  end

  def handle_info({:finish}, auction) do
    GenServer.cast(
      {:global, BuyersRepository},
      {:notify_winner, {auction.winner, auction.current_price}}
    )
    losers = Enum.filter(auction.interested_buyers, fn buyer -> buyer != auction.winner end)
    Enum.each(
      losers,
      fn loser -> GenServer.cast({:global, BuyersRepository},{:notify_loser, loser}) end
    )
    Process.exit(self(), :shutdown)
  end
end
