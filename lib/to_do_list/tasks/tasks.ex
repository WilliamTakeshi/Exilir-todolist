defmodule ToDoList.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias ToDoList.Repo

  alias ToDoList.Tasks.{List, Favorite, Task}

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists(user_id) do

    List
    |> where(user_id: ^user_id)
    |> Repo.all()
  end


  def list_recent_lists(user_id) do
    List
    |> where(public: true)
    |> where([l], l.user_id != ^user_id)
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(user_id, id) do

    List
    |> where(user_id: ^user_id)
    |> or_where(public: true)
    |> Repo.get!(id)
    |> Repo.preload(:tasks)
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a List.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    list
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{source: %List{}}

  """
  def change_list(%List{} = list) do
    List.changeset(list, %{})
  end


  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  # def list_tasks do
  #   Repo.all(Task)
  # end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(user_id, id) do
    query = from(t in Task,
      join: l in assoc(t, :list),
      where: (t.id == ^id) and ((l.user_id == ^user_id) or l.public == true))

    Repo.one(query)
  end

  def get_own_task!(user_id, id) do
    query = from(t in Task,
      join: l in assoc(t, :list),
      where: (t.id == ^id) and (l.user_id == ^user_id))

    Repo.one(query)
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  def favorite_task(%{user_id: _user_id, task_id: task_id} = params) do

    list = List
    |> where(public: true)
    |> Repo.get(task_id)

    case list do
      nil -> {:error, nil}
      _otherwise -> %Favorite{}
        |> Favorite.changeset(params)
        |> Repo.insert()
    end
  end

  def unfavorite_task(%{user_id: user_id, task_id: task_id}) do
    Favorite
      |> where(user_id: ^user_id)
      |> where(task_id: ^task_id)
      |> Repo.delete_all()

    {:ok, nil}
  end
end
