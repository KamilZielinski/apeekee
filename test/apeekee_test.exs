defmodule ApeekeeTest do
  use ExUnit.Case
  use ExUnit.CaseTemplate
  use Phoenix.ConnTest
  doctest Apeekee.Key

  test "key is generated with proper length" do
    assert Apeekee.Key.generate_key() |> String.length() == 45
  end

  test "key is properly extracted from the header" do
    key = Apeekee.Key.generate_key()

    req =
      build_conn()
      |> put_req_header("x-auth-token", key)

    assert Apeekee.Key.get_auth_key(req) == {:ok, key}
  end
end
