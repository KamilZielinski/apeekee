# Apeekee

Apeekee is a library that helps you create and verify API keys via headers. It heavily depends on Phoenix's `Token` module.

## Installation

Add globally to `config.exs` or configuration per environment

```elixir
...
config :apeekee,
  session_signing_seed_name: "key_seed",
  # generate new secret with mix phx.gen.secret
  session_signing_secret: "mIoVfweA9Mhxu3hOhPTD/wbt/pwHb3NyM6yKOB/iuhjDyVsvumTtGte+wK2QELdA",
  session_signing_duration_seconds: 200_000,
  apeekee_header_name: "X-AUTH-KEY"
...
```

This library requires you only to create a protocol's implementation eg.
```elixir
  defimpl Apeekee.Auth, for: Plug.Conn do
    import Plug.Conn
    alias MyApp.Accounts

    @impl
    def auth_by_key(_conn, key) do
      case Accounts.get_user_by_key(key) do
        {:ok, key} -> {:ok, key}
        _ -> {:error, "Couldn't get key"}
      end
    end

    @impl
    def on_success(conn, user) do
      assign(conn, :client, user)
    end

    @impl
    def on_failure(conn) do
      send_resp(conn, 401, "") |> halt()
    end
  end
```

In your `router.ex` file add new pipeline called eg. `:authenticate`
```elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :authenticate do
    plug Apeekee.Plug
  end
  ...
```

and add it whenever you want in your `routes.ex` file to confirm if key is valid with `pipe_through :authenticate`

```elixir
  ...
  scope "/users" do
    pipe_through :authenticate

    post "/", UsersController, :create
    get "/:id", UsersController, :show
  end
  ...
```

## License

Apeekee is released under the MIT License - see the [LICENSE](LICENSE) file.
