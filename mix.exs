defmodule CldrTimeZoneNames.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ex_cldr_time_zone_names,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Cldr Time Zone Names",
      source_url: "https://github.com/svycal/cldr_time_zone_names",
      homepage_url: "https://github.com/svycal/cldr_time_zone_names",
      docs: docs(),
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_cldr, "~> 2.27"},
      {:jason, "~> 1.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: [
        "README.md",
        "CHANGELOG.md",
        "LICENSE.md"
      ]
    ]
  end

  defp description do
    "A plugin for ex_cldr that packages time zone name definitions."
  end

  defp package do
    [
      maintainers: ["Derrick Reimer"],
      licenses: ["MIT"],
      links: links()
    ]
  end

  def links do
    %{
      "GitHub" => "https://github.com/svycal/cldr_time_zone_names",
      "Changelog" =>
        "https://github.com/svycal/cldr_time_zone_names/blob/v#{@version}/CHANGELOG.md",
      "Readme" => "https://github.com/svycal/cldr_time_zone_names/blob/v#{@version}/README.md"
    }
  end
end
