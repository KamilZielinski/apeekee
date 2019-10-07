defmodule Apeekee.Plug do
  import Plug.Conn
  alias Apeekee.Key
  alias Apeekee.Auth

  def init(_), do: []

  def call(conn, _) do
    case Key.get_auth_key(conn) do
      {:ok, key} ->
        case Auth.auth_by_key(conn, key) do
          {:ok, user} -> Auth.on_success(conn, user)
          {:error, error} -> Auth.on_failure(conn, error)
        end

      {:error, error} ->
        Auth.on_failure(conn, error)
    end
  end
end
