defmodule ToDoListWeb.TaskControllerTest do
  use ToDoListWeb.ConnCase
  alias Plug.Test
  alias ToDoList.{Repo, Auth, Tasks}
  alias ToDoList.Tasks.Task
  alias ToDoListWeb.Helper

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

  def fixture(:task, conn) do
    list = fixture(:list, conn)

    {:ok, task} =
      %{}
      |> Enum.into(@create_attrs)
      |> Map.put(:list_id, list.id)
      |> Tasks.create_task()

    task |> Repo.preload(:list)
  end

  def fixture(:list, conn) do
    user_id = Helper.get_user_id(conn)

    {:ok, list} = Tasks.create_list(Map.put(@create_attrs, :user_id, user_id))

    list
  end

  def fixture(:current_user) do
    {:ok, current_user} = Auth.create_user(@valid_user_attrs)
    current_user
  end

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: current_user} = setup_current_user(conn)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user}
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn} do
      list = fixture(:list, conn)
      conn = post(conn, Routes.list_task_path(conn, :create, list.id), task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.list_task_path(conn, :show, list.id, id))

      assert %{
               "id" => id,
               "done" => true,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      list = fixture(:list, conn)
      conn = post(conn, Routes.list_task_path(conn, :create, list.id), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do

    test "renders task when data is valid", %{conn: conn} do
      task = fixture(:task, conn)
      task_id = task.id
      conn = put(conn, Routes.list_task_path(conn, :update, task.list.id, task_id), task: @update_attrs)
      assert %{"id" => ^task_id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.list_task_path(conn, :show, task.list.id, task_id))

      assert %{
               "id" => task_id,
               "done" => false,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      task = fixture(:task, conn)
      conn = put(conn, Routes.list_task_path(conn, :update, task.list.id, task.id), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do

    test "deletes chosen task", %{conn: conn} do
      task = fixture(:task, conn)
      conn = delete(conn, Routes.list_task_path(conn, :delete, task.list.id, task))
      assert response(conn, 204)
      assert get(conn, Routes.list_task_path(conn, :show, task.list.id, task)).assigns.message == "Not Found"
    end
  end

  defp setup_current_user(conn) do
    current_user = fixture(:current_user)

    {:ok,
     conn: Test.init_test_session(conn, current_user_id: current_user.id),
     current_user: current_user}
  end
end
