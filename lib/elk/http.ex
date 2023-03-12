defmodule Elk.Http do

  require Logger

  defmodule GetCmd do
    defstruct [:url, :msg]
  end

  def get(url, msg) do
    %GetCmd{url: url, msg: msg}
  end

  @doc """
  Executes get(url) asynchronically
  Calls msg_handler({msg, :ok|:error, http_response}) where
  response_msg is {msg}
  """
  def schedule(:get, url, msg, msg_handler)  do
    Logger.debug("scheduling http get(#{url}")
    Task.async(fn ->
      Logger.debug("submit http get #{url}")
      rsp = Elk.HttpClient.get(url)
      Logger.debug("http get: received #{rsp}")
      response_msg = { msg, rsp }
      Logger.debug("http get: handling #{response_msg}")
      msg_handler.(response_msg)
    end)
  end

end
