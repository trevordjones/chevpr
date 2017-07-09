defmodule Chevpr.UserController do
  use Chevpr.Web, :controller
  alias Chevpr.User

  plug :scrub_params, "user" when action in ~w(create update)a

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def show(conn, %{"id" => id}, _current_user) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params, _current_user) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}, _current_user) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Chevpr.Auth.login(user)
        |> put_flash(:info, "Welcome to Chevpr!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _params, current_user) do
    changeset = User.changeset(current_user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}, current_user) do
    changeset =
      if user_params["password"] do
        User.registration_changeset(current_user, user_params)
      else
        User.changeset(current_user, user_params)
      end

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:success, "Changes saved!")
        |> redirect(to: user_path(conn, :edit, current_user))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
