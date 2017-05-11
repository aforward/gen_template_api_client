defmodule <%= @project_name_camel_case %> do
  @moduledoc"""
  A client library for interacting with the <%= @project_name_camel_case %> API.

  The underlying HTTP calls and done through

    <%= @project_name_camel_case %>.Api

  Which are wrapped in a GenServer in

    <%= @project_name_camel_case %>.Worker

  And client specific access should be placed in

    <%= @project_name_camel_case %>.Client

  Your client wrapper methods should be exposed here, using defdelegate,
  for example

    defdelegate do_something, to: <%= @project_name_camel_case %>.Client

  If you API is not complete, then you would also expose direct access to your
  Worker calls:

    defdelegate http(method, data), to: <%= @project_name_camel_case %>.Worker
    defdelegate post(url, body, headers), to: <%= @project_name_camel_case %>.Worker
    defdelegate get(url, headers), to: <%= @project_name_camel_case %>.Worker
  """

end
