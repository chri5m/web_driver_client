defmodule WebDriverClient.TestData do
  @moduledoc """
  StreamData generators used by the project
  """
  use ExUnitProperties

  alias WebDriverClient.Config
  alias WebDriverClient.Element
  alias WebDriverClient.Session
  alias WebDriverClient.ShadowRoot

  @spec session(keyword()) :: StreamData.t(Session.t())
  def session(opts \\ []) when is_list(opts) do
    [
      config: config(),
      id: session_id()
    ]
    |> Keyword.merge(opts)
    |> fixed_map()
    |> map(&struct!(Session, &1))
  end

  @spec config(keyword) :: StreamData.t(Config.t())
  def config(opts \\ []) when is_list(opts) do
    [
      base_url: constant("http://foo")
    ]
    |> Keyword.merge(opts)
    |> fixed_map()
    |> map(&struct!(Config, &1))
  end

  @spec element(keyword) :: StreamData.t(Element.t())
  def element(opts \\ []) when is_list(opts) do
    [
      id: element_id()
    ]
    |> Keyword.merge(opts)
    |> fixed_map()
    |> map(&struct!(Element, &1))
  end

  @spec shadow_root(keyword) :: StreamData.t(ShadowRoot.t())
  def shadow_root(opts \\ []) when is_list(opts) do
    [
      id: shadow_root_id()
    ]
    |> Keyword.merge(opts)
    |> fixed_map()
    |> map(&struct!(ShadowRoot, &1))
  end

  @spec session_id :: StreamData.t(Session.id())
  def session_id do
    string(:alphanumeric, length: 20)
  end

  @spec element_id :: StreamData.t(Session.id())
  def element_id do
    string(:alphanumeric, length: 20)
  end

  @spec shadow_root_id :: StreamData.t(Session.id())
  def shadow_root_id do
    string(:alphanumeric, length: 20)
  end

  @spec attribute_name :: StreamData.t(String.t())
  def attribute_name do
    string(:alphanumeric, min_length: 1, max_length: 10)
  end

  @spec property_name :: StreamData.t(String.t())
  def property_name do
    string(:alphanumeric, min_length: 1, max_length: 10)
  end
end
