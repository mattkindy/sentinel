defmodule GleamCompiler.MixProject do
  use Mix.Project

  def project do
    [
      app: :gleam_compiler,
      version: "0.1.0",
      elixir: "~> 1.18",
      deps: []
    ]
  end

  def application, do: [extra_applications: []]
end
