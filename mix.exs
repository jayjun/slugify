defmodule Slug.Mixfile do
  use Mix.Project

  @version "1.3.1"
  @repo_url "https://github.com/jayjun/slugify"

  def project do
    [
      app: :slugify,
      version: @version,
      elixir: "~> 1.8",
      name: "Slugify",
      deps: deps(),
      package: package(),
      docs: docs(),
      preferred_cli_env: [docs: :docs]
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:jason, "~> 1.0", only: [:dev, :test, :docs]},
      {:ex_doc, ">= 0.0.0", only: :docs, runtime: false}
    ]
  end

  defp package do
    [
      description: "Transform strings from any language into slugs.",
      files: ["lib/slug.ex", "priv", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE.md"],
      maintainers: ["Tan Jay Jun"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/slugify/changelog.html",
        "GitHub" => @repo_url
      }
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", {:"LICENSE.md", [title: "License"]}, "README.md"],
      source_ref: @version,
      source_url: @repo_url,
      main: "readme",
      formatters: ["html"],
      api_reference: false
    ]
  end
end
