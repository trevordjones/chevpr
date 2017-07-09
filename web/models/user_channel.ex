defmodule Chevpr.UserChannel do
  use Chevpr.Web, :model

  schema "user_channels" do
    belongs_to :user, Chevpr.User
    belongs_to :channel, Chevpr.Channel

    timestamps()
  end

  @required_fields ~w(user_id channel_id)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_files)
  end
end
