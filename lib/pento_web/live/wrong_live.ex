defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  @moduledoc """
  Module for LiveView game "Wrong Game"
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
        session_id: session["live_socket_id"]
      )
    }
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
    	<%= @message %>
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
        <%= live_patch "Restart", to: Routes.live_path(@socket, PentoWeb.WrongLive) %>
      <% end %>
    </h2>
    """
  end

  def random_number, do: Enum.random(1..10)

  def handle_event("guess", %{"number" => guess} = _data, socket) do
    {message, score, state} =
      case to_string(socket.assigns.random_number) do
        ^guess ->
          {
            "Your guess: #{guess} is right.",
            socket.assigns.score + 1,
            :won
          }

        _ ->
          {
            "Your guess: #{guess} is wrong.",
            socket.assigns.score - 1,
            :wrong
          }
      end

    {
      :noreply,
      assign(socket, message: message, score: score, state: state)
    }
  end

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
