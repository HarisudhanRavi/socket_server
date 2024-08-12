defmodule SocketServerWeb.Sockets.EchoSocket do
  require Logger
  use Phoenix.Socket

  channel "room:*", SocketServerWeb.Sockets.RoomChannel

  def connect(params, socket, _connect_info) do
    Logger.info("Connected to socket")
    {:ok, assign(socket, :user_id, params["user_id"])}
    # {:ok, socket}
  end

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
