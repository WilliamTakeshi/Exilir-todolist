defmodule ToDoListWeb.TaskView do
  use ToDoListWeb, :view
  alias ToDoListWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id, name: task.name, done: task.done, list_id: task.list_id}
  end

  def render("favorite.json", %{assoc: assoc}) do
    %{data: assoc}
  end
end
