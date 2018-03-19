defmodule <%= @project_name_camel_case %>.Opts do

  @moduledoc"""
  Generate API options based on overwritten values, as well as
  any configured defaults.

  Please refer to `<%= @project_name_camel_case %>` for more details on configuring this library,
  the know what can be configured.
  """

  @doc"""
  Merge the `provided_opts` with the configured options from the
  `:<%= @project_name %>` application env, available from `<%= @project_name_camel_case %>.Opts.env/0`

  ## Example

      <%= @project_name_camel_case %>.Opts.merge([resource: "messages"])
  """
  def merge(provided_opts), do: merge(provided_opts, env(), nil)


  @doc"""
  Merge the `provided_opts` with an env `configured_key`.  Or, merge those
  `provided_opts` with the default application envs in `<%= @project_name_camel_case %>.Opts.env/0`,
  but only provide values for the `expected_keys`.

  ## Example

      # Merge the provided keyword list with the Application env for `:<%= @project_name %>`
      # but only take the `expected_keys` of `[:base, :resource]`
      <%= @project_name_camel_case %>.Opts.merge([resource: "messages"], [:base, :resource])

      # Merge the provided keyword list with the `:http_opts` from the
      # Application env for `:<%= @project_name %>`
      <%= @project_name_camel_case %>.Opts.merge([resource: "messages"], :http_opts)
  """
  def merge(provided_opts, configured_key_or_expected_keys) when is_atom(configured_key_or_expected_keys) do
    merge(provided_opts, env(configured_key_or_expected_keys), nil)
  end
  def merge(provided_opts, expected_keys) when is_list(expected_keys) do
    merge(provided_opts, env(), expected_keys)
  end

  @doc"""
  Merge the `provided_opts` with the `configured_opts`.  Only provide
  values for the `expected_keys` (if `nil` then merge all keys from
  `configured_opts`).

  ## Example

      iex> <%= @project_name_camel_case %>.Opts.merge(
      ...>   [resource: "messages"],
      ...>   [base: "http://localhost:4000/v2", resource: "log", timeout: 5000],
      ...>   [:resource, :base])
      [base: "http://localhost:4000/v2", resource: "messages"]

      iex> <%= @project_name_camel_case %>.Opts.merge(
      ...>   [resource: "messages"],
      ...>   [base: "http://localhost:4000/v2", resource: "log", timeout: 5000],
      ...>   nil)
      [base: "http://localhost:4000/v2", timeout: 5000, resource: "messages"]

  """
  def merge(provided_opts, nil, _), do: provided_opts
  def merge(provided_opts, configured_opts, expected_keys) do
    case expected_keys do
      nil -> configured_opts
      k -> configured_opts |> Keyword.take(k)
    end
    |> Keyword.merge(provided_opts)
  end

  @doc"""
  Lookup all application env values for `:<%= @project_name %>`

  ## Example

      # Return all environment variables for :<%= @project_name %>
      <%= @project_name_camel_case %>.Opts.env()

  """
  def env, do: Application.get_all_env(:<%= @project_name %>)

  @doc"""
  Lookup the `key` within the `:<%= @project_name %>` application.

  ## Example

      # Return the `:<%= @project_name %>` value for the `:base` key
      <%= @project_name_camel_case %>.Opts.env(:base)
  """
  def env(key), do: Application.get_env(:<%= @project_name %>, key)

end