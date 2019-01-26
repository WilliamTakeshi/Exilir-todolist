defmodule ToDoListWeb.TaskControllerTest do
  use ToDoListWeb.ConnCase
  alias Plug.Test

  alias ToDoList.Auth
  alias ToDoList.Tasks
  alias ToDoList.Tasks.Task

  @create_attrs %{
    done: true,
    name: "some name"
  }
  @update_attrs %{
    done: false,
    name: "some updated name"
  }
  @invalid_attrs %{done: nil, name: nil}

  @valid_list_attrs %{name: "some name", public: true}

  @valid_user_attrs %{
    email: "some email",
    password: "some password",
    username: "some username"
  }

  def fixture(:task) do
    {:ok, user} =
      %{}
      |> Enum.into(@valid_user_attrs)
      |> Auth.create_user()

    {:ok, list} =
      %{}
      |> Enum.into(@valid_list_attrs)
      |> Map.put(:user_id, Map.get(user, :id))
      |> Tasks.create_list()

    {:ok, task} =
      %{}
      |> Enum.into(@create_attrs)
      |> Map.put(:list_id, Map.get(list, :id))
      |> Tasks.create_task()
    task
  end

  def fixture(:current_user) do
    {:ok, current_user} = Auth.create_user(@valid_user_attrs)
    current_user
  end

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: current_user} = setup_current_user(conn)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, Routes.list_task_path(conn, :index, "1"))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.list_task_path(conn, :create), task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.list_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "done" => true,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.list_task_path(conn, :create), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:create_task]

    test "renders task when data is valid", %{conn: conn, task: %Task{id: id} = task} do
      conn = put(conn, Routes.list_task_path(conn, :update, task), task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.list_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "done" => false,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, Routes.list_task_path(conn, :update, task), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, Routes.list_task_path(conn, :delete, task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.list_task_path(conn, :show, task))
      end
    end
  end


  defp create_task(_) do
    task = fixture(:task)
    {:ok, task: task}
  end

  defp setup_current_user(conn) do
    current_user = fixture(:current_user)

    {:ok,
     conn: Test.init_test_session(conn, current_user_id: current_user.id),
     current_user: current_user}
  end
end
