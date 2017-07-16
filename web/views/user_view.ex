defmodule Chevpr.UserView do
  use Chevpr.Web, :view

  def full_name(user) do
    "#{user.first_name} #{user.last_name}"
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end
end
