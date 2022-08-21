defmodule Cldr.Metazone do
  @moduledoc """
  Documentation for `Cldr.Metazone`.
  """

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
      defmodule Metazone do
        @moduledoc false
        alias Cldr.LanguageTag
        alias Cldr.Locale

        # Simpler than unquoting the backend everywhere
        defp backend, do: unquote(backend)
        defp get_locale, do: backend().get_locale()
        defp default_locale, do: backend().default_locale()

        @doc """
        Return all the metazones available for a given locale.
        Defaults to the current locale.

        ## Example

            > #{inspect(__MODULE__)}.Metazone.available_metazones(:en)
            ["bhutan", "georgia", "syowa", "hovd", "kyrgystan", "novosibirsk",
            "yakutsk", "kosrae", "line_islands", "paraguay", "wake", "irkutsk",
            ...]
        """
        @spec available_metazones() :: list(String.t()) | {:error, term()}
        @spec available_metazones(Locale.locale_name() | LanguageTag.t()) ::
                list(String.t()) | {:error, term()}
        def available_metazones(locale \\ get_locale())

        def available_metazones(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
          available_metazones(cldr_locale_name)
        end

        for locale_name <- Locale.Loader.known_locale_names(config) do
          metazones =
            locale_name
            |> Locale.Loader.get_locale(config)
            |> Map.get(:dates, %{})
            |> Map.get(:time_zone_names, %{})
            |> Map.get(:metazone, %{})

          metazone_names = Map.keys(metazones)

          def available_metazones(unquote(locale_name)) do
            unquote(Macro.escape(metazone_names))
          end
        end

        def available_metazones(locale), do: {:error, Locale.locale_error(locale)}
      end
    end
  end
end
