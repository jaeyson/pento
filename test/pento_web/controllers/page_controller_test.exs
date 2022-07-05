defmodule PentoWeb.HomeControllerTest do
  use PentoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~ "<title>Pento</title>"
  end
end
