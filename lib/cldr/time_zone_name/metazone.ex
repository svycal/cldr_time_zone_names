defmodule Cldr.TimeZoneName.Metazone do
  @moduledoc """
  Metazone info.
  """

  alias Cldr.TimeZoneName.Variants

  defstruct [:long, :short]

  @type t :: %__MODULE__{
          long: Variants.t() | nil,
          short: Variants.t() | nil
        }

  @doc """
  Builds a metazone struct for the given data.
  """
  @spec new(data :: map()) :: t()
  def new(data) do
    %__MODULE__{long: build_variants(data[:long]), short: build_variants(data[:short])}
  end

  defp build_variants(%{} = data) do
    %Variants{
      generic: data[:generic],
      standard: data[:standard],
      daylight: data[:daylight]
    }
  end

  defp build_variants(_), do: nil
end
