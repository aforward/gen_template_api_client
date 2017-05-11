defmodule <%= @project_name_camel_case %>.Application do

  @moduledoc false

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(<%= @project_name_camel_case %>.Worker, []),
    ]

    opts = [
      strategy: :one_for_one,
      name:     <%= @project_name_camel_case %>.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
