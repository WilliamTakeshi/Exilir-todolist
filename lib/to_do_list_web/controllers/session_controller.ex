defmodule ToDoListWeb.SessionController do
  use ToDoListWeb, :controller

  alias ToDoListWeb.Router.Helpers, as: Routes
  alias ToDoListWeb.Helper

  def new(conn, _) do
    case Helper.is_authenticated?(conn) do
      true -> conn |> redirect(to: Routes.page_path(conn, :lists))
      false -> render(conn, "new.html", current_page: "sign_in")
    end
  end

  def create(conn, %{"session" => %{"login" => login, "password" => password}}) do
    case ToDoList.Auth.authenticate_user(login, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _message} ->
        conn
        |> delete_session(:current_user_id)
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html", current_page: "sign_in")
    end
  end

  def sign_out(conn, _params) do
    conn
      |> delete_session(:current_user_id)
      |> put_flash(:info, "Sign out successfully")
      |> redirect(to: Routes.page_path(conn, :index))
    end
end
