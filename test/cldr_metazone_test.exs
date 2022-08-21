defmodule Cldr.MetazoneTest do
  @moduledoc false
  use ExUnit.Case
  doctest Cldr.Metazone

  alias Cldr.Metazone.TestBackend

  describe "available_metazones/1" do
    test "lists available metazones" do
      assert TestBackend.Metazone.available_metazones(:en)
             |> Enum.any?(&(&1 == "america_central"))
    end

    test "defaults to the current cldr locale" do
      TestBackend.put_locale("en")
      locale = :en

      assert TestBackend.Metazone.available_metazones() ==
               TestBackend.Metazone.available_metazones(locale)
    end

    test "errors if locale is unknown" do
      assert {:error, {Cldr.UnknownLocaleError, "The locale :foo is not known."}} =
               TestBackend.Metazone.available_metazones(:foo)
    end
  end
end
