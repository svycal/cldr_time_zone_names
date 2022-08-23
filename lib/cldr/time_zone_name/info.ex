defmodule Cldr.TimeZoneName.Info do
  @moduledoc """
  Time zone name info.
  """

  alias Cldr.TimeZoneName.Variants

  defstruct [:long, :short, :exemplar_city]

  @type t :: %__MODULE__{
          long: Variants.t(),
          short: Variants.t(),
          exemplar_city: String.t() | nil
        }

  @doc """
  Builds a metazone struct for the given data.
  """
  @spec new(zone_data :: map() | nil, meta_zone_data :: map() | nil) :: t()
  def new(zone_data, meta_zone_data) do
    zone_data = zone_data || %{}
    meta_zone_data = meta_zone_data || %{}

    %__MODULE__{
      long: build_variants(zone_data[:long], meta_zone_data[:long]),
      short: build_variants(zone_data[:short], meta_zone_data[:short]),
      exemplar_city: zone_data[:exemplar_city] || meta_zone_data[:exemplar_city]
    }
  end

  defp build_variants(zone_data, meta_zone_data) do
    %Variants{
      generic: zone_data[:generic] || meta_zone_data[:generic],
      standard: zone_data[:standard] || meta_zone_data[:standard],
      daylight: zone_data[:daylight] || meta_zone_data[:daylight]
    }
  end
end
