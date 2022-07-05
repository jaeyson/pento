defmodule PentoWeb.UserSessionController do
  use PentoWeb, :controller

  alias Pento.Accounts
  alias PentoWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email_or_username" => email_or_username, "password" => password} = user_params

    if user = Accounts.get_user_by_email_or_username_and_password(email_or_username, password) do
      if user.confirmed_at do
        UserAuth.log_in_user(conn, user, user_params)
      else
        conn
        |> put_flash(:info, "Please check your email for confirmation link")
        |> redirect(to: "/login")
        |> halt()
      end
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
