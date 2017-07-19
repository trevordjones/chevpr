defmodule Chevpr.MessageView do
  use Chevpr.Web, :view

  def to_json(messages) do
    group_messages(messages) |> Poison.encode!
  end

  def group_messages([h | t]) do
    email = h.user.email
    [Map.put(%{email: email}, :messages, [render_json(h)] ++ render_messages(h.user.email, t))] ++ group_messages(email, t)
  end

  def group_messages(email, [h | t]) do
    if email != h.user.email do
      group_messages([h | t])
    else
      group_messages(h.user.email, t)
    end
  end

  def group_messages(email, []), do: []

  def group_messages([]), do: []

  def render_messages(email, [h | t]) do
    if email == h.user.email do
      [render_json(h)] ++ render_messages(email, t)
    else
      []
    end
  end

  def render_messages(email, []), do: []

  def render_json(message) do
    %{
      id: message.id,
      text: message.text,
      user: Chevpr.UserView.render("user.json", %{user: message.user}),
      inserted_at: message.inserted_at
    }
  end
end
