defprotocol Apeekee.Auth do
  @doc """
  Authenticate by key and return the user
  """
  def auth_by_key(conn, key)

  @doc """
  Executed on succesfully verified key
  """
  def on_success(conn, user)

  @doc """
  Executed on failure if key doesn't exist or is invalid
  """
  def on_failure(conn, error)
end
