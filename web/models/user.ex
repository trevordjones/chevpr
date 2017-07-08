defmodule Chevpr.User do
  use Chevpr.Web, :model

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :sign_in_count, :integer, default: 0

    timestamps()
  end

  @required_fields ~w(email)a
  @optional_fields ~w(first_name last_name sign_in_count)a
  @registration_fields ~w(password password_confirmation)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, @registration_fields)
    |> validate_required(@registration_fields)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end