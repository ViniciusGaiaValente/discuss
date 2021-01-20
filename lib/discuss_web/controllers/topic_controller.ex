defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Discussion
  alias Discuss.Discussion.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :require_ownership when action in [:update, :edit, :delete]

  def require_ownership(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    %{id: user_id} = conn.assigns[:user]

    if topic_id == user_id do
      conn
    else
      conn
      |> put_flash(:error, "Access denied, only the owner of this topic can access this operation.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    IO.inspect(conn.assigns[:user])
    topics = Discussion.list_topics()

    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Discussion.change_topic(%Topic{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Discussion.create_topic(conn.assigns[:user], topic_params) do

      {:ok, _topic} ->

        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->

        case changeset.errors[:user] do

          nil ->

            conn
            |> put_flash(:error, "Error, check the errors below.")
            |> render("new.html", changeset: changeset)

          _ ->

            conn
            |> put_flash(:error, "Something went wrong, please sign in again")
            |> clear_session()
            |> redirect(to: Routes.page_path(conn, :index))

        end

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
