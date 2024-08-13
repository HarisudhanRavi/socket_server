defmodule SocketServerWeb.Sockets.RoomChannel do
  require Logger
  use SocketServerWeb, :channel

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("room:" <> room_id, _payload, socket) do
    Logger.info("Joined in room #{room_id}")
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Handles all messages
  # Message received should always be a map with fields - event, topic, payload, ref
  @impl true
  def handle_in(event, payload, socket) do
    IO.inspect(event, label: "event")
    IO.inspect(payload, label: "payload")
    {:noreply, socket}
  end

  # Message sent will always be a map with fields - event, topic, payload, ref
  def send_message(room_id, msg) do
    SocketServerWeb.Endpoint.broadcast!("room:#{room_id}", "new_msg", msg)
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
