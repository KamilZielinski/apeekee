defmodule Apeekee.Key do
  @header_name Application.get_env(:apeekee, :apeekee_header_name)
  @key_length Application.get_env(:apeekee, :apeekee_key_length)

  def get_auth_key(conn) do
    case extract_key(conn) do
      {:ok, key} -> {:ok, key}
      {:error, error} -> {:error, error}
    end
  end

  def generate_key() do
    :crypto.strong_rand_bytes(@key_length)
    |> Base.url_encode64()
    |> binary_part(0, @key_length)
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
