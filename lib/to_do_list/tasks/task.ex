defmodule ToDoList.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :done, :list_id]}

  schema "tasks" do
    field :done, :boolean, default: false
    field :name, :string
    belongs_to :list, ToDoList.Tasks.List
    many_to_many :followers, ToDoList.Auth.User, join_through: ToDoList.Tasks.Favorite

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :done, :list_id])
    |> validate_required([:name, :done])
    |> assoc_constraint(:list)
    |> cast_assoc(:list)
  end
end
