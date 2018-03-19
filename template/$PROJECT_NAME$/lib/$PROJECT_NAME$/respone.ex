defmodule <%= @project_name_camel_case %>.Response do
  @moduledoc"""
  Take a raw HTTPoison response and normalize it down into a 3-tuple response.

  For *successful* responses (i.e. we got _an_ answer back, not necessarily
  what we wanted, but the API did send us back something), we return the
  following structure:

      {status_code, raw_body, headers}

  For example,

      {200, "{\\"answer\\": 42}", [{"Content-Type", "application/json"}]}

  If however, an error occurs (as in we couldn't reach the service at all),
  we return (still a 3-tuple) with the following structure:

      {:error, reason, []}

  For example,

      {:error, :nxdomain, []}

  Note that we do not send back any headers for errors, just a `:error`
  atom and a reason (which could be an atom, a string, or maybe even
  a JSON like response).
  """

  @doc"""
  Normalize the HTTPoison response into it's usable form within this library.

  ## Example

      iex> <%= @project_name_camel_case %>.Response.normalize({:ok, %{body: "{\\"answer\\": 42}", status_code: 200, headers: [{"Content-Type", "application/json"}]}})
      {200, "{\\"answer\\": 42}", [{"Content-Type", "application/json"}]}

      iex> <%= @project_name_camel_case %>.Response.normalize({:error, %{reason: :nxdomain}})
      {:error, :nxdomain, []}

  """
  def normalize({:ok, %{body: raw_body, status_code: code, headers: headers}}) do
    {code, raw_body, headers}
  end

  def normalize({:error, %{reason: reason}}) do
    {:error, reason, []}
  end

end