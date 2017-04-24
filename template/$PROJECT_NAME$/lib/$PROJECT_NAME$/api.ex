defmodule <%= @project_name_camel_case %>.Api do

  alias <%= @project_name_camel_case %>.Api

  @doc"""
  Post a message to the <%= @project_name_camel_case %> API by
  providing all the necessary information.  The answer will be

    If successful
    {status_code, body}

    Under error
    {:error, reason}
  """
  def post(url, body, configs) when is_map(body) and is_map(configs) do
    post(url, encode_body(body), headers(configs))
  end
  def post(url, body, headers) do
    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {status_code, Poison.decode!(body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc"""
  Send a GET message to the <%= @project_name_camel_case %> API by
  providing all the necessary information.  The answer will be

    If successful
    {status_code, body}

    Under error
    {:error, reason}
  """
  def get(url, configs) when is_map(configs) do
    get(url, headers(configs))
  end
  def get(url, headers) do
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {status_code, Poison.decode!(body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc"""
  Build the headers for your API

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.headers(%{content_type: "application/json", bearer: "abc123"})
      [{"Authorization", "Bearer abc123"}, {"Content-Type", "application/json"}]

      iex> <%= @project_name_camel_case %>.Api.headers(%{bearer: "abc123"})
      [{"Authorization", "Bearer abc123"}, {"Content-Type", "application/x-www-form-urlencoded"}]

      iex> <%= @project_name_camel_case %>.Api.headers(%{})
      [{"Content-Type", "application/x-www-form-urlencoded"}]

      iex> <%= @project_name_camel_case %>.Api.headers()
      [{"Content-Type", "application/x-www-form-urlencoded"}]

  """
  def headers(), do: headers(%{})
  def headers(nil), do: headers(%{})
  def headers(data) do
    h = %{content_type: "application/x-www-form-urlencoded"}
    |> Map.merge(reject_nil(data))
    |> Enum.map(&header/1)
  end
  defp header({:bearer, bearer}), do: {"Authorization", "Bearer #{bearer}"}
  defp header({:content_type, content_type}), do: {"Content-Type", content_type}


  @doc"""
  Encode the provided hash map for the URL.

  ## Examples

      iex> <%= @project_name_camel_case %>.Api.encode_body(%{a: "one", b: "two"})
      "a=one&b=two"

      iex> <%= @project_name_camel_case %>.Api.encode_body(%{a: "o ne"})
      "a=o+ne"

  """
  def encode_body(map), do: URI.encode_query(map)

  defp reject_nil(map) do
    map
    |> Enum.reject(fn{_k,v} -> v == nil end)
    |> Enum.into(%{})
  end
end