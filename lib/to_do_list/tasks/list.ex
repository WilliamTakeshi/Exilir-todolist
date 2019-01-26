defmodule ToDoList.Tasks.List do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :public, :user_id]}
  schema "lists" do
    field :name, :string
    field :public, :boolean, default: false
    belongs_to :user, ToDoList.Auth.User
    has_many :tasks, ToDoList.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name, :public, :user_id])
    |> validate_required([:name, :public, :user_id])
  end
end
