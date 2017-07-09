defmodule Chevpr.Channel do
  use Chevpr.Web, :model

  schema "channels" do
    field :name, :string
    many_to_many :users, Chevpr.User, join_through: "user_channels"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
