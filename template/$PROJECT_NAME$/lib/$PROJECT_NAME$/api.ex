defmodule <%= @project_name_camel_case %>.Api do
  use FnExpr

  @moduledoc"""
  Make generic HTTP calls a web service.  Please
  update (or remove) the tests to a sample service
  in the examples below, they refer to a sample project
  available at https://github.com/work-samples/myserver

  This includes updating the @default_service_url below
  """

  @default_service_url "http://localhost:4000"


  @doc"""
  Retrieve data from the API using any method (:get, :post, :put, :delete, etc) available

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.call("http://localhost:4000", :post, %{version: "2.0.0"}, %{user: "james"})
      {201, %{version: "2.0.0", user: "james"}}

  """
  def call(url, method, body \\ "", query_params \\ %{}, headers \\ []) do
    HTTPoison.request(
      method,
      url |> clean_url,
      body |> encode(content_type(headers)),
      headers |> clean_headers,
      query_params |> clean_params
    )
    |> case do
        {:ok, %{body: raw_body, status_code: code, headers: headers}} ->
          {code, raw_body, headers}
        {:error, %{reason: reason}} -> {:error, reason, []}
       end
    |> content_type
    |> decode
  end

  @doc"""
  Send a GET request to the API

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.get("http://localhost:4849")
      {:error, :econnrefused}

      iex> <%= @project_name_camel_case %>.Api.get("http://localhost:4000")
      {200, %{version: "0.1.0"}}

      iex> <%= @project_name_camel_case %>.Api.get("http://localhost:4000", %{user: "andrew"})
      {200, %{version: "0.1.0", user: "andrew"}}

      iex> <%= @project_name_camel_case %>.Api.get("http://localhost:4000/droids/bb10")
      {404, %{error: "unknown_resource", reason: "/droids/bb10 is not the path you are looking for"}}
  """
  def get(url, query_params \\ %{}, headers \\ []) do
    call(url, :get, "", query_params, headers)
  end

  @doc"""
  Send a POST request to the API

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.post("http://localhost:4000", %{version: "2.0.0"})
      {201, %{version: "2.0.0"}}

  """
  def post(url, body \\ nil, headers \\ []) do
    call(url, :post, body, %{}, headers)
  end

  @doc"""
  Send a PUT request to the API
  """
  def put(url, body \\ nil, headers \\ []) do
    call(url, :put, body, %{}, headers)
  end

  @doc"""
  Send a DELETE request to the API
  """
  def delete(url, query_params \\ %{}, headers \\ []) do
    call(url, :delete, "", query_params, headers)
  end

  @doc"""
  Resolve the shared secret token, if provided then simply return itself, otherwise
  lookup in the configs.

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.authorization_header("abc123")
      {"Authorization", "Bearer abc123"}

      iex> <%= @project_name_camel_case %>.Api.authorization_header()
      {"Authorization", "Bearer "}

  """
  def authorization_header(token \\ nil) do
    token
    |> case do
         nil -> Application.get_env(:<%= @project_name %>, :token)
         t -> t
       end
    |> case do
         {:system, lookup} -> System.get_env(lookup)
         t -> t
       end
    |> (fn t -> {"Authorization", "Bearer #{t}"} end).()
  end

  @doc"""
  The service's default URL, it will lookup the config,
  possibly check the env variables and default if still not found

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.service_url()
      "http://localhost:4000"

  """
  def service_url() do
    Application.get_env(:<%= @project_name %>, :service_url)
    |> case do
         {:system, lookup} -> System.get_env(lookup)
         nil -> @default_service_url
         url -> url
       end
  end

  @doc"""
  Extract the content type of the headers

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.content_type({:ok, "<xml />", [{"Server", "GitHub.com"}, {"Content-Type", "application/xml; charset=utf-8"}]})
      {:ok, "<xml />", "application/xml"}

      iex> <%= @project_name_camel_case %>.Api.content_type([])
      "application/json"

      iex> <%= @project_name_camel_case %>.Api.content_type([{"Content-Type", "plain/text"}])
      "plain/text"

      iex> <%= @project_name_camel_case %>.Api.content_type([{"Content-Type", "application/xml; charset=utf-8"}])
      "application/xml"

      iex> <%= @project_name_camel_case %>.Api.content_type([{"Server", "GitHub.com"}, {"Content-Type", "application/xml; charset=utf-8"}])
      "application/xml"
  """
  def content_type({ok, body, headers}), do: {ok, body, content_type(headers)}
  def content_type([]), do: "application/json"
  def content_type([{ "Content-Type", val } | _]), do: val |> String.split(";") |> List.first
  def content_type([_ | t]), do: t |> content_type

  @doc"""
  Encode the body to pass along to the server

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.encode(%{a: 1}, "application/json")
      "{\\"a\\":1}"

      iex> <%= @project_name_camel_case %>.Api.encode("<xml/>", "application/xml")
      "<xml/>"

      iex> <%= @project_name_camel_case %>.Api.encode(%{a: "o ne"}, "application/x-www-form-urlencoded")
      "a=o+ne"

      iex> <%= @project_name_camel_case %>.Api.encode("goop", "application/mytsuff")
      "goop"

  """
  def encode(data, "application/json"), do: Poison.encode!(data)
  def encode(data, "application/xml"), do: data
  def encode(data, "application/x-www-form-urlencoded"), do: URI.encode_query(data)
  def encode(data, _), do: data

  @doc"""
  Decode the response body

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.decode({:ok, "{\\\"a\\\": 1}", "application/json"})
      {:ok, %{a: 1}}

      iex> <%= @project_name_camel_case %>.Api.decode({500, "", "application/json"})
      {500, ""}

      iex> <%= @project_name_camel_case %>.Api.decode({:error, "{\\\"a\\\": 1}", "application/json"})
      {:error, %{a: 1}}

      iex> <%= @project_name_camel_case %>.Api.decode({:ok, "{goop}", "application/json"})
      {:error, "{goop}"}

      iex> <%= @project_name_camel_case %>.Api.decode({:error, "{goop}", "application/json"})
      {:error, "{goop}"}

      iex> <%= @project_name_camel_case %>.Api.decode({:error, :nxdomain, "application/dontcare"})
      {:error, :nxdomain}

  """
  def decode({ok, body, _}) when is_atom(body), do: {ok, body}
  def decode({ok, "", _}), do: {ok, ""}
  def decode({ok, body, "application/json"}) when is_binary(body) do
    body
    |> Poison.decode(keys: :atoms)
    |> case do
         {:ok, parsed} -> {ok, parsed}
         _ -> {:error, body}
       end
  end
  def decode({ok, body, "application/xml"}) do
    try do
      {ok, body |> :binary.bin_to_list |> :xmerl_scan.string}
    catch
      :exit, _e -> {:error, body}
    end
  end
  def decode({ok, body, _}), do: {ok, body}


  @doc"""
  Clean the URL, if there is a port, but nothing after, then ensure there's a
  ending '/' otherwise you will encounter something like
  hackney_url.erl:204: :hackney_url.parse_netloc/2

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.clean_url("http://localhost")
      "http://localhost"

      iex> <%= @project_name_camel_case %>.Api.clean_url("http://localhost:4000/b")
      "http://localhost:4000/b"

      iex> <%= @project_name_camel_case %>.Api.clean_url("http://localhost:4000")
      "http://localhost:4000/"

  """
  def clean_url(url \\ nil) do
    url
    |> endpoint_url
    |> slash_cleanup
  end

  defp endpoint_url(endpoint) do
    case endpoint do
       nil -> service_url()
       "" -> service_url()
       "/" <> _ -> service_url() <> endpoint
       _ -> endpoint
     end
  end

  defp slash_cleanup(url) do
    url
    |> String.split(":")
    |> List.last
    |> Integer.parse
    |> case do
         {_, ""} -> url <> "/"
         _ -> url
       end
  end

  @doc"""
  Clean the URL, if there is a port, but nothing after, then ensure there's a
  ending '/' otherwise you will encounter something like
  hackney_url.erl:204: :hackney_url.parse_netloc/2

  Also allow headers to be provided as a %{}, makes it easier to ensure defaults are
  set

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.clean_headers(%{})
      [{"Content-Type", "application/json; charset=utf-8"}]

      iex> <%= @project_name_camel_case %>.Api.clean_headers(%{"Content-Type" => "application/xml"})
      [{"Content-Type", "application/xml"}]

      iex> <%= @project_name_camel_case %>.Api.clean_headers(%{"Authorization" => "Bearer abc123"})
      [{"Authorization","Bearer abc123"}, {"Content-Type", "application/json; charset=utf-8"}]

      iex> <%= @project_name_camel_case %>.Api.clean_headers(%{"Authorization" => "Bearer abc123", "Content-Type" => "application/xml"})
      [{"Authorization","Bearer abc123"}, {"Content-Type", "application/xml"}]

      iex> <%= @project_name_camel_case %>.Api.clean_headers([])
      [{"Content-Type", "application/json; charset=utf-8"}]

      iex> <%= @project_name_camel_case %>.Api.clean_headers([{"apples", "delicious"}])
      [{"Content-Type", "application/json; charset=utf-8"}, {"apples", "delicious"}]

      iex> <%= @project_name_camel_case %>.Api.clean_headers([{"apples", "delicious"}, {"Content-Type", "application/xml"}])
      [{"apples", "delicious"}, {"Content-Type", "application/xml"}]

  """
  def clean_headers(h) when is_map(h) do
    %{"Content-Type" => "application/json; charset=utf-8"}
    |> Map.merge(h)
    |> Enum.map(&(&1))
  end
  def clean_headers(h) when is_list(h) do
    h
    |> Enum.filter(fn {k,_v} -> k == "Content-Type" end)
    |> case do
         [] -> [{"Content-Type", "application/json; charset=utf-8"} | h ]
         _ -> h
       end
  end

  def clean_params(query_params) when query_params == %{}, do: []
  def clean_params(query_params), do: [{:params, query_params}]

end