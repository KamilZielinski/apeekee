defprotocol Apeekee.Auth do
  @doc """
  Authenticate by token and return the user
  """
  def auth_by_token(conn, token)

  @doc """
  Executed on succesfully verified token along with user
  """
  def on_success(conn, user)

  @doc """
  Executed on failure if token doesn't exist or is invalid
  """
  def on_failure(conn)
end
