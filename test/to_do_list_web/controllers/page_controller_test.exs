defmodule ToDoListWeb.PageControllerTest do
  use ToDoListWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Don't lose track of your goals"
  end
end
