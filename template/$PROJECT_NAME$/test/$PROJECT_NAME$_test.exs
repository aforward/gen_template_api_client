defmodule <%= @project_name_camel_case %>Test do
  use ExUnit.Case

  doctest <%= @project_name_camel_case %>
  doctest <%= @project_name_camel_case %>.Api
  doctest <%= @project_name_camel_case %>.Client
  doctest <%= @project_name_camel_case %>.Content
  doctest <%= @project_name_camel_case %>.Opts
  doctest <%= @project_name_camel_case %>.Request
  doctest <%= @project_name_camel_case %>.Response
  doctest <%= @project_name_camel_case %>.Url
  doctest <%= @project_name_camel_case %>.Worker
end
