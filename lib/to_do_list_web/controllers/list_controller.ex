defmodule ToDoListWeb.ListController do
  use ToDoListWeb, :controller

  alias ToDoList.Tasks
  alias ToDoList.Tasks.List
  alias ToDoListWeb.Helper

  action_fallback ToDoListWeb.FallbackController

  def index(conn, _params) do
    user_id = Helper.get_user_id(conn)

    lists = Tasks.list_lists(user_id)
    render(conn, "index.json", lists: lists)
  end

  def recent_lists(conn, _params) do
    user_id = Helper.get_user_id(conn) || 0

    lists = Tasks.list_recent_lists(user_id)
    render(conn, "index.json", lists: lists)
  end

  def create(conn, %{"list" => list_params}) do
    list_params = Map.put(list_params, "user_id", Helper.get_user_id(conn))
    with {:ok, %List{} = list} <- Tasks.create_list(list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.list_path(conn, :show, list))
      |> render("show.json", list: list)
    end
  end

  def show(conn, %{"id" => id}) do
    user_id = Helper.get_user_id(conn)

    list = Tasks.get_list!(user_id, id)
    render(conn, "showcomplete.json", list: list)
  end

  # def update(conn, %{"id" => id, "list" => list_params}) do
  #   list = Tasks.get_list!(conn, id)

  #   with {:ok, %List{} = list} <- Tasks.update_list(list, list_params) do
  #     render(conn, "show.json", list: list)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    user_id = Helper.get_user_id(conn)

    list = Tasks.get_list!(user_id, id)

    with {:ok, %List{}} <- Tasks.delete_list(list) do
      send_resp(conn, :no_content, "")
    end
  end
end
