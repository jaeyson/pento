defmodule Pento.Accounts.UserNotifier do
  import Swoosh.Email

  alias Pento.Mailer

  @moduledoc """
  Module for sending mail notifications
  """

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({Pento.app_name(), Pento.noreply_email_address()})
      |> subject(subject)
      |> html_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  defp compose_html_body(template, assigns) do
    PentoWeb.EmailView
    |> Phoenix.View.render_to_string(template, assigns)
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    assigns = [
      url: url,
      user_email: user.email,
      title: "Verify your Email Address"
    ]

    html_body = compose_html_body("send_confirmation.html", assigns)

    deliver(user.email, assigns[:title], html_body)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    assigns = [
      url: url,
      user_email: user.email,
      title: "Reset password instructions"
    ]

    html_body = compose_html_body("send_reset_password.html", assigns)

    deliver(user.email, assigns[:title], html_body)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
