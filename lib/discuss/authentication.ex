defmodule Discuss.Authentication do
  @moduledoc """
  The Discussion context.
  """

  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Authentication.User

  def get_user(id) do
    Repo.get(User, id)
  end

  def find_or_create_user(attrs \\ %{}) do
    changeset = User.changeset(%User{}, attrs)

    %{ changes: %{ email: email } } = changeset

    case Repo.get_by(User, email: email) do
      nil ->
        Repo.insert(changeset)
      user ->
        user
        |> User.changeset(attrs)
        |> Repo.update()
    end
  end
end
