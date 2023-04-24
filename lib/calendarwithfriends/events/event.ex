defmodule Calendarwithfriends.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias Calendarwithfriends.Accounts.User
  alias Calendarwithfriends.Interests.Interest

  schema "events" do
    field :title, :string
    field :description, :string
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    field :is_private, :boolean, default: true

    belongs_to :user, User
    has_many :interests, Interest

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :start_time, :end_time, :is_private,:user_id])
    |> validate_required([:title, :description, :start_time, :end_time, :is_private, :user_id])
  end
end
