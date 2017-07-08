defmodule Chevpr.UserTest do
  use Chevpr.ModelCase

  alias Chevpr.User

  @valid_attrs %{email: "example@domain.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
