defmodule WebDriverClient.JSONWireProtocolClient.Commands.SwitchToFrame do
  @moduledoc false

  alias WebDriverClient.Config
  alias WebDriverClient.ConnectionError
  alias WebDriverClient.Element
  alias WebDriverClient.HTTPResponse
  alias WebDriverClient.JSONWireProtocolClient.ResponseParser
  alias WebDriverClient.JSONWireProtocolClient.TeslaClientBuilder
  alias WebDriverClient.JSONWireProtocolClient.UnexpectedResponseError
  alias WebDriverClient.JSONWireProtocolClient.WebDriverError
  alias WebDriverClient.Session

  @spec send_request(Session.t(), integer() | binary() | Element.t()) ::
          {:ok, HTTPResponse.t()} | {:error, ConnectionError.t()}
  def send_request(%Session{id: id, config: %Config{} = config}, frame)
      when is_binary(id) do
    client = TeslaClientBuilder.build_simple(config)
    url = "/session/#{id}/frame"

    request_body =
      case frame do
        frame when is_integer(frame) ->
          %{"id" => frame}

        frame when is_binary(frame) ->
          %{"id" => %{"element-6066-11e4-a52e-4f735466cecf" => frame}}

        %Element{id: id} ->
          %{"id" => %{"element-6066-11e4-a52e-4f735466cecf" => id}}
      end

    case Tesla.post(client, url, request_body) do
      {:ok, env} ->
        {:ok, HTTPResponse.build(env)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec parse_response(HTTPResponse.t()) ::
          :ok | {:error, UnexpectedResponseError.t() | WebDriverError.t()}
  def parse_response(%HTTPResponse{} = http_response) do
    with {:ok, jwp_response} <- ResponseParser.parse_response(http_response),
         :ok <- ResponseParser.ensure_successful_jwp_status(jwp_response) do
      :ok
    end
  end
end
