defmodule API.Application do
  use Application

  def start(_type, _args) do
    Plug.Adapters.Cowboy2.http(API.Router, [], port: 3000)
  end
end
