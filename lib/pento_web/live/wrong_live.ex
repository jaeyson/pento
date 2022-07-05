defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  @type unsigned_params() :: map()

  @moduledoc """
  Module for LiveView game "Wrong Game"
  """

  @doc """
  mount/3 function is responsible for establishing
  the initial state for the liveview by populating
  the socket assigns.

  Remember, the socket contains the data representing
  the state of the liveview, and the :assigns key,
  referred to as the "socket assigns", holds custom
  data.

  This returns a result tuple. The first element is
  either :ok or :error, the second element has the
  initial contents of the socket.
  """
  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        random_number: random_number(),
        score: 0,
        message: "Make a guess: ",
        state: :initalize,
        session_id: session["live_socket_id"],
        time: time()
      )
    }
  end

  @doc """
  render/1 function renders markup as heex to the
  browser.

  If there' no render/1 function, liveview looks for
  a template ot render based on the name of the view.
  """
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= @time %>
    </h2>
    <h2>
      <%= if @state !== :won do %>
        <%= for n <- 1..10 do %>
          <a href="#" phx-click="guess" phx-value-number={n}>
            <%= n %>
          </a>
        <% end %>
        <pre>
          user: <%= @current_user.email %>
          <%= @session_id %>
        </pre>
      <% else %>
        <%= live_patch("Restart", to: Routes.live_path(@socket, PentoWeb.WrongLive)) %>
      <% end %>
    </h2>
    """
  end

  def time do
    DateTime.utc_now() |> to_string
  end

  def random_number, do: Enum.random(1..10)

  @doc """
  tldr: handle_event/3 manages what to do with
  the socket state (e.g. should we update or not?).

  - First param is the message name.
  - Second param is a map with the metadata related
    to the event.
  - Third param is the socket state.

  Invoked to handle events sent by the client.

  It receives the event name, the event payload
  as a map, and the socket.

  It must return `{:noreply, socket}`, where
  `:noreply` means no additional information is
  sent to the client, or `{:reply, map(), socket}`,
  where the given `map()` is encoded and sent as
  a reply to the client.
  """
  def handle_event("guess", %{"number" => guess} = _data, socket) do
    {message, score, state, time} =
      case to_string(socket.assigns.random_number) do
        ^guess ->
          {
            "Your guess: #{guess} is right.",
            socket.assigns.score + 1,
            :won,
            time()
          }

        _ ->
          {
            "Your guess: #{guess} is wrong.",
            socket.assigns.score - 1,
            :wrong,
            time()
          }
      end

    {
      :noreply,
      assign(socket, message: message, score: score, state: state, time: time)
    }
  end

  @doc """
  Invoked after mount and whenever there is a live
  patch event.

  It receives the current params, including
  parameters from the router, the current uri from
  the client and the socket. It is invoked after
  mount or whenever there is a live navigation
  event caused by `push_patch/2` or
  `Phoenix.LiveView.Helpers.live_patch/2`.

  It must always return `{:noreply, socket}`, where
  `:noreply` means no additional information is sent
  to the client.
  """
  @callback handle_params(
              unsigned_params(),
              uri :: String.t(),
              socket :: Phoenix.LiveView.Socket.t()
            ) :: {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(_params, _uri, socket) do
    {
      :noreply,
      assign(
        socket,
        random_number: random_number(),
        score: 0,
        message: "Make a guess: ",
        state: :initalize
      )
    }

    # if socket.assigns.state === :wrong do
    #   {:noreply, assign(socket, state: :wrong)}
    # else
    #   {:noreply, socket}
    # end
  end
end
