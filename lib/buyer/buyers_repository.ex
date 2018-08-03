defmodule BuyersRepository do
  use GenServer

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, [init_args], name: {:global, __MODULE__})
  end

  def init(_args) do
    {:ok, []}
  end

  def handle_call({:add, {id, name, ip, interested_tags}}, _from, buyers) do
    buyer = %Buyer{id: id, name: name, ip: ip, interested_tags: interested_tags}
    {:ok, buyer_pid} = Buyer.start_link(buyer)
    new_buyer = %{ buyer_pid: buyer_pid, buyer: buyer }
    buyers = [new_buyer | buyers]
    {:reply, :ok, buyers}
  end

  def handle_cast({:notify_new_auction, tags}, buyers) do
    interested_buyers = Enum.filter(buyers, fn buyer -> Buyer.is_interested_in?(buyer[:buyer], tags) end)
    Enum.each(interested_buyers, fn buyer -> Buyer.new_auction_created(buyer[:buyer_pid]) end)
    {:noreply, buyers}
  end

  def handle_cast({:notify_winner, {buyer_id, price}}, buyers) do
    IO.puts("I'm the winner: #{buyer_id}. I have to pay #{price}")
    {:noreply, buyers}
  end

  def handle_cast({:notify_loser, buyer_id}, buyers) do
    IO.puts("I'm a loser: #{buyer_id}")
    {:noreply, buyers}
  end

  def handle_cast({:notify_new_bid, {buyer_id, price}}, buyers) do
    IO.puts("The buyer: #{buyer_id}, made a new bid: #{price}")
    {:noreply, buyers}
  end
end
