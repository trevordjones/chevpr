defmodule Chevpr.Router do
  use Chevpr.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Chevpr.CurrentUser
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated, handler: Chevpr.GuardianErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Chevpr do
    pipe_through [:browser, :session] # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: ~w(new create)a
    resources "/sessions", SessionController, only: ~w(new create delete)a

    scope "/" do
      pipe_through :login_required

      resources "/users", UserController, only: ~w(show)a
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Chevpr do
  #   pipe_through :api
  # end
end
