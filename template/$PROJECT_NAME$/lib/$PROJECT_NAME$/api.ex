defmodule <%= @project_name_camel_case %>.Api do

  @moduledoc"""
  Take several options, and an HTTP method and send the request to <%= @project_name_camel_case %>

  The available options are comprised of those to helper generate the <%= @project_name_camel_case %>
  URL, to extract data for the request and authenticate your API call.

  URL `opts` (to help create the resolved <%= @project_name_camel_case %> URL):
    * `:base` - The base URL which defaults to `http://localhost:4000/v1`
    * `:resource` - The requested resource (e.g. /domains)

  Data `opts` (to send data along with the request)
    * `:body` - The encoded body of the request (typically provided in JSON)
    * `:params` - The query parameters of the request

  Header `opts` (to send meta-data along with the request)
    * `:api_key` - Defaults to the test API key `key-3ax6xnjp29jd6fds4gc373sgvjxteol0`
  """

  alias <%= @project_name_camel_case %>.{Content, Request, Response}

  @doc"""
  Issues an HTTP request with the given method to the given url_opts.

  Args:
    * `method` - HTTP method as an atom (`:get`, `:head`, `:post`, `:put`, `:delete`, etc.)
    * `opts` - A keyword list of options to help create the URL, provide the body and/or query params

  The options above can be defaulted using `Mix.Config` configurations,
  please refer to `<%= @project_name_camel_case %>` for more details on configuring this library.

  This function returns `{<status_code>, response}` if the request is successful, and
  `{:error, reason}` otherwise.

  ## Examples

      <%= @project_name_camel_case %>.Api.request(:get, resource: "domains")

  """
  def request(method, opts \\ []) do
    opts
    |> Request.create
    |> Request.send(method)
    |> Response.normalize
    |> Content.type
    |> Content.decode
  end

end