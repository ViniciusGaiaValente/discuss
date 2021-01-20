defmodule Discuss.Discussion.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string

    belongs_to :user, Discuss.Authentication.User
  end

  def changeset(topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:title])
    |> cast_assoc(:user)
    |> validate_required([:title])
    |> assoc_constraint(:user)
  end
end
