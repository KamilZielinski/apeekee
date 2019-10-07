defmodule Apeekee.Key do
  @seed Application.get_env(:apeekee, :session_signing_seed_name)
  @secret Application.get_env(:apeekee, :session_signing_secret)
  @duration Application.get_env(:apeekee, :session_signing_duration_seconds)
  @header_name Application.get_env(:apeekee, :apeekee_header_name)

  def get_auth_key(conn) do
    case extract_key(conn) do
      {:ok, key} -> verify_key(key)
      {:error, error} -> {:error, error}
    end
  end

  def generate_key(id) do
    Phoenix.Token.sign(@secret, @seed, id, max_age: @duration)
  end

  defp verify_key(key) do
    case Phoenix.Token.verify(@secret, @seed, key, max_age: @duration) do
      {:ok, _id} -> {:ok, key}
      error -> {:error, error}
    end
  end

  defp extract_key(conn) do
    case Plug.Conn.get_req_header(conn, String.downcase(@header_name)) do
      [auth_header] -> key_not_empty?(auth_header)
      _ -> {:error, "Missing auth header"}
    end
  end

  defp key_not_empty?(auth_header_value) do
    if String.trim(auth_header_value) != "" do
      {:ok, auth_header_value}
    else
      {:error, "API Key not found"}
    end
  end
end
