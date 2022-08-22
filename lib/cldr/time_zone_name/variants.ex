defmodule Cldr.TimeZoneName.Variants do
  @moduledoc """
  A struct representing various time zone name variants.
  """

  defstruct [:generic, :standard, :daylight]

  @type t :: %__MODULE__{
          generic: String.t() | nil,
          standard: String.t() | nil,
          daylight: String.t() | nil
        }
end
