defmodule Chevpr.InviteView do
  use Chevpr.Web, :view

  def render("success.json", %{name: name}) do
    %{
      status: 200,
      message: "Invited #{name}",
      name: name
    }
  end
end
