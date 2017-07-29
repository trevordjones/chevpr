defmodule Chevpr.Message do
  use Chevpr.Web, :model

  schema "messages" do
    field :text, :string
    belongs_to :channel, Chevpr.Channel
    belongs_to :user, Chevpr.User

    timestamps()
  end

  @required_fields ~w(text channel_id user_id)a

  def channel_messages(channel) do
    from m in Ecto.assoc(channel, :messages),
    order_by: [asc: m.inserted_at],
    limit: 100,
    preload: [:user]
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> strip_unsafe(params)
  end

  defp strip_unsafe(model, %{"body" => nil}) do
    model
  end

  defp strip_unsafe(model, %{"body" => body}) do
    {:safe, clean_body} = Phoenix.HTML.html_escape(body)
    model |> put_change(:body, clean_body)
  end

  defp strip_unsafe(model, _) do
    model
  end
end
