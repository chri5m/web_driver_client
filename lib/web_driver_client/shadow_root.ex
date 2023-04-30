defmodule WebDriverClient.ShadowRoot do
  @moduledoc """
  A HTML ShadowRoot result found on a web page
  """

  defstruct [:id]

  @type id :: String.t()

  @type t :: %__MODULE__{id: id}
end
