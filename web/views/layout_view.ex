defmodule Chevpr.LayoutView do
  use Chevpr.Web, :view

  def display_alert(conn), do: display_alert(~w(info danger success)a, conn)

  def display_alert([h | t], conn) do
    get_flash(conn, h)
    |> display_alert(conn, h, t)
  end

  def display_alert(nil, conn, head, tail), do: display_alert(tail, conn)

  def display_alert([], conn), do: nil

  def display_alert(message, conn , class, _tail) do
    render(Chevpr.SharedView, "alerts.html", message: message, class: class)
  end
end
