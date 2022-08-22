defmodule Cldr.TimeZoneName do
  @moduledoc """
  TODO
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
      defmodule TimeZoneName do
        @moduledoc false
        alias Cldr.LanguageTag
        alias Cldr.Locale

        alias Cldr.TimeZoneName.Metazone

        # Simpler than unquoting the backend everywhere
        defp backend, do: unquote(backend)
        defp get_locale, do: backend().get_locale()
        defp default_locale, do: backend().default_locale()

        @doc """
        Returns all the metazone types available for a given locale.

        Defaults to the current locale.

        ## Example

            > #{inspect(__MODULE__)}.TimeZoneName.available_metazones(:en)
            ["bhutan", "georgia", "syowa", "hovd", "kyrgystan", "novosibirsk",
            "yakutsk", "kosrae", "line_islands", "paraguay", "wake", "irkutsk",
            ...]
        """
        @spec available_metazones() :: list(String.t()) | {:error, term()}
        @spec available_metazones(Locale.locale_name() | LanguageTag.t()) ::
                list(String.t()) | {:error, term()}
        def available_metazones(locale \\ get_locale())

        def available_metazones(%LanguageTag{} = tag) do
          tag
          |> locale_for_tag()
          |> available_metazones()
        end

        @doc """
        Fetches a metazone by type.
        """
        @spec metazone_for_type(type :: String.t(), opts :: Keyword.t()) ::
                {:ok, Metazone.t()} | {:error, term()}
        def metazone_for_type(type, opts \\ []) do
          metazone_for_type_with_locale(opts[:locale] || get_locale(), type)
        end

        defp metazone_for_type_with_locale(%LanguageTag{} = tag, type) do
          tag
          |> locale_for_tag()
          |> metazone_for_type_with_locale(type)
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

          defp metazone_for_type_with_locale(unquote(locale_name), type) do
            metazones = unquote(Macro.escape(metazones))

            if data = metazones[type] do
              {:ok, Metazone.new(data)}
            else
              {:error, "Metazone type \"#{type}\" not found"}
            end
          end
        end

        def available_metazones(locale), do: {:error, Locale.locale_error(locale)}

        defp metazone_for_type_with_locale(locale, _type),
          do: {:error, Locale.locale_error(locale)}

        defp locale_for_tag(%LanguageTag{cldr_locale_name: cldr_locale_name}),
          do: cldr_locale_name
      end
    end
  end
end
