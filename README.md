# sentinel

Sentinel is a systematic trading system that makes portfolio decisions on a daily clock and runs protective monitoring continuously. It has two functional layers: tactical strategies (initially time-series momentum) that generate positions, and a regime model built on market internals (breadth, credit, volatility structure, sentiment) that scales gross exposure.

The system is implemented in Gleam and Elixir on the BEAM, in a single Mix umbrella. The backtester and live engine share the same decision code and differ only in event source and order sink. All state transitions are recorded in an append-only SQLite journal, which serves as the recovery mechanism, audit trail, and (via point-in-time feature persistence) future model training data.
