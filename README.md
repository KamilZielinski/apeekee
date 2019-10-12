# Apeekee

Apeekee is a library that helps you create and verify API keys via headers

## Installation

Add globally to `config.exs` or configuration per environment

```elixir
...
config :apeekee,
  apeekee_header_name: "X-AUTH-KEY",
  apeekee_length: 45
...
```

This library requires you only to create a protocol's implementation eg.
```elixir
  defimpl Apeekee.Auth, for: Plug.Conn do
    import Plug.Conn
    alias MyApp.Accounts

    def auth_by_key(_conn, key) do
      case Accounts.get_user_by_key(key) do
        {:ok, key} -> {:ok, key}
        _ -> {:error, "Couldn't get key"}
      end
    end

    def on_success(conn, user) do
      assign(conn, :client, user)
    end

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
