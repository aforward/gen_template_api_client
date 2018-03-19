defmodule <%= @project_name_camel_case %>.Client do

  @moduledoc"""
  Helper functions to access the <%= @project_name_camel_case %> API in a
  more succinct way.  If any features of the API are
  not directly available here, then consider using
  the `<%= @project_name_camel_case %>.Api` module directly, or raising a PR
  to add them to the client.

  All client functions includes a `opts` argument that
  can accept any lower level options including those
  for `&<%= @project_name_camel_case %>.Api.request/2`

  Here is an outline of all the configurations you can set.

    * `:base`      - The base URL which defaults to `http://localhost:4000/v1`
    * `:http_opts` - A passthrough map of options to send to HTTP request, more details below

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

  If the above values do not change between calls, then consider configuring
  them with `Mix.Config` to avoid using them throughout your code.
  """

end