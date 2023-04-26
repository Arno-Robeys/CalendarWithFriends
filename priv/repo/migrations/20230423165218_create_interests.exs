defmodule Calendarwithfriends.Repo.Migrations.CreateInterests do
  use Ecto.Migration

  def change do
    create table(:interests) do
      # new added
      add :user_id, references(:users)
      # I'm new!
      add :event_id, references(:events)
      timestamps()
    end
  end
end
