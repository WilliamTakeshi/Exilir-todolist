defmodule ToDoList.Tasks.Favorite do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Jason.Encoder, only: [:user_id, :task_id]}
  @primary_key false
  schema "favorites" do
    belongs_to :user, ToDoList.Auth.User
    belongs_to :task, ToDoList.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:user_id, :task_id])
    |> validate_required([:user_id, :task_id])
    |> unique_constraint(:user_id, name: :favorites_task_id_user_id_index)
  end
end
