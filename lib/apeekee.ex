defmodule Apeekee.Plug do
  alias Apeekee.KeyVerifier
  alias Apeekee.Auth

  def init(_), do: []

  def call(conn, _) do
    case KeyVerifier.get_auth_token(conn) do
      {:ok, token} ->
        case Auth.auth_by_token(conn, token) do
          nil -> Auth.on_failure(conn)
          user -> Auth.on_success(conn, user)
        end

      _ ->
        Auth.on_failure(conn)
    end
  end
end
