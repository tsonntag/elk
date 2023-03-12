defmodule Elk do
  # GenServer
  # receives commands
  # a command update app model and emit msgs

  use GenServer

  defmodule Cmd do
    defmodule Submit
      defstruct [:msg]
    end

    defmodule After do
      defstruct [:cmd, :time]
    end
  end

  def submit(msg), do: %Cmd.Submit{msg: msg}

  def after(cmd) when is_integer(time), do: %Cmd.After{cmd: cmd, after: time}

  def submit(pid, msg), do: call(pid, submit(msg))

  def start_link(app, args) do
    case GenServer.start_link(__MODULE__, app}) do
      {:ok, pid } -> call(pid, {:init, args})
      other -> other
    end
  end

  @impl true
  def init(app) do
    {:ok, {app, model = nil} }
  end

  @impl true
  def handle_call({:init, args}, from, state) do
    init_model(state)
  end

  @impl true
  def handle_call(Cmd.Submit{msg: msg}, from, state) do
    update_model(state, msg)
  end

  @impl true
  def handle_call(%Cmd.After{time: time, cmd: cmd}, from, state) do
    Logger.debug("send #{cmd} after #{time} secs")
    Process.send_after(from, time, call(cmd))
    {:noreply, state}
  end

  ###### HTTP

  def handle_call(%Elk.Http.GetCmd{url: url, msg: msg}, from, state) do
    Logger.debug("cmd: get #{url}")
    Elk.Http.schedule(:get, url, msg, fn msg -> update_model(state, msg))
    {:noreply, state}
  end

  #### private

  defp update_model({app, model}, msg) do
    case apply(app, :update, [model, msg]) do
      { model, cmds } -> call(from, cmds)
      model -> model
    end
    {:noreply, {app, model}}
  end

  defp init_model({app, model})
    case apply(app, :init, [args])
      { model, cmds } -> call(from, cmds)
      model -> model
    end
    {:noreply, {app, model}}
  end

  defp call(pid, cmds) when is_list(cmds) do
    for cmd <- cmds, do: call(pid, cmd)
  end

  defp call(pid, cmd) do
    GenServer.call(pid, cmd)
  end
end
