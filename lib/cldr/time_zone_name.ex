defmodule Cldr.TimeZoneName do
  @moduledoc """
  Support for fetching time zone info by zone name and meta zone.
  """

  alias Cldr.TimeZoneName.Info

  @doc """
  Fetches information for a given time zone and meta zone.

  ## Arguments

  * `zone_name` is an Olson time zone name (e.g. "America/Chicago").
  * `meta_zone` ts the meta zone type for the time zone (e.g. "America_Central").
  * `opts` is a keyword list of options.

  ## Options

  * `:locale` is any locale or locale name validated
    by `Cldr.validate_locale/2`. The default is
    `Cldr.get_locale()` which returns the locale
    set for the current process

  """
  @callback resolve(
              zone_name :: Elixir.Calendar.time_zone(),
              meta_zone :: String.t(),
              opts :: Keyword.t()
            ) :: {:ok, Info.t()} | {:error, term()}

  @doc false
  def cldr_backend_provider(config) do
    module = inspect(__MODULE__)
    backend = config.backend
    config = Macro.escape(config)

    quote location: :keep,
          bind_quoted: [
            module: module,
            backend: backend,
            config: config
          ] do
      defmodule TimeZoneName do
        @moduledoc false
        alias Cldr.LanguageTag
        alias Cldr.Locale

        alias Cldr.TimeZoneName.Info

        @behaviour Cldr.TimeZoneName

        # Simpler than unquoting the backend everywhere
        defp backend, do: unquote(backend)
        defp get_locale, do: backend().get_locale()
        defp default_locale, do: backend().default_locale()

        @impl Cldr.TimeZoneName
        def resolve(zone_name, meta_zone, opts \\ []) do
          resolve_by_locale(zone_name, meta_zone, opts[:locale] || get_locale())
        end

        defp resolve_by_locale(zone_name, meta_zone, %LanguageTag{
               cldr_locale_name: cldr_locale_name
             }) do
          resolve_by_locale(zone_name, meta_zone, cldr_locale_name)
        end

        for locale_name <- Locale.Loader.known_locale_names(config) do
          locale_data = Locale.Loader.get_locale(locale_name, config)

          zones =
            locale_data
            |> Map.get(:dates, %{})
            |> Map.get(:time_zone_names, %{})
            |> Map.get(:zone, %{})

          meta_zones =
            locale_data
            |> Map.get(:dates, %{})
            |> Map.get(:time_zone_names, %{})
            |> Map.get(:metazone, %{})

          defp resolve_by_locale(zone_name, meta_zone, unquote(locale_name)) do
            zones = unquote(Macro.escape(zones))
            meta_zones = unquote(Macro.escape(meta_zones))

            zone_name_parts =
              zone_name
              |> String.split("/")
              |> Enum.map(&String.downcase/1)

            zone_data =
              Enum.reduce(zone_name_parts, zones, fn part, acc ->
                Map.get(acc, part, %{})
              end)

            meta_zone_data = meta_zones[String.downcase(meta_zone)]

            if meta_zone_data do
              {:ok, Info.new(zone_data, meta_zone_data)}
            else
              {:error, "Meta zone type \"#{meta_zone}\" not found"}
            end
          end
        end

        defp resolve_by_locale(_zone_name, _meta_zone, locale),
          do: {:error, Locale.locale_error(locale)}
      end
    end
  end
end
