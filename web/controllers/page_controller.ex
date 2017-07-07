defmodule Chevpr.PageController do
  use Chevpr.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
