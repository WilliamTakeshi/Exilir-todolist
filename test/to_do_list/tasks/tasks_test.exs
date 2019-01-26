defmodule ToDoList.TasksTest do
  use ToDoList.DataCase

  alias ToDoList.{Tasks, Auth}

  describe "lists" do
    alias ToDoList.Tasks.List
    alias ToDoList.Auth.User

    @valid_attrs %{name: "some name", public: true}
    @update_attrs %{name: "some updated name", public: false}
    @invalid_attrs %{name: nil, public: nil}


    @valid_user_attrs %{
      email: "some email",
      password: "some password",
      username: "some username"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> Auth.create_user()

      user
    end

    def list_fixture(attrs \\ %{}) do
      %User{id: user_id} = user_fixture()
      {:ok, list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:user_id, user_id)
        |> Tasks.create_list()

      list
    end

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Tasks.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Tasks.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      %User{id: user_id} = user_fixture()
      result = %{}
        |> Enum.into(@valid_attrs)
        |> Map.put(:user_id, user_id)
        |> Tasks.create_list()
      assert {:ok, %List{} = list} = result
      assert list.name == "some name"
      assert list.public == true
      assert list.user_id == user_id
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      assert {:ok, %List{} = list} = Tasks.update_list(list, @update_attrs)
      assert list.name == "some updated name"
      assert list.public == false
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_list(list, @invalid_attrs)
      assert list == Tasks.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Tasks.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Tasks.change_list(list)
    end
  end

  describe "tasks" do
    alias ToDoList.Tasks.Task
    alias ToDoList.Tasks.List

    @valid_attrs %{done: true, name: "some name"}
    @update_attrs %{done: false, name: "some updated name"}
    @invalid_attrs %{done: nil, name: nil}

    def task_fixture(attrs \\ %{}) do
      %List{id: list_id} = ToDoList.TasksTest.list_fixture()
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:list_id, list_id)
        |> Tasks.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      %List{id: list_id} = ToDoList.TasksTest.list_fixture()

      result = %{}
        |> Enum.into(@valid_attrs)
        |> Map.put(:list_id, list_id)
        |> Tasks.create_task()

      assert {:ok, %Task{} = task} = result
      assert task.done == true
      assert task.name == "some name"
      assert task.list_id == list_id


    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Tasks.update_task(task, @update_attrs)
      assert task.done == false
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
