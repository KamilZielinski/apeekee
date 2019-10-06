defmodule Apeekee.Token do
  @seed Application.get_env(:apeekee, :session_signing_seed_name)
  @secret Application.get_env(:apeekee, :session_signing_secret)
  @duration Application.get_env(:apeekee, :session_signing_duration_seconds)
  @header_name Application.get_env(:apeekee, :apeekee_header_name)

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      {:error, error} -> {:error, error}
    end
  end

  def generate_token(id) do
    Phoenix.Token.sign(@secret, @seed, id, max_age: @duration)
  end

  defp verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token, max_age: @duration) do
      {:ok, _id} -> {:ok, token}
      error -> {:error, error}
    end
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, String.downcase(@header_name)) do
      [auth_header] -> token_not_empty?(auth_header)
      _ -> {:error, "Missing auth header"}
    end
  end

  defp token_not_empty?(auth_header_value) do
    if String.trim(auth_header_value) != "" do
      {:ok, auth_header_value}
    else
      {:error, "API Key not found"}
    end
  end
end
