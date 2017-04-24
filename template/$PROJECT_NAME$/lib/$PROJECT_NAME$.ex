defmodule <%= @project_name_camel_case %> do
  @moduledoc """
  A client library for interacting with the <%= @project_name_camel_case %> API.
  """

  defdelegate get(url, headers), to: <%= @project_name_camel_case %>.Worker
  defdelegate post(url, body, headers), to: <%= @project_name_camel_case %>.Worker

end
