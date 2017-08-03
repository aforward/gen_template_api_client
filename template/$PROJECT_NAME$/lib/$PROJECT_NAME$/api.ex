defmodule <%= @project_name_camel_case %>.Api do
  use FnExpr

  @moduledoc"""
  Make generic HTTP calls a web service.  Please
  update (or remove) the tests to a sample service
  in the examples below.
  """

  @doc"""
  Retrieve data from the API using any method (:get, :post, :put, :delete, etc) available

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.call(:get, %{source: "https://raw.githubusercontent.com/aforward/webfiles/master/x.txt"})
      {:ok, "A text file\\n"}

      iex> <%= @project_name_camel_case %>.Api.call(:post, %{source: "https://raw.githubusercontent.com/aforward/webfiles/master/x.txt"})
      {:error, "Expected a 200, received 400\\n400: Invalid request\\n"}
  """
  def call(method, %{source: source, body: body, headers: headers}), do: request(method, source, body, headers)
  def call(method, %{source: source, body: body}), do: request(method, source, body, %{})
  def call(method, %{source: source, headers: headers}), do: request(method, source, headers)
  def call(method, %{source: source}), do: request(method, source, %{})

  @doc"""
  Make an API call using GET.  Optionally provide any required headers

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.get("https://raw.githubusercontent.com/aforward/webfiles/master/x.txt")
      {:ok, "A text file\\n"}

      iex> <%= @project_name_camel_case %>.Api.get("https://raw.githubusercontent.com/aforward/webfiles/master/x.txt", %{content_type: "text/html"})
      {:ok, "A text file\\n"}

      iex> <%= @project_name_camel_case %>.Api.get("https://raw.githubusercontent.com/aforward/webfiles/master/missing.txt")
      {:error, "Expected a 200, received 404\\n404: Not Found\\n"}

      iex> <%= @project_name_camel_case %>.Api.get("http://localhost:1")
      {:error, :econnrefused}

  """
  def get(source, headers \\ %{}), do: request(:get, source, headers)

  @doc"""
  Make an API call using POST.  Optionally provide any required data and headers

  Sorry, the examples suck and only show the :error case.

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.post("https://raw.githubusercontent.com/aforward/webfiles/master/x.txt")
      {:error, "Expected a 200, received 400\\n400: Invalid request\\n"}

      iex> <%= @project_name_camel_case %>.Api.post("https://raw.githubusercontent.com/aforward/webfiles/master/x.txt", %{a: "b"})
      {:error, "Expected a 200, received 400\\n400: Invalid request\\n"}

      iex> <%= @project_name_camel_case %>.Api.post("https://raw.githubusercontent.com/aforward/webfiles/master/x.txt", %{}, %{body_type: "application/json"})
      {:error, "Expected a 200, received 400\\n400: Invalid request\\n"}

      iex> <%= @project_name_camel_case %>.Api.post("http://localhost:1")
      {:error, :econnrefused}

  """
  def post(source, body \\ %{}, headers \\ %{}), do: request(:post, source, body, headers)

  @doc"""
  Make an API call using PUT.  Optionally provide any required data and headers
  """
  def put(source, body \\ %{}, headers \\ %{}), do: request(:put, source, body, headers)

  @doc"""
  Make an API call using DELETE.  Optionally provide any required data and headers
  """
  def delete(source, body \\ %{}, headers \\ %{}), do: request(:delete, source, body, headers)


  @doc"""
  Encode the provided hash map for the URL.

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.encode_body(%{a: "one", b: "two"})
      "a=one&b=two"

      iex> <%= @project_name_camel_case %>.Api.encode_body(%{a: "o ne"})
      "a=o+ne"

      iex> <%= @project_name_camel_case %>.Api.encode_body(nil, %{a: "o ne"})
      "a=o+ne"

      iex> <%= @project_name_camel_case %>.Api.encode_body("application/x-www-form-urlencoded", %{a: "o ne"})
      "a=o+ne"

      iex> <%= @project_name_camel_case %>.Api.encode_body("application/json", %{a: "b"})
      "{\\"a\\":\\"b\\"}"

  """
  def encode_body(map), do: encode_body(nil, map)
  def encode_body(nil, map), do: encode_body("application/x-www-form-urlencoded", map)
  def encode_body("application/x-www-form-urlencoded", map), do: URI.encode_query(map)
  def encode_body("application/json", map), do: Poison.encode!(map)
  def encode_body(_, map), do: encode_body(nil, map)

  @doc"""
  Build the headers for your API

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.encode_headers(%{content_type: "application/json", bearer: "abc123"})
      [{"Authorization", "Bearer abc123"}, {"Content-Type", "application/json"}]

      iex> <%= @project_name_camel_case %>.Api.encode_headers(%{bearer: "abc123"})
      [{"Authorization", "Bearer abc123"}]

      iex> <%= @project_name_camel_case %>.Api.encode_headers(%{})
      []

      iex> <%= @project_name_camel_case %>.Api.encode_headers()
      []

      iex> <%= @project_name_camel_case %>.Api.encode_headers(nil)
      []

  """
  def encode_headers(), do: encode_headers(%{})
  def encode_headers(nil), do: encode_headers(%{})
  def encode_headers(data) do
    data
    |> reject_nil
    |> invoke(fn clean_data -> Map.merge(default_headers(), clean_data) end)
    |> Enum.map(&header/1)
    |> Enum.reject(&is_nil/1)
  end
  defp header({:bearer, bearer}), do: {"Authorization", "Bearer #{bearer}"}
  defp header({:content_type, content_type}), do: {"Content-Type", content_type}
  defp header({:body_type, _}), do: nil

  defp parse({:ok, %HTTPoison.Response{status_code: 200} = resp}), do: parse(resp)
  defp parse({:ok, %HTTPoison.Response{status_code: 202} = resp}), do: parse(resp)
  defp parse({:ok, %HTTPoison.Response{status_code: code, body: body}}) do
    message = body |> String.replace("\\\"", "\"")
    {:error, "Expected a 200, received #{code}\n#{message}"}
  end
  defp parse({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
  defp parse(%HTTPoison.Response{body: body}), do: {:ok, body}

  defp request(method, source, headers) do
    source
    |> invoke(HTTPoison.request(method, &1, "", encode_headers(headers)))
    |> parse
  end

  defp request(method, source, body, headers) do
    source
    |> invoke(HTTPoison.request(
         method,
         &1,
         encode_body(headers[:body_type] || headers[:content_type], body),
         encode_headers(headers)
       ))
    |> parse
  end

  defp reject_nil(map) do
    map
    |> Enum.reject(fn{_k,v} -> v == nil end)
    |> Enum.into(%{})
  end

  @doc"""
  The default headers that all request should have.  For example,

        bearer: <API TOKEN>
        content: <mime_type>

  For example,

        %{bearer: Application.get(:<%= @project_name %>, :api_token)
          content_type: "application/json"}
  """
  def default_headers, do: %{}

end