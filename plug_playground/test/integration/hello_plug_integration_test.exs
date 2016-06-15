defmodule Integration.HelloPlugIntegrationTest do
  use ExUnit.Case

  setup do
    Plug.Adapters.Cowboy.http HelloPlug, []
    :ok
  end

  test "fetching root gets Hello World" do
    body = fetch('/')
    assert body == 'Hello World'
  end

  def fetch(url) do
    base_url = 'http://localhost:4000/'
    {:ok, {{_version, 200, _reason}, _headers, body}} = :httpc.request(base_url ++ url) 
    body
  end
end
