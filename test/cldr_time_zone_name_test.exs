defmodule Cldr.TimeZoneNameTest do
  @moduledoc false
  use ExUnit.Case
  doctest Cldr.TimeZoneName

  alias Cldr.TimeZoneName.{Metazone, Variants}
  alias Cldr.TimeZoneName.TestBackend

  describe "available_metazones/1" do
    test "lists available metazones" do
      assert TestBackend.TimeZoneName.available_metazones(:en)
             |> Enum.any?(&(&1 == "america_central"))
    end

    test "defaults to the current cldr locale" do
      TestBackend.put_locale("en")
      locale = :en

      assert TestBackend.TimeZoneName.available_metazones() ==
               TestBackend.TimeZoneName.available_metazones(locale)
    end

    test "errors if locale is unknown" do
      assert {:error, {Cldr.UnknownLocaleError, "The locale :foo is not known."}} =
               TestBackend.TimeZoneName.available_metazones(:foo)
    end
  end

  describe "metazone_for_type/2" do
    test "fetches the metazone" do
      assert %Metazone{
               long: %Variants{
                 daylight: "Central Daylight Time",
                 generic: "Central Time",
                 standard: "Central Standard Time"
               },
               short: %Variants{daylight: "CDT", generic: "CT", standard: "CST"}
             } = TestBackend.TimeZoneName.metazone_for_type("america_central", locale: :en)
    end

    test "defaults to the current cldr locale" do
      TestBackend.put_locale("en")
      locale = :en

      assert TestBackend.TimeZoneName.metazone_for_type("america_central") ==
               TestBackend.TimeZoneName.metazone_for_type("america_central", locale: locale)
    end

    test "errors if locale is unknown" do
      assert {:error, {Cldr.UnknownLocaleError, "The locale :foo is not known."}} =
               TestBackend.TimeZoneName.metazone_for_type("america_central", locale: :foo)
    end
  end
end
