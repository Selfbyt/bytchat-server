defmodule Bytchat.Repo do
  use Ecto.Repo,
    otp_app: :bytchat,
    adapter: Ecto.Adapters.Postgres
end
