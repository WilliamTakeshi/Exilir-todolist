defmodule ToDoListWeb.PageController do
  use ToDoListWeb, :controller

  alias ToDoListWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    case is_authenticated?(conn) do
      # TODO: write a plug for this
      true -> conn |> redirect(to: Routes.page_path(conn, :lists))
      false -> render(conn, "index.html")
    end

  end

  def sign_in(conn, _params) do
    case is_authenticated?(conn) do
      true ->
        conn
        |> redirect(to: Routes.page_path(conn, :lists))
      false -> render(conn, "sign_in.html")
    end

  end

  def sign_up(conn, _params) do
    case is_authenticated?(conn) do
      true -> conn |> redirect(to: Routes.page_path(conn, :lists))
      false -> render(conn, "sign_up.html")
    end
  end

  def lists(conn, _params) do
    render(conn, "lists.html")
  end

  defp is_authenticated?(conn) do
    case get_session(conn, :current_user_id) do
      nil -> false
      _ -> true
    end
  end
end
