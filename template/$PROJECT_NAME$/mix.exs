defmodule <%= @project_name_camel_case %>.Mixfile do
  use Mix.Project

  @name    :<%= @project_name %>
  @version "0.1.0"

  @deps [
    {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
    {:jason, "~> 1.0"},
    {:httpoison, "~> 1.0"},
    {:fn_expr, "~> 0.2"},
    {:version_tasks, "~> 0.10"},
    {:ex_doc, ">= 0.0.0", only: :dev},
  ]

  @aliases [
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env == :prod
    [
      app:     @name,
      version: @version,
      elixir:  ">= <%= @elixir_version %>",
<%= if @in_umbrella? do %>
      build_path:      "../../_build",
      config_path:     "../../config/config.exs",
      deps_path:       "../../deps",
      lockfile:        "../../mix.lock",
      start_permanent: in_production,
<% else %>
      deps:    @deps,
      aliases: @aliases,
      build_embedded:  in_production,
<% end %>
    ]
  end

  def application do
    [
      mod: { <%= @project_name_camel_case %>.Application, [] },
      extra_applications: [
        :logger
      ],
    ]
  end

end
