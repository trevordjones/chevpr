defmodule Chevpr.Channel do
  use Chevpr.Web, :model

  schema "channels" do
    field :name, :string
    many_to_many :users, Chevpr.User, join_through: Chevpr.UserChannel

    timestamps()
  end

  def ordered(query) do
    from c in query, order_by: [desc: c.inserted_at]
  end

  def by_owner(user) do
    assoc(user, :channels)
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
