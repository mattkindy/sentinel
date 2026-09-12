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
