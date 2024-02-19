defmodule BytchatWeb.ChatChannel do
  use Phoenix.Channel

  @impl true
  def join("chat:" <> to_user, _payload, socket) do
    if authorized?(socket.assigns[:user_id]) do
      {:ok, socket |> assign(:to_user, to_user)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("private_message", %{"to" => to_user, "body" => body}, socket) do
    if to_user == socket.assigns[:to_user] do
      message = %{
        "from" => socket.assigns[:user_id],
        "to" => to_user,
        "body" => body,
        "id" => generate_message_id()
      }

      IO.inspect(message, label: "Private Message")

      {:noreply, socket}
    else
      {:noreply, socket |> push("unauthorized_private_message", %{reason: "Invalid recipient"})}
    end
  end

  defp authorized?(_user_id) do
    true
  end

  defp generate_message_id() do
    :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
  end
end
