defmodule PentoWeb.UserSessionControllerTest do
  use PentoWeb.ConnCase, async: true

  alias Pento.Accounts
  import Pento.AccountsFixtures
  require IEx

  setup do
    %{user: user_fixture()}
  end

  describe "GET /login" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.user_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Register</a>"
      assert response =~ "Forgot your password?</a>"
    end

    test "redirects if already logged in", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(Routes.user_session_path(conn, :new))
      assert redirected_to(conn) == "/guess"
    end
  end

  describe "POST /login" do
    test "logs the user in", %{conn: conn, user: user} do
      path = "/guess"
      confirm_token_then_redirect(conn, user, path)
      user = Accounts.get_user!(user.id)

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email_or_username" => user.email,
            "password" => valid_user_password()
          }
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == path

      # Now do a logged in request and assert on the menu
      conn = get(conn, path)
      response = html_response(conn, 200)
      assert response =~ user.email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      path = "/guess"
      confirm_token_then_redirect(conn, user, path)
      user = Accounts.get_user!(user.id)

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email_or_username" => user.email,
            "password" => valid_user_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_pento_web_user_remember_me"]
      assert redirected_to(conn) == path
    end

    test "logs the user in with return to", %{conn: conn, user: user} do
      path = "/guess"
      confirm_token_then_redirect(conn, user, path)
      user = Accounts.get_user!(user.id)

      conn =
        conn
        |> post(Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email_or_username" => user.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == path
    end

    test "emits error message with invalid credentials", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email_or_username" => user.email,
            "password" => "invalid_password"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Invalid email or password"
    end
  end

  describe "DELETE /logout" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end

  defp confirm_token_then_redirect(conn, user, path) do
    token =
      extract_user_token(fn url ->
        Accounts.deliver_user_confirmation_instructions(user, url)
      end)

    conn
    |> init_test_session(user_return_to: path)
    |> post(Routes.user_confirmation_path(conn, :update, token))
  end
end
