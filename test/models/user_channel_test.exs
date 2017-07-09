defmodule Chevpr.UserChannelTest do
  use Chevpr.ModelCase

  alias Chevpr.UserChannel

  @valid_attrs %{channel_id: 1, user_id: 1}

  test "changeset with valid attributes" do
    changeset = UserChannel.changeset(%UserChannel{}, @valid_attrs)
    assert changeset.valid?
  end
end
