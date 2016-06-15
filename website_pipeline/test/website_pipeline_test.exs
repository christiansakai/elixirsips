defmodule WebsitePipeline do
  def map_titles(sites) do
    sites
    |> Enum.map(fn url -> 
      Task.async(fn ->
        url
        |> get_body 
        |> extract_title
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  def get_body(url) do
    HTTPotion.get(url).body
  end

  def extract_title(html) do
    title_pattern = ~r"<title>([^<]*)</title>"
    Regex.run(title_pattern, html) |> Enum.at(1)
  end
end

defmodule WebsitePipelineTest do
  use ExUnit.Case
  doctest WebsitePipeline

  test "Mapping a pipeline of websites" do
    sites = ["http://example.org", "http://elixir-lang.org", "http://www.erlang.org", "http://www.phoenixframework.org"]
    expected_titles = ["Example Domain", "Elixir", "Erlang Programming Language", "Phoenix"]
    assert expected_titles == WebsitePipeline.map_titles(sites)
  end

end
