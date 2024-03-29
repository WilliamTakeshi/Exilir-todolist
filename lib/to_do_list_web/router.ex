defmodule ToDoListWeb.Router do
  use ToDoListWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  scope "/", ToDoListWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/404", PageController, :page_404
    get "/sign_up", PageController, :sign_up
    resources "/sessions", SessionController, only: [:new, :create]
    get "/sign_out", SessionController, :sign_out
    get "/recent_lists", PageController, :recent_lists
  end

  scope "/", ToDoListWeb do
    pipe_through [:browser, :ensure_authenticated_web]

    get "/lists", PageController, :lists
    get "/lists/new", PageController, :lists_new
    get "/lists/:id", PageController, :lists_show
  end

  scope "/api", ToDoListWeb do
    pipe_through :api
    # post "/users/sign_in", UserController, :sign_in
    resources "/users", UserController, only: [:create]
    get "/recent_lists", ListController, :recent_lists
  end

  scope "/api", ToDoListWeb do
    pipe_through [:api, :api_auth]
    resources "/users", UserController, except: [:new, :edit, :create, :index, :delete]
    get "/whoami", UserController, :whoami
    post "/favorite", TaskController, :favorite
    post "/unfavorite", TaskController, :unfavorite
    resources "/lists", ListController, except: [:new, :edit, :update] do
      resources "/tasks", TaskController, except: [:new, :edit, :index]
    end
  end

  # Plug function
  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(ToDoListWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
      |> halt()
    end
  end

  defp ensure_authenticated_web(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> render(:index, message: "Unauthenticated user")
      |> halt()
    end
  end
end
