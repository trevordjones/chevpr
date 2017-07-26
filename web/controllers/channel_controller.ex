defmodule Chevpr.ChannelController do
  use Chevpr.Web, :controller
  alias Chevpr.{Channel, Message, UserCan}

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    channels =
      Channel.by_owner(current_user)
      |> Channel.ordered
      |> Repo.all
    render(conn, "index.html", channels: channels)
  end

  def show(conn, %{"id" => id}, current_user) do
    channel = Repo.get(Channel, id) |> Repo.preload(:users)
    if UserCan.can?(current_user, channel.users) do
      messages =
        Message.channel_messages(channel)
        |> Repo.all
      render(conn, "show.html", channel: channel, messages: messages)
    else
      conn
      |> put_flash(:warning, "You must first be invited to join that channel")
      |> redirect(to: channel_path(conn, :index))
    end
  end

  def create(conn, %{"channel" => channel_params}, current_user) do
    changeset = Channel.changeset(%Channel{}, channel_params)

    case Repo.insert(changeset) do
      {:ok, channel} ->
        channel
        |> Repo.preload(:users)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:users, [current_user])
        |> Repo.update!
        render(conn, "create.json", channel: channel)
      {:error, changeset} ->
        put_status(conn, 422)
        |> render(Chevpr.ErrorView, "422.json", errors: changeset.errors)
    end
  end
end
