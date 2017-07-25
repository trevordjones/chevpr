defmodule Chevpr.InviteController do
  use Chevpr.Web, :controller
  alias Chevpr.{UserChannel, User}

  def update(conn, %{"id" => id, "invite" => %{"email" => email}}) do
    user = User.find_by_email(email) |> Repo.one
    if user do
      changeset = UserChannel.changeset(%UserChannel{}, %{user_id: user.id, channel_id: id})
      case Repo.insert(changeset) do
        {:ok, _} ->
          render(conn, "success.json", email: email)
        {:error, changeset} ->
          put_status(conn, 422)
          |> render(Chevpr.ErrorView, "422.json", errors: changeset.errors)
      end
    else
      put_status(conn, 422)
      |> render(Chevpr.ErrorView, "422.json", errors: "User does not exist")
    end
  end
end
