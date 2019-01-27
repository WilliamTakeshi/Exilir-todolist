

defmodule ToDoListWeb.SessionControllerTest do
  use ToDoListWeb.ConnCase

  alias ToDoList.Auth
  alias Plug.Test

  @user_attrs %{
    email: "some email",
    password: "some password",
    username: "some username"
  }
  @invalid_attrs %{email: nil, password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Auth.create_user(@user_attrs)
    user
  end

  test "GET /sessions/new", %{conn: conn} do
    conn = get(conn, "/sessions/new")
    assert html_response(conn, 200) =~ "Please, login into your account"
  end

  test "GET /sign_up", %{conn: conn} do
    conn = get(conn, "/sign_up")
    assert html_response(conn, 200) =~ "react_sign_up"
  end

  describe "sign_in user" do
    setup [:create_user]

    test "renders user when user credentials (email) are good", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.session_path(conn, :create, %{"session" => %{
            login: @user_attrs.email,
            password: @user_attrs.password
          }})
        )

      assert html_response(conn, 302) =~ "redirected"
    end

    test "renders user when user credentials (username) are good", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.session_path(conn, :create, %{"session" => %{
            login: @user_attrs.email,
            password: @user_attrs.password
          }})
        )

      assert html_response(conn, 302) =~ "redirected"
    end

    test "renders errors when user credentials are bad", %{conn: conn} do
      conn =
        post(conn, Routes.session_path(conn, :create, %{"session" => %{login: "nonexistent email", password: ""}}))

      assert html_response(conn, 200) =~ "Invalid email/password combination"
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
