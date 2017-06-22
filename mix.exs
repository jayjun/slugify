defmodule Slug.Mixfile do
  use Mix.Project

  def project do
    [app: :slugify,
     version: "1.0.0",
     elixir: "~> 1.4",
     name: "Slugify",
     description: "Turns any string into slugs for URLs, filenames or fun",
     deps: deps(),
     package: package()]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [{:credo, "~> 0.8", only: [:dev, :test], runtime: false}]
  end

  defp package do
    [maintainers: ["Tan Jay Jun"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/jayjun/slugify"}]
  end
end
