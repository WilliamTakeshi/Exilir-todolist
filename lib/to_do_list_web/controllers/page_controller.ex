defmodule ToDoListWeb.PageController do
  use ToDoListWeb, :controller

  alias ToDoListWeb.Router.Helpers, as: Routes

  alias ToDoListWeb.Helper

  def index(conn, _params) do
    case Helper.is_authenticated?(conn) do
      # TODO: write a plug for this
      true -> conn |> redirect(to: Routes.page_path(conn, :lists))
      false -> render(conn, "index.html", current_page: "index")
    end
  end

  def sign_up(conn, _params) do
    case Helper.is_authenticated?(conn) do
      true -> conn |> redirect(to: Routes.page_path(conn, :lists))
      false -> render(conn, "sign_up.html", current_page: "sign_up")
    end
  end

  def lists(conn, _params) do
    render(conn, "lists.html", current_page: "lists")
  end

  def recent_lists(conn, _params) do
    render(conn, "recent_lists.html", current_page: "recent_lists")
  end

  def lists_new(conn, _params) do
    render(conn, "lists_new.html", current_page: "lists_new")
  end

  def lists_show(conn, _params) do
    render(conn, "lists_show.html", current_page: "lists_show")
  end

  def page_404(conn, _params) do
    conn
    |> put_view(ToDoListWeb.ErrorView)
    |> render("404.html", current_page: "page_404")
  end
end
