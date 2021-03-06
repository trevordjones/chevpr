defmodule Chevpr.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Chevpr.User
  alias Chevpr.Repo

  def login(conn, user) do
    User.changeset(user, %{sign_in_count: user.sign_in_count + 1})
    |> Repo.update

    conn
    |> Guardian.Plug.sign_in(user)
  end

  def login_by_email_and_pass(conn, email, given_pass) do
    user = Repo.get_by(User, email: email)
    cond do
      user && checkpw(given_pass || "", user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end
