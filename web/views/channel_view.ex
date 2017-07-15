defmodule Chevpr.ChannelView do
  use Chevpr.Web, :view

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
    IO.puts "AAAAAAAHHHHH"
    IO.inspect channel
    %{
      id: channel.id,
      name: channel.name
    }
  end
end