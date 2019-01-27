defmodule ToDoListWeb.LayoutView do
  use ToDoListWeb, :view
  alias ToDoListWeb.Helper
  def is_authenticated?(conn) do
    Helper.is_authenticated?(conn)
  end
end
