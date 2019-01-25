defmodule ToDoListWeb.PageController do
  use ToDoListWeb, :controller

  def index(conn, _params) do
    case is_authenticated?(conn) do
      # TODO: write a plug for this
      true -> render(conn, "my_to_do_list.html")
      false -> render(conn, "index.html")
    end

  end

  def sign_in(conn, _params) do
    case is_authenticated?(conn) do
      true -> render(conn, "my_to_do_list.html")
      false -> render(conn, "sign_in.html")
    end

  end

  def sign_up(conn, _params) do
    case is_authenticated?(conn) do
      true -> render(conn, "my_to_do_list.html")
      false -> render(conn, "sign_up.html")
    end

  end

  defp is_authenticated?(conn) do
    case get_session(conn, :current_user_id) do
      nil -> false
      _ -> true
    end
  end
end
