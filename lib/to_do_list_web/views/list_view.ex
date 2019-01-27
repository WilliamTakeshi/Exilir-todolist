defmodule ToDoListWeb.ListView do
  use ToDoListWeb, :view
  alias ToDoListWeb.{ListView, TaskView}

  def render("index.json", %{lists: lists}) do
    %{data: render_many(lists, ListView, "list.json")}
  end

  def render("show.json", %{list: list}) do
    %{data: render_one(list, ListView, "list.json")}
  end

  def render("showcomplete.json", %{list: list}) do
    %{data: render_one(list, ListView, "listcomplete.json")}
  end

  def render("list.json", %{list: list}) do
    %{id: list.id, name: list.name, public: list.public, user_id: list.user_id}
  end

  def render("listcomplete.json", %{list: list}) do
    %{
      id: list.id,
      name: list.name,
      public: list.public,
      updated_at: list.updated_at,
      inserted_at: list.inserted_at,
      user_id: list.user_id,
      tasks: render_many(list.tasks, TaskView, "task.json")
    }
  end
end
