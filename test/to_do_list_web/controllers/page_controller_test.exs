defmodule ToDoListWeb.PageControllerTest do
  use ToDoListWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Don't lose track of your goals"
  end

  test "GET /sign_in", %{conn: conn} do
    conn = get(conn, "/sign_in")
    assert html_response(conn, 200) =~ "react_sign_in"
  end

  test "GET /sign_up", %{conn: conn} do
    conn = get(conn, "/sign_up")
    assert html_response(conn, 200) =~ "react_sign_up"
  end
end
