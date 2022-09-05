# Cldr Time Zone Names [![Version](https://img.shields.io/hexpm/v/ex_cldr_time_zone_names)](https://hexdocs.pm/ex_cldr_time_zone_names/readme.html)

A plugin for [ex_cldr](https://hex.pm/packages/ex_cldr) that packages time zone name definitions.

## Installation

Add `ex_cldr_time_zone_names` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_cldr_time_zone_names, "~> 0.1.0"}
  ]
end
```

Then, add the plugin to your [CLDR backend](https://hexdocs.pm/ex_cldr/readme.html#backend-module-configuration):

```elixir
defmodule MyApp.Cldr do
  use Cldr,
    providers: [
      Cldr.TimeZoneNames,
      # ...
    ],
    # ...
end
```

## Usage

This plugin provides functions for looking up time zone name data for a given IANA time zone name and [meta zone name](https://github.com/unicode-org/cldr/blob/4667907abd60081c29f0b110623efc4ec545d844/common/supplemental/metaZones.xml) (e.g. `America_Central`).

```elixir
# Look up the name information for US Central Time in English
iex> MyApp.Cldr.TimeZoneName.resolve("America/Chicago", "america_central", locale: :en)
{:ok,
 %Cldr.TimeZoneName.Info{
   exemplar_city: "Chicago",
   long: %Cldr.TimeZoneName.Variants{
     daylight: "Central Daylight Time",
     generic: "Central Time",
     standard: "Central Standard Time"
   },
   short: %Cldr.TimeZoneName.Variants{
     daylight: "CDT",
     generic: "CT",
     standard: "CST"
   }
 }}
```

