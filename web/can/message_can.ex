defmodule Chevpr.MessageCan do
  def can?({channel_id, _}, user_id) do
    user_channel =
      Chevpr.UserChannel.by_user_channel(channel_id, user_id)
      |> Chevpr.Repo.one()

    if user_channel, do: true, else: false
  end
end
