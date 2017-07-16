defmodule Chevpr.ChatChannel do
  use Chevpr.Web, :channel
  alias Chevpr.Message

  def join("channels:" <> channel_id, _params, socket) do
    {:ok, assign(socket, :channel_id, String.to_integer(channel_id))}
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Chevpr.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_message", params, user, socket) do
    new_params = Map.put(params, "user_id", user.id)
    changeset = Message.changeset(%Message{}, new_params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast! socket, "new_message", %{
          text: message.text,
          channel_id: message.channel_id,
          user: Chevpr.UserView.render("user.json", %{user: user})
        }
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end

  end
end
