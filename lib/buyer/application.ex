defmodule Buyer.Application do
  use Application

  def start(start_type, start_args) do
    BuyersRepository.start_link([])
  end
end
