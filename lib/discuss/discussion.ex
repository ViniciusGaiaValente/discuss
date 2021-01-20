defmodule Discuss.Discussion do
  @moduledoc """
  The Discussion context.
  """
  import Ecto
  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Discussion.Topic

  def change_topic(%Topic{} = topic, attrs \\ %{}) do
    Topic.changeset(topic, attrs)
  end

  def get_topic!(id), do: Repo.get!(Topic, id)

  def list_topics do
    Repo.all(Topic)
  end

  def create_topic(user, attrs \\ %{}) do
    user
    |> build_assoc(:topics)
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  def update_topic(%Topic{} = topic, attrs \\ %{}) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  def delete_topic(topic) do
    Repo.delete!(topic)
  end
end
