defimpl Apeekee.Auth, for: Plug.Conn do
  def on_success(conn, user) do
    conn
  end

  def on_failure(conn, error) do
    conn
  end

  def auth_by_key(conn, key) do
    conn
  end
end
