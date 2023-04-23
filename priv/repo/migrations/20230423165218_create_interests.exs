defmodule Calendarwithfriends.Repo.Migrations.CreateInterests do
  use Ecto.Migration

  def change do
    create table(:interests) do
      add :user_id, references(:users) #new added
      add :event_id, references(:events) #I'm new!
      timestamps()
    end
  end
end
