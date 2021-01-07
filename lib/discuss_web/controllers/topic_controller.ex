defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Discussion
  alias Discuss.Discussion.Topic

  def index(conn, _params) do
    topics = Discussion.list_topics()

    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Discussion.change_topic(%Topic{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Discussion.create_topic(topic_params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error, check the errors below.")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Discussion.get_topic!(topic_id)
    changeset = Discussion.change_topic(topic)

    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic_params}) do
    topic = Discussion.get_topic!(topic_id)

    case Discussion.update_topic(topic, topic_params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error, check the errors below.")
        |> render("edit.html", topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    topic = Discussion.get_topic!(topic_id)

    Discussion.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
