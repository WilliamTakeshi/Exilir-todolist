defmodule ToDoListWeb.PageController do
  use ToDoListWeb, :controller

  alias ToDoListWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    case is_authenticated?(conn) do
      # TODO: write a plug for this
      true -> conn |> redirect(to: Routes.page_path(conn, :lists))
      false -> render(conn, "index.html", current_page: "index")
    end
  end

  def sign_in(conn, _params) do
    case is_authenticated?(conn) do
      true ->
        conn
        |> redirect(to: Routes.page_path(conn, :lists))

      false ->
        render(conn, "sign_in.html", current_page: "sign_in")
    end
  end

  def sign_up(conn, _params) do
    case is_authenticated?(conn) do
      true -> conn |> redirect(to: Routes.page_path(conn, :lists))
      false -> render(conn, "sign_up.html", current_page: "sign_up")
    end
  end

  def sign_out(conn, _params) do
    conn
      |> delete_session(:current_user_id)
      |> put_flash(:info, "Sign out successfully")
      |> redirect(to: Routes.page_path(conn, :index))
    end



  def lists(conn, _params) do
    render(conn, "lists.html", current_page: "lists")
  end

  def lists_new(conn, _params) do
    render(conn, "lists_new.html", current_page: "lists_new")
  end

  def lists_show(conn, _params) do
    render(conn, "lists_show.html", current_page: "lists_show")
  end

  defp is_authenticated?(conn) do
    case get_session(conn, :current_user_id) do
      nil -> false
      _ -> true
    end
  end
end
