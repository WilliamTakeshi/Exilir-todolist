defmodule ToDoListWeb.ListControllerTest do
  use ToDoListWeb.ConnCase
  alias ToDoList.Auth

  alias ToDoList.Tasks
  alias Plug.Test
  alias ToDoListWeb.Helper

  @create_attrs %{
    name: "some name",
    public: true
  }
  @invalid_attrs %{name: nil, public: nil, user_id: nil}

  @current_user_attrs %{
    email: "some list user email",
    username: "some list user username",
    password: "some list user password"
  }

  def fixture(:list, conn) do
    user_id = Helper.get_user_id(conn)

    {:ok, list} = Tasks.create_list(Map.put(@create_attrs, :user_id, user_id))
    list
  end

  def fixture(:current_user) do
    {:ok, current_user} = Auth.create_user(@current_user_attrs)
    current_user
  end

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: current_user} = setup_current_user(conn)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user}
  end

  describe "index" do
    test "lists all lists", %{conn: conn} do
      conn = get(conn, Routes.list_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create list" do
    test "renders list when data is valid", %{conn: conn, current_user: %{id: user_id}} do
      conn =
        post(conn, Routes.list_path(conn, :create),
          list: Map.put(@create_attrs, :user_id, user_id)
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.list_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "public" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), list: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update list" do
  #   test "renders list when data is valid", %{conn: conn} do
  #     list = fixture(:list, conn)
  #     list_id = list.id
  #     conn = put(conn, Routes.list_path(conn, :update, list), list: @update_attrs)
  #     assert %{"id" => ^list_id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.list_path(conn, :show, list_id))

  #     assert %{
  #              "id" => list_id,
  #              "name" => "some updated name",
  #              "public" => false
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, list: list} do
  #     conn = put(conn, Routes.list_path(conn, :update, list), list: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  describe "delete list" do
    test "deletes chosen list", %{conn: conn, current_user: _current_user} do
      list = fixture(:list, conn)
      conn = delete(conn, Routes.list_path(conn, :delete, list))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.list_path(conn, :show, list))
      end
    end
  end

  defp setup_current_user(conn) do
    current_user = fixture(:current_user)

    {:ok,
     conn: Test.init_test_session(conn, current_user_id: current_user.id),
     current_user: current_user}
  end
end
