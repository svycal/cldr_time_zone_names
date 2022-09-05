defmodule Cldr.TimeZoneNameTest do
  @moduledoc false
  use ExUnit.Case
  doctest Cldr.TimeZoneName

  alias Cldr.TimeZoneName.{Info, Variants}
  alias Cldr.TimeZoneName.TestBackend

  describe "resolve/3" do
    test "fetches the meta zone data" do
      assert {:ok,
              %Info{
                long: %Variants{
                  daylight: "Central Daylight Time",
                  generic: "Central Time",
                  standard: "Central Standard Time"
                },
                short: %Variants{daylight: "CDT", generic: "CT", standard: "CST"},
                exemplar_city: "Chicago"
              }} =
               TestBackend.TimeZoneName.resolve("America/Chicago", "america_central", locale: :en)
    end

    test "accepts regular-cased meta zone names" do
      assert {:ok, %Info{exemplar_city: "Chicago"}} =
               TestBackend.TimeZoneName.resolve("America/Chicago", "America_Central", locale: :en)
    end

    test "merges in zone-specific overrides" do
      assert {:ok, %Info{long: %Variants{daylight: "British Summer Time"}}} =
               TestBackend.TimeZoneName.resolve("Europe/London", "gmt", locale: :en)

      assert {:ok, %Info{exemplar_city: "St. Barthélemy"}} =
               TestBackend.TimeZoneName.resolve("America/St_Barthelemy", "atlantic", locale: :en)

      assert {:ok, %Info{long: %Variants{standard: "Coordinated Universal Time"}}} =
               TestBackend.TimeZoneName.resolve("Etc/UTC", "gmt", locale: :en)
    end

    test "translates in non-English" do
      assert {:ok,
              %Info{
                long: %Variants{
                  daylight: "heure d’été du Centre",
                  generic: "heure du centre nord-américain",
                  standard: "heure normale du centre nord-américain"
                },
                short: %Variants{daylight: "HEC", generic: "HC", standard: "HNC"}
              }} =
               TestBackend.TimeZoneName.resolve("America/Chicago", "america_central", locale: :fr)
    end

    test "defaults to the current cldr locale" do
      TestBackend.put_locale("en")
      locale = :en

      assert TestBackend.TimeZoneName.resolve("America/Chicago", "america_central") ==
               TestBackend.TimeZoneName.resolve("America/Chicago", "america_central",
                 locale: locale
               )
    end

    test "errors if locale is unknown" do
      assert {:error, {Cldr.UnknownLocaleError, "The locale :foo is not known."}} =
               TestBackend.TimeZoneName.resolve("America/Chicago", "america_central", locale: :foo)
    end

    test "errors if metazone is not found" do
      assert {:error, "Meta zone type \"foo\" not found"} =
               TestBackend.TimeZoneName.resolve("America/Chicago", "foo")
    end
  end
end
