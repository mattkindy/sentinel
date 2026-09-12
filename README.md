# sentinel

Sentinel is a systematic trading system that makes portfolio decisions on a daily clock and runs protective monitoring continuously. It has two functional layers: tactical strategies (initially time-series momentum) that generate positions, and a regime model built on market internals (breadth, credit, volatility structure, sentiment) that scales gross exposure.

The system is implemented in Gleam and Elixir on the BEAM, in a single Mix umbrella. The backtester and live engine share the same decision code and differ only in event source and order sink. All state transitions are recorded in an append-only SQLite journal, which serves as the recovery mechanism, audit trail, and (via point-in-time feature persistence) future model training data.

## Prerequisites

- [mise](https://mise.jdx.dev) — manages the Erlang/Elixir/Gleam toolchain.

```sh
  curl https://mise.run | sh
```

  Then put mise's shims on your PATH (in `~/.bash_profile`, `~/.zshrc`, etc.):

```sh
  export PATH="$HOME/.local/share/mise/shims:$PATH"
```

  Shims are sufficient; `mise activate` shell integration is optional and
  not required for this project. Note for stock macOS bash (3.2): the
  activation hook may conflict with other prompt hooks — use shims.

## Setup

```sh
git clone <repo-url> && cd sentinel
mise install        # installs pinned Erlang/Elixir/Gleam; Erlang compiles
                    # from source the first time (~10-20 min)
mix deps.get
mix compile
mix test            # includes the Gleam↔Elixir boundary tests
```

## Testing

Run all tests from the repo root:

```sh
mix test
```

This runs ExUnit tests in every app. Gleam tests (in `apps/engine/test/*.gleam`)
are compiled by the Gleam compiler and executed through an ExUnit bridge
(`apps/engine/test/gleam_test.exs`) that invokes EUnit on each compiled test
module. When you add a new Gleam test module, add a corresponding line to the
bridge. This requires `:eunit` in engine's `extra_applications`.

**Do not run `mix gleam.test`.** It assumes every umbrella app is a Gleam
project: it crashes when it reaches `compute`, and its failed run corrupts
dependency state, after which builds fail with
`The task "compile.gleam" could not be found`.

### Troubleshooting: `compile.gleam could not be found`

This error almost never means the mix_gleam archive is missing — check
`mix archive` first (it should list `mix_gleam`). It means a Mix invocation
ran in a context where the archive doesn't load. Causes, in order of
likelihood:

1. Stale generated files in the Gleam deps (common after a failed
   `mix gleam.test`). Fix:gi

```sh
   mix deps.clean gleam_stdlib gleeunit
   mix deps.get
```

2. A `MIX_HOME` or `MIX_ARCHIVES` override pointing at the wrong location.
   Archives live inside the mise-managed Elixir install
   (`~/.local/share/mise/installs/elixir/<version>/.mix/archives`), not
   `~/.mix`. Fix: `unset MIX_HOME MIX_ARCHIVES` and remove any such exports
   from your shell profile.

3. The archive is genuinely missing (fresh machine, or after changing the
   Elixir version in `mise.toml` — archives are installed per Elixir
   version). Fix:

```sh
   mix archive.install hex mix_gleam --force
```
