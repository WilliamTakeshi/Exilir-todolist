defmodule ToDoListWeb.Helper do
  def get_user_id(conn) do
    current_user_id = Plug.Conn.get_session(conn, :current_user_id)
  end

  def get_user(conn) do
    conn
    |> Map.get(:assigns)
    |> Map.get(:current_user)
  end
end
