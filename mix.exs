defmodule Sentinel.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: [
        "deps.get": ["deps.get", &gleam_deps_get/1]
      ],
      dialyzer: [
        plt_add_apps: [:mix],
        ignore_warnings: ".dialyzer_ignore.exs"
      ]
    ]
  end

  defp gleam_deps_get(_args) do
    if System.find_executable("gleam") do
      Mix.Task.run("deps.compile", ["gleam_compiler"])

      ebin = Mix.Project.build_path() |> Path.join("lib/gleam_compiler/ebin")   # ← these

      case System.cmd("elixir", ["-pa", ebin, "-S", "mix", "gleam.deps.get"],   # ← lines
             cd: "apps/engine", into: IO.stream(), stderr_to_stdout: true) do
        {_out, 0} -> :ok
        {_out, status} -> Mix.raise("gleam.deps.get failed (exit #{status})")
      end
    else
      Mix.shell().info("gleam not on PATH; skipping gleam.deps.get")
    end
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
