defmodule API.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug(:dispatch)

  post "/auctions" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body)
    id = System.system_time
    {result, _} = Balancer.create_auction(id, body)
    IO.inspect(result)
    if result == :ok do
      GenServer.cast({:global, BuyersRepository}, {:notify_new_auction, body["tags"]})
      send_resp(conn, 201, "created: #{id}")
    else
      send_resp(conn, 201, "error")
    end
  end

  post "/buyers" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body)
    id = System.system_time
    result = Balancer.create_buyer(id, body)
    IO.inspect(result)
    if result == :ok do
      send_resp(conn, 201, "created: #{id}")
    else
      send_resp(conn, 201, "error")
    end
  end

  put "/auctions/:auction_id/bid" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body)
    result = Balancer.bid(auction_id, body["price_offered"], body["buyer_id"])
    IO.inspect(result)
    case result do
      {:error, message} -> send_resp(conn, 200, "#{message}")
      :ok -> send_resp(conn, 200, "ok")
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
