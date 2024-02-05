defmodule BytchatWeb.CommunityChannel do
  use BytchatWeb, :channel

  @impl true
  def join("community:" <> community_name, payload, socket) do
    if authorized?(payload) do
      {:ok, socket |> assign(:community, community_name)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Broadcast messages to everyone in the current community
  @impl true
  def handle_in("shout", payload, socket) do
    community = socket.assigns[:community]
    broadcast_to_community(socket, community, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  # Broadcast a message to everyone in the given community
  defp broadcast_to_community(socket, community, event, payload) do
    topic = "community:#{community}"
    broadcast(socket, topic, event, payload)
  end
end
