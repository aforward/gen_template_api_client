defmodule <%= @project_name_camel_case %>.Url do
  @moduledoc """
  Generate the appropriate <%= @project_name_camel_case %> URL based on the sending
  domain, and the desired resource.
  """

  @base_url "http://localhost:4000/v1"

  alias <%= @project_name_camel_case %>.{Opts}

  @doc """
  The API url for your domain, configurable using several `opts`
  (Keyword list of options).

  ## Available options:

    * `:base` - The base URL which defaults to `http://localhost:4000/v1`
    * `:resource` - The requested resource (e.g. /domains)

  The options above can be defaulted using `Mix.Config` configurations,
  please refer to `<%= @project_name_camel_case %>` for more details on configuring this library.

  This function returns a fully qualified URL as a string.

  ## Example

      iex> <%= @project_name_camel_case %>.Url.generate()
      "http://localhost:4000/v1"

      iex> <%= @project_name_camel_case %>.Url.generate(base: "http://localhost:4000/v2")
      "http://localhost:4000/v2"

      iex> <%= @project_name_camel_case %>.Url.generate(base: "http://localhost:4000/v2", resource: "stuff")
      "http://localhost:4000/v2/stuff"

      iex> <%= @project_name_camel_case %>.Url.generate(base: "http://localhost:4000/v2/", resource: "stuff")
      "http://localhost:4000/v2/stuff"

      iex> <%= @project_name_camel_case %>.Url.generate(base: "http://localhost:4000/v2/", resource: "/stuff")
      "http://localhost:4000/v2/stuff"

      iex> <%= @project_name_camel_case %>.Url.generate(base: "http://localhost:4000/v2", resource: "/stuff")
      "http://localhost:4000/v2/stuff"

      iex> <%= @project_name_camel_case %>.Url.generate()
      "http://localhost:4000/v1"

      iex> <%= @project_name_camel_case %>.Url.generate(resource: "logs")
      "http://localhost:4000/v1/logs"

      iex> <%= @project_name_camel_case %>.Url.generate(resource: "tags/t1")
      "http://localhost:4000/v1/tags/t1"

      iex> <%= @project_name_camel_case %>.Url.generate(resource: ["tags", "t1", "stats"])
      "http://localhost:4000/v1/tags/t1/stats"

  """
  def generate(opts \\ []) do
    opts
    |> Opts.merge([:base, :resource])
    |> (fn all_opts ->
          [
            Keyword.get(all_opts, :base, @base_url),
            Keyword.get(all_opts, :resource, [])
          ]
        end).()
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn s -> s |> String.trim("/") end)
    |> Enum.join("/")
  end
end
