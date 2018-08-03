defmodule Balancer do
  def auction_supervisors_nodes do
    Enum.filter(Node.list, fn node -> Regex.match?(~r/auction_supervisor/,Atom.to_string(node)) end)
  end

  def create_auction(id, auction) do
    node = auction_supervisors_nodes() |> List.first
    :rpc.call(
      node,
      Auction.Supervisor,
      :start_child,
      [{id, auction["tags"], auction["starting_price"], auction["duration_seconds"], auction["article"]}]
    )
  end

  def create_buyer(id, buyer) do
    GenServer.call({:global, BuyersRepository}, {:add, {id, buyer["name"], buyer["ip"], buyer["interested_tags"]}})
  end

  def bid(auction_id, price_offered, buyer_id) do
    pids = Enum.map(
      auction_supervisors_nodes(),
      fn node -> :rpc.call(node, Process, :whereis, [:"auction:#{auction_id}"]) end
    )
    pid = Enum.find(pids, fn pid -> pid != nil end)
    if (pid == nil) do
      {:error, "The auction does not exist"}
    else
      Auction.register_bid(pid, buyer_id, price_offered)
    end
  end
end
