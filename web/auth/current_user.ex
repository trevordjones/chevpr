defmodule Chevpr.CurrentUser do
  import Plug.Conn
  import Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = current_resource(conn)
    if current_user do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
    end
    conn
    |> assign(:current_user, current_user)
    |> assign(:user_token, token)
  end
end
