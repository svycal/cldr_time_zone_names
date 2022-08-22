defmodule Cldr.TimeZoneName.TestBackend do
  @moduledoc """
  A CLDR backend for tests.
  """

  require Cldr.TimeZoneName

  use Cldr,
    default_locale: "en",
    locales: ["en"],
    providers: [Cldr.TimeZoneName]
end
