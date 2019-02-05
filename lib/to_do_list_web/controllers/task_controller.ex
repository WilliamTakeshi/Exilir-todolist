defmodule ToDoListWeb.TaskController do
  use ToDoListWeb, :controller

  alias ToDoList.Tasks
  alias ToDoList.Tasks.Task

  alias ToDoListWeb.Helper

  action_fallback ToDoListWeb.FallbackController

  # def index(conn, _params) do
  #   tasks = Tasks.list_tasks()
  #   render(conn, "index.json", tasks: tasks)
  # end

  def create(conn, %{"task" => task_params, "list_id" => list_id}) do
    with {:ok, %Task{} = task} <- Tasks.create_task(Map.put(task_params, "list_id", list_id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.list_task_path(conn, :show, list_id, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    user_id = Helper.get_user_id(conn)

    case Tasks.get_task!(user_id, id) do
      %Task{} = task -> render(conn, "show.json", task: task)
      _ ->
        conn
        |> put_view(ToDoListWeb.ErrorView)
        |> render("401.json", %{message: "Not Found"})
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    user_id = Helper.get_user_id(conn)

    case Tasks.get_own_task!(user_id, id) do
      %Task{} = task ->
        with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
          render(conn, "show.json", task: task)
        end
      _ ->
        conn
        |> put_view(ToDoListWeb.ErrorView)
        |> render("401.json", %{message: "Not Found"})
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = Helper.get_user_id(conn)

    case Tasks.get_own_task!(user_id, id) do
      %Task{} = task ->
        with {:ok, %Task{}} <- Tasks.delete_task(task) do
          send_resp(conn, :no_content, "")
        end
      _ ->
        conn
        |> put_view(ToDoListWeb.ErrorView)
        |> render("401.json", %{message: "Not Found"})
    end
  end

  def favorite(conn, %{"task_id" => task_id}) do
    user_id = Helper.get_user_id(conn)

    case Tasks.favorite_task(%{user_id: user_id, task_id: task_id}) do
      {:ok, assoc} -> render(conn, "favorite.json", assoc: assoc)
      {:error, _changeset} -> conn
        |> put_view(ToDoListWeb.ErrorView)
        |> render("401.json", %{message: "Not Found"})
    end
  end
end
