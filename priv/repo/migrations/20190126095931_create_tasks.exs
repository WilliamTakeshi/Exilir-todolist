defmodule ToDoList.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :done, :boolean, default: false, null: false
      add :list_id, references(:lists, on_delete: :delete_all)

      timestamps()
    end

    create index(:tasks, [:list_id])
  end
end
