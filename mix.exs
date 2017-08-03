defmodule GenTemplateApiClient.Mixfile do
  use Mix.Project

  @name    :gen_template_api_client
  @version "0.1.1"

  @deps [
    { :mix_templates,  ">0.0.0",  app: false },
    { :ex_doc,         ">0.0.0",  only: [:dev, :test] },
    { :version_tasks,  "~> 0.9.1"},
  ]

  @maintainers ["Andrew Forward <aforward@gmail.com>"]
  @github      "https://github.com/aforward/#{@name}"

  @description """
  A template for building API clients to 3rd party REST applications.

  This will generate templates for get, post functions.  You then
  extend the project with convenience functions to access the API
  like it were just another Elixir lib.
  """

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env == :prod
    [
      app:     @name,
      version: @version,
      deps:    @deps,
      elixir:  "~> 1.4",
      package: package(),
      description:     @description,
      build_embedded:  in_production,
      start_permanent: in_production,
    ]
  end

  defp package do
    [
      name:        @name,
      files:       [
                      "lib", "mix.exs", "README.md", "LICENSE.md", "template",
                      "template/$PROJECT_NAME$/.gitignore",
                      "template/$PROJECT_NAME$/.iex.exs",
                   ],
      maintainers: @maintainers,
      licenses:    ["Apache 2.0"],
      links:       %{
        "GitHub" => @github,
      },
#      extra:       %{ "type" => "a_template_for_mix_gen" },
    ]
  end

end
