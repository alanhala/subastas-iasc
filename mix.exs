defmodule Subastas.MixProject do
  use Mix.Project

  def project do
    [
      app: :subastas,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:maru],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:maru, "~> 0.13"},
      {:jason, "~> 1.0"},
      {:cowboy, "~> 2.3"},
    ]
  end
end
