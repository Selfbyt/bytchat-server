defmodule Bytchat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :user, :string
      add :room, :string
    end
  end
end
