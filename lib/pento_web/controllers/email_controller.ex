defmodule PentoWeb.EmailController do
  use PentoWeb, :controller

  def send_confirmation(conn, _params) do
    assigns = [
      url: "https://google.com",
      user_email: "test@nappy.co",
      title: "Verify your Email Address"
    ]

    render(conn, "send_confirmation.html", assigns)
  end

  def send_reset_password(conn, _params) do
    assigns = [
      url: "https://google.com",
      user_email: "test@nappy.co",
      title: "Check reset password"
    ]

    render(conn, "send_reset_password.html", assigns)
  end
end
