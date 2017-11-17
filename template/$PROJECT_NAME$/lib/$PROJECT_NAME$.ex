defmodule <%= @project_name_camel_case %> do
  @moduledoc"""
  A client library for interacting with the <%= @project_name_camel_case %> API.

  The underlying HTTP calls and done through

      <%= @project_name_camel_case %>.Api

  If you need to hold state, then you can use the Worker GenServer in

      <%= @project_name_camel_case %>.Worker

  And client specific access should be placed in

      <%= @project_name_camel_case %>.Client

  Your client wrapper methods should be exposed here, using defdelegate,
  for example

      defdelegate do_something, to: <%= @project_name_camel_case %>.Client

  If you API is not complete, then you would also expose direct access to your
  API, or if you have state information (e.g. OAuth2 tokens), then use the Worker:

      defdelegate get(url, query_params \\ %{}, headers \\ []), to: <%= @project_name_camel_case %>.Api
      defdelegate post(url, body \\ nil, headers \\ []), to: <%= @project_name_camel_case %>.Api
      defdelegate call(url, method, body \\ "", query_params \\ %{}, headers \\ []), to: <%= @project_name_camel_case %>.Api
  """

end
