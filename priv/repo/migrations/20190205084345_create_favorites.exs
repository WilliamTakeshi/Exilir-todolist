defmodule ToDoList.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :task_id, references(:tasks, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:favorites, [:user_id])
    create index(:favorites, [:task_id])
    create unique_index(:favorites, [:task_id, :user_id])
  end
end
