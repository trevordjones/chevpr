defmodule Chevpr.MessageTest do
  use Chevpr.ModelCase

  alias Chevpr.Message

  @valid_attrs %{text: "Message text", channel_id: 1, user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
