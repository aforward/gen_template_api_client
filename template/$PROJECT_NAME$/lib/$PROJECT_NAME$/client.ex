defmodule <%= @project_name_camel_case %>.Client do
  @moduledoc"""
  Access service functionality through Elixir functions,
  wrapping the underlying HTTP API calls.

  This is where you will want to write your custom
  code to access your API, and it is probably best
  to make those calls through your API or Worker.

    <%= @project_name_camel_case %>.Api.call/5
    <%= @project_name_camel_case %>.Api.get/3
    <%= @project_name_camel_case %>.Api.post/3
    <%= @project_name_camel_case %>.Api.put/3
    <%= @project_name_camel_case %>.Api.delete/3

  An example is shown based on a
  https://github.com/work-samples/myserver

  But should be replace with your actual client calls
  """

  @doc"""
  Extract the profile data for the provided token

  ## Examples

      iex> <%= @project_name_camel_case %>.Client.profile("abc123")
      {:ok, %{answer: 42}}

      iex> <%= @project_name_camel_case %>.Client.profile("def456")
      {:error, "Forbidden; No access to this resource"}

      iex> <%= @project_name_camel_case %>.Client.profile("xxx")
      {:error, "Unauthorized; Invalid credentials"}

  """
  def profile(token \\ nil) do
    "/profile"
    |> <%= @project_name_camel_case %>.Api.get([], [<%= @project_name_camel_case %>.Api.authorization_header(token)])
    |> (fn
          {200, answer} -> {:ok, answer}
          {_, %{error: error, reason: reason}} -> {:error, "#{error}; #{reason}"}
          {_, reason} -> {:error, reason}
        end).()
  end

end


