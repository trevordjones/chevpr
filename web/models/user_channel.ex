defmodule Chevpr.UserChannel do
  use Chevpr.Web, :model

  schema "user_channels" do
    belongs_to :user, Chevpr.User
    belongs_to :channel, Chevpr.Channel

    timestamps()
  end

  @required_fields ~w(user_id channel_id)a

  def by_user_channel(channel_id, user_id) do
    from u in __MODULE__, where: u.channel_id == ^channel_id and
      u.user_id == ^user_id
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:user_id, name: :user_channel_index)
  end
end
