defmodule <%= @project_name_camel_case %> do

  @moduledoc"""
  A client API to the <%= @project_name_camel_case %> API.

  To access direct calls to the service, you will want to use the
  `<%= @project_name_camel_case %>.Api` module.  When making requests, you can provide
  several `opts`, all of which can be defaulted using `Mix.Config`.

  Here is an example of how to configure this library

      config :<%= @project_name %>,
        base: "http://localhost:4000/v1",

        # if you have Basic Authentication
        basic_auth: "api:abc123",

        # if you have Basic Username / Password
        basic_user: "api",
        basic_password: "abc123",

        # if you have OAuth2 Authentication (aka Bearer)
        bearer_auth: "def456",

        #
        http_opts: %{
          timeout: 5000,
        }

  Our default `mix test` tests will use [Bypass](https://hex.pm/packages/bypass)
  as the `base` service URL so that we will not hit your production MailGun
  account during testing.

  Here is an outline of all the configurations you can set.

    * `:base`             - The base URL which defaults to `http://localhost:4000/v1`
    * `:basic_auth`       - Your basic authentication user name / shared key as one value, which might look like `api:abc123`
    * `:basic_user`       - Your basic authentication split between user
    * `:basic_password`   - And the password for that basic authentication
    * `:bearer_auth`      - Maybe you are using bearer authentication (think OAuth2)
    * `:http_opts`        - A passthrough map of options to send to HTTP request, more details below

  This client library uses [HTTPoison](https://hex.pm/packages/httpoison)
  for all HTTP communication, and we will pass through any `:http_opts` you provide,
  which we have shown below.

    * `:timeout`          - timeout to establish a connection, in milliseconds. Default is 8000
    * `:recv_timeout`     - timeout used when receiving a connection. Default is 5000
    * `:stream_to`        - a PID to stream the response to
    * `:async`            - if given :once, will only stream one message at a time, requires call to stream_next
    * `:proxy`            - a proxy to be used for the request; it can be a regular url or a {Host, Port} tuple
    * `:proxy_auth`       - proxy authentication {User, Password} tuple
    * `:ssl`              - SSL options supported by the ssl erlang module
    * `:follow_redirect`  - a boolean that causes redirects to be followed
    * `:max_redirect`     - an integer denoting the maximum number of redirects to follow
    * `:params`           - an enumerable consisting of two-item tuples that will be appended to the url as query string parameters

  """

  @doc"""
  Issues an HTTP request with the given method to the given url_opts.

  Args:
    * `method` - HTTP method as an atom (`:get`, `:head`, `:post`, `:put`, `:delete`, etc.)
    * `opts` - A keyword list of options to help create the URL, provide the body and/or query params

  The options above can be defaulted using `Mix.Config` configurations,
  as documented above.

  This function returns `{<status_code>, response}` if the request is successful, and
  `{:error, reason}` otherwise.

  ## Examples

      <%= @project_name_camel_case %>.request(:get, resource: "domains")

  """
  defdelegate request(method, opts \\ []), to: <%= @project_name_camel_case %>.Api

end
