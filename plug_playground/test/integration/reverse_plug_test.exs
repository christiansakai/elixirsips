defmodule ReversingPlug do
  use Plug.Builder
  import Plug.Conn

  plug :hello
  plug :reverse
  plug :sender

  def hello(conn, _opts) do
    conn.resp_body("Hello World")
  end

  def reverse(conn, _) do
    conn.resp_body(String.reverse(conn.resp_body))
  end

  def sender(conn, _) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, conn.resp_body)
  end
end

defmodule ReversingPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts HelloPlug.init([])

  test "returns hello world" do
    conn = conn(:get, "/")

    conn = HelloPlug.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello World"
  end

end
