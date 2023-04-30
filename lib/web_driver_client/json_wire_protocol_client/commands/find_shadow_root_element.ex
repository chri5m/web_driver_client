defmodule WebDriverClient.JSONWireProtocolClient.Commands.FindShadowRootElement do
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
  alias WebDriverClient.ShadowRoot

  @spec send_request(Session.t(), Element.t()) ::
          {:ok, HTTPResponse.t()} | {:error, ConnectionError.t()}
  def send_request(%Session{id: session_id, config: %Config{} = config}, %Element{id: element_id})
      when is_binary(session_id) do
    client = TeslaClientBuilder.build_simple(config)
    url = "/session/#{session_id}/element/#{element_id}/shadow"

    case Tesla.get(client, url) do
      {:ok, env} ->
        {:ok, HTTPResponse.build(env)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec parse_response(HTTPResponse.t()) ::
          {:ok, ShadowRoot.t()} | {:error, UnexpectedResponseError.t() | WebDriverError.t()}
  def parse_response(%HTTPResponse{} = http_response) do
    with {:ok, jwp_response} <- ResponseParser.parse_response(http_response),
         :ok <- ResponseParser.ensure_successful_jwp_status(jwp_response),
         {:ok, shadow_root} <- ResponseParser.parse_element(jwp_response) do
      {:ok, shadow_root}
    end
  end
end
