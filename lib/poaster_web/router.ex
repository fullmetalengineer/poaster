defmodule PoasterWeb.Router do
  use PoasterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Poaster.Plugs.Authenticate
  end

  scope "/", PoasterWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", PoasterWeb do
    pipe_through :api

    # Unauthenticated endpoints
    post "/sessions/sign_in", SessionsController, :create
    post "/users", UsersController, :create

    # Authenticated endpoints
    pipe_through :authenticated
    scope "/sessions" do
      delete "/sign_out", SessionsController, :delete
      post "/revoke", SessionsController, :revoke
    end
    # more routes
    scope "/users" do
      get "/me", UsersController, :me
    end

    resources "/personas", PersonasController, except: [:new, :edit]
    scope "/personas" do
      post "/availability", PersonasController, :availability
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PoasterWeb.Telemetry
    end
  end
end
