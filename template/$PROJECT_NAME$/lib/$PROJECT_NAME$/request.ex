defmodule <%= @project_name_camel_case %>.Request do
  @moduledoc """
  A structure to capture the request parameters to send to HTTPoision,
  this allows us to test the request without actually havig to
  send it; for ease (and speed) of testing.

  A `%Request{}` struct contains the following parts:

    * `url` - Where are we sending the request
    * `body` - What is the body of the request
    * `headers` - What headers are we sending
    * `http_opts` - All others configs, such as query `:params`

  """

  defstruct url: nil, body: "", headers: [], http_opts: []

  alias <%= @project_name_camel_case %>.{Request, Opts, Url, Content}

  @doc """
  Build a HTTP request based on the provided options, which comprise

  ## Example

      iex> <%= @project_name_camel_case %>.Request.create(resource: "logs").url
      "http://localhost:4000/v1/logs"

      iex> <%= @project_name_camel_case %>.Request.create(body: "What is life?").body
      "\\"What is life?\\""

      iex> <%= @project_name_camel_case %>.Request.create(body: "What you make it!", headers: [{"Content-Type", "application/mystuff"}]).body
      "What you make it!"

      iex> <%= @project_name_camel_case %>.Request.create(basic_auth: "api:key-abc123").headers
      [{"Authorization", "Basic #{Base.encode64("api:key-abc123")}"}]

      iex> <%= @project_name_camel_case %>.Request.create(basic_user: "api", basic_password: "key-abc123").headers
      [{"Authorization", "Basic #{Base.encode64("api:key-abc123")}"}]

      iex> <%= @project_name_camel_case %>.Request.create(bearer_auth: "key-abc456").headers
      [{"Authorization", "Bearer key-abc456"}]

      iex> <%= @project_name_camel_case %>.Request.create(bearer_auth: "key-abc456", headers: [{"Content-Type", "application/json"}]).headers
      [{"Authorization", "Bearer key-abc456"}, {"Content-Type", "application/json"}]

      iex> <%= @project_name_camel_case %>.Request.create(headers: [{"Authorization", "Bearer key-abc789"}, {"Content-Type", "application/json"}]).headers
      [{"Authorization", "Bearer key-abc789"}, {"Content-Type", "application/json"}]

      iex> <%= @project_name_camel_case %>.Request.create(params: [limit: 10], timeout: 1000).http_opts
      [params: [limit: 10], timeout: 1000]

  """
  def create(opts \\ []) do
    %Request{
      url: opts |> Url.generate(),
      body: opts |> http_body,
      headers: opts |> http_headers,
      http_opts: opts |> http_opts
    }
  end

  @doc """
  Send an HTTP request, this will use `HTTPoison` under the hood, so
  take a look at their API for additional configuration options.

  For example,

      %Request{url: "https://mailgun.local/domains"} |> Request.send(:get)
  """
  def send(%Request{url: url, body: body, headers: headers, http_opts: opts}, method) do
    HTTPoison.request(
      method,
      url,
      body,
      headers,
      opts
    )
  end

  defp http_body(opts) do
    opts[:body]
    |> Content.encode(opts |> http_headers |> Content.type)
  end

  defp http_headers(opts) do
    auth_headers =
      auth_header("Basic", opts[:basic_auth]) ||
        auth_header("Basic", "#{opts[:basic_user]}:#{opts[:basic_password]}") ||
        auth_header("Bearer", opts[:bearer_auth]) || []

    auth_headers ++ (opts[:headers] || [])
  end

  defp auth_header(_type, nil), do: nil
  defp auth_header("Basic", ":"), do: nil
  defp auth_header("Basic", val), do: [{"Authorization", "Basic #{Base.encode64(val)}"}]
  defp auth_header(type, val), do: [{"Authorization", "#{type} #{val}"}]

  defp http_opts(opts) do
    opts
    |> Keyword.drop([:base, :resource, :body, :basic_auth, :basic_user, :basic_password, :bearer_auth, :headers])
    |> Opts.merge(:http_opts)
  end
end
