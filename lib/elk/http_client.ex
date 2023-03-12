defmodule Elk.HttpClient do
  alias Elk.Http

  @spec get(String.t()) :: %Http.Ok{} | %Http.Error{}
  def get(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        %Http.Ok{body: body}

      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        %Http.Error{body: body, status_code: status_code}

      {:error, %HTTPoison.Error{reason: reason}} ->
        %Http.Error{reason: reason}
    end
  end
end
