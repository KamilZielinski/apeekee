defmodule Apeekee.MixProject do
  use Mix.Project

  def project do
    [
      app: :apeekee,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "1.4.10", only: :test},
      # https://github.com/pma/amqp/issues/99#issuecomment-404780165
      {:ranch_proxy_protocol, github: "heroku/ranch_proxy_protocol", override: true},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
