defmodule BytchatWeb.ChatChannel do
  use BytchatWeb, :channel



  # Joining a private chat with another user
  @impl true
  def join("chat:" <> to_user, _payload, socket) do
    if authorized?(socket.assigns[:user_id]) do
      {:ok, socket |> assign(:to_user, to_user)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Handle private messages
  @impl true
  def handle_in("private_message", %{"to" => to_user, "body" => body}, socket) do
    if to_user == socket.assigns[:to_user] do
      message = %{
        "from" => socket.assigns[:user_id],
        "to" => to_user,
        "body" => body,
        "id" => generate_message_id()
      }

      # You may want to implement a function to handle private messages, like storing them in a database.
      # For now, just print it for demonstration purposes.
      IO.inspect(message, label: "Private Message")

      {:noreply, socket}
    else
      {:noreply, socket |> push_event("unauthorized_private_message", %{reason: "Invalid recipient"})}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_user_id) do
    true
  end

  # Generate a unique message identifier (you may need a more robust solution in production)
  defp generate_message_id() do
    :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
  end
end
