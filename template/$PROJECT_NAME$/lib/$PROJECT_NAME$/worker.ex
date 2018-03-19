defmodule <%= @project_name_camel_case %>.Worker do
  use GenServer

  ### Public API

  def start_link() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  ### Server Callbacks

  def init(state) do
    {:ok, state}
  end

end
