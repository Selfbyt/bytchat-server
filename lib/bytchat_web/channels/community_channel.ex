defmodule BytchatWeb.CommunityChannel do
  use Phoenix.Channel

  @impl true
  def join("community:" <> community_name, payload, socket) do
    if authorized?(payload) do
      {:ok, socket |> assign(:community, community_name)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    community = socket.assigns[:community]
    Phoenix.Channel.broadcast("community:#{community}", "shout", payload)
    {:noreply, socket}
  end

  defp authorized?(_payload) do
    true
  end
end
