# Duper

Duper is the project created during [Programming Elixir 1.6][1]'s chapter 19
example.

This app is a duplicate-file finder, that works by scanning all files in a
directory tree, calculating a hash for each, and reporting those with same hash
as duplicates.

## Installation

If [available in Hex][2], the package can be installed by adding `duper` to
your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:duper, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc][3] and published on [HexDocs][4].
Once published, the docs can be found at <https://hexdocs.pm/duper>.

[1]: https://pragprog.com/titles/elixir16/programming-elixir-1-6
[2]: https://hex.pm/docs/publish
[3]: https://github.com/elixir-lang/ex_doc
[4]: https://hexdocs.pm
