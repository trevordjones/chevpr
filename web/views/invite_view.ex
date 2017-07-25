defmodule Chevpr.InviteView do
  use Chevpr.Web, :view

  def render("success.json", %{email: email}) do
    %{
      status: 200,
      message: "Invited #{email}"
    }
  end
end
