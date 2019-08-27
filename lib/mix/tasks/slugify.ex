defmodule Mix.Tasks.Slugify do
  @moduledoc false
  @shortdoc "Generate replacement characters for transliteration"
  use Mix.Task

  def run(_args) do
    data = read_from_priv!("data.json")

    replacements =
      for i <- 0..255,
          characters = Map.get(data, Integer.to_string(i)),
          is_list(characters),
          {character, index} <- Enum.with_index(characters),
          into: %{} do
        codepoint = i * 256 + index
        {codepoint, character}
      end

    write_to_priv!(replacements, "data.etf")
  end

  defp read_from_priv!(filename) do
    :code.priv_dir(:slugify)
    |> Path.join(filename)
    |> File.read!()
    |> Jason.decode!()
  end

  defp write_to_priv!(replacements, filename) do
    path = Path.join(:code.priv_dir(:slugify), filename)
    data = :erlang.term_to_binary(replacements)
    File.write!(path, data)
  end
end
