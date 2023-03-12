defmodule Elk.HttpClient do

  defmodule Ok do
    defstruct [:body]
  end

  defmodule Error do
    defstruct [:body, :status_code, :reason]
  end

  @spec get(String.t()) :: %Ok{} | %Error{}
  def get(url) do
    case HTTPoison.get(url) do
       {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
          %Ok{body: body}

       {:ok, %HTTPoison.Response{body: body, status_code: status_code}  } ->
          %Error{body: body, status_code: status_code}

      {:error, %HTTPoison.Error{reason: reason}} -> %Error{reason: reason}
    end
  end
end
