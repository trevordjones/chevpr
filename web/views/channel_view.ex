defmodule Chevpr.ChannelView do
  use Chevpr.Web, :view
  alias Chevpr.MessageView

  def render("create.json", %{channel: channel}) do
    %{
      id: channel.id,
      name: channel.name
    }
  end

  def to_json(channels) do
    Enum.map(channels, &render_json/1)
    |> Poison.encode!
  end

  def render_json(channel) do
    %{
      id: channel.id,
      name: channel.name
    }
  end
end
