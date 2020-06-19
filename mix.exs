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
      description: "Transform strings from any language to slugs for URLs, filenames or fun",
      deps: deps(),
      package: package(),
      docs: [
        source_ref: @version,
        source_url: @repo_url,
        main: "Slug",
        api_reference: false,
        extra_section: []
      ]
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:jason, "~> 1.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.22", only: :docs}
    ]
  end

  defp package do
    [
      files: ["lib/slug.ex", "priv", "mix.exs", "README.md"],
      maintainers: ["Tan Jay Jun"],
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
    ]
  end
end
