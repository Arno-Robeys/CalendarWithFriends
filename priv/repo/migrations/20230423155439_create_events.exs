defmodule Calendarwithfriends.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :string
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime
      add :is_private, :boolean, default: true, null: false
      # new added
      add :user_id, references(:users), null: false
      timestamps()
    end

    create index(:events, [:title])
  end
end
