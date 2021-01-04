defmodule Discuss.Discussion do
  @moduledoc """
  The Discussion context.
  """

  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Discussion.Topic

  def get_topic(id) do
    Repo.get!(Topic, id)
  end

  def list_topics do
    Repo.all(Topic)
  end

  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

end
