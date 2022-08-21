defmodule Cldr.Metazone.TestBackend do
  @moduledoc """
  A CLDR backend for tests.
  """

  require Cldr.Metazone

  use Cldr,
    default_locale: "en",
    locales: ["en"],
    providers: [Cldr.Metazone]
end
