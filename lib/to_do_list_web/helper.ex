defmodule ToDoListWeb.Helper do
  def get_user_id(conn) do
    Plug.Conn.get_session(conn, :current_user_id)
  end

  def get_user(conn) do
    conn
    |> Map.get(:assigns)
    |> Map.get(:current_user)
  end


  def is_authenticated?(conn) do
    case Plug.Conn.get_session(conn, :current_user_id) do
      nil -> false
      _ -> true
    end
  end
end
