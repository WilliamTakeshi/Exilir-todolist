defmodule ToDoListWeb.TaskController do
  use ToDoListWeb, :controller

  alias ToDoList.Tasks
  alias ToDoList.Tasks.Task

  action_fallback ToDoListWeb.FallbackController

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"task" => task_params, "list_id" => list_id}) do
    with {:ok, %Task{} = task} <- Tasks.create_task(Map.put(task_params, "list_id", list_id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.list_task_path(conn, :show, list_id, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{}} <- Tasks.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
