defmodule Elk.App do
  @moduledoc """
  Elk consists of
    * a "runtime" which handles side effects e.g. http, timer, file io
    * an Elk App to be implemented by the user

    ## Lifecycle:

    Runtime calls MyApp.init(args) => { model, commands } or model
    loop:
      receive command
      perform side effects defined by the command
      calls MyApp.update(model, message)

  An Elk Application consists of
    * model:   The state of an App. May be any Elixir data, typically a struct
    * message: Sent by the Elk runtime to the App's update function
               May be any Elixir data, typically an atom or a struct if the message should contain data
    * command: Defined by Elk
               Sent by the App to the Elk runtime.
               Executed by the Elk runtime
               If command contains a message the App's update function will be called after the command has been executed
    * update:  pure function to be implemented by the user.
               Takes the model and message and return the updated model and optionaly commands
    * init:    pure function to be implemented by the user.
               Takes some used defined arguments returns a model and optionally a commdn
  """
  defstruct [:init, :update]

  @type args :: term()
  @type msg :: term()
  @type cmd :: term()
  @type model :: term()

  @doc """
  Takes some user defined args and returns the initial.
  If command is return it will be executed by the runtime.
  Must (at least should be) pure.
  """
  @callback init(args) :: model | {model, cmd}

  @doc """
  Updates given model based on the given maessage.
  If command is return it will be executed by the runtime.
  Must (at least should be) pure.
  """
  @callback update(model, msg) :: model | {model, cmd}
end
