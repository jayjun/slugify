defmodule Slug do
  @moduledoc """
  Transform strings from any language into slugs.

  It works by transliterating Unicode characters into alphanumeric strings (e.g.
  `字` into `zi`). All punctuation is stripped and whitespace between words are
  replaced by hyphens.
  """

  @punctuation ~c"!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"

  @doc """
  Returns `string` as a slug or `nil` if it failed.

  ## Options

    * `:separator` - Replace whitespaces with this string. Leading, trailing or
    repeated whitespaces are trimmed. Defaults to `-`.
    * `:lowercase` - Set to `false` if you wish to retain capitalization.
    Defaults to `true`.
    * `:truncate` - Truncates slug at this character length, shortened to the
    nearest word.
    * `:ignore` - Pass in a string (or list of strings) of characters to ignore.

  ## Examples

      iex> Slug.slugify("Hello, World!")
      "hello-world"

      iex> Slug.slugify("Madam, I'm Adam", separator: "")
      "madamimadam"

      iex> Slug.slugify("StUdLy CaPs", lowercase: false)
      "StUdLy-CaPs"

      iex> Slug.slugify("Call me maybe", truncate: 10)
      "call-me"

      iex> Slug.slugify("你好，世界", ignore: ["你", "好"])
      "你好-shi-jie"

  """
  @doc since: "1.0.0"
  @spec slugify(String.t(), Keyword.t()) :: String.t() | nil
  def slugify(string, opts \\ []) do
    separator = get_separator(opts)
    lowercase? = Keyword.get(opts, :lowercase, true)
    truncate_length = get_truncate_length(opts)
    ignored_codepoints = to_charlist(separator) ++ get_ignored_codepoints(opts)

    regex_punctuation =
      @punctuation
      |> Enum.filter(fn c -> c not in ignored_codepoints end)
      |> to_string()

    regex = "[" <> Regex.escape(separator) <> Regex.escape(regex_punctuation) <> "[:space:]]"

    string
    |> String.graphemes()
    |> Enum.map_join(&transliterate(&1, ignored_codepoints))
    |> String.replace("'", "")
    |> String.replace("`", "")
    |> String.split(Regex.compile!(regex, [:unicode]), trim: true)
    |> Enum.filter(&(&1 != ""))
    |> join(separator, truncate_length)
    |> lower_case(lowercase?)
    |> validate_slug()
  end

  defp get_separator(opts) do
    separator = Keyword.get(opts, :separator)

    case separator do
      separator when is_integer(separator) and separator >= 0 ->
        <<separator::utf8>>

      separator when is_binary(separator) ->
        separator

      _ ->
        "-"
    end
  end

  defp get_truncate_length(opts) do
    length = Keyword.get(opts, :truncate)

    case length do
      length when is_integer(length) and length <= 0 ->
        0

      length when is_integer(length) ->
        length

      _ ->
        nil
    end
  end

  defp get_ignored_codepoints(opts) do
    characters_to_ignore = Keyword.get(opts, :ignore)

    string =
      case characters_to_ignore do
        characters when is_list(characters) ->
          Enum.join(characters)

        characters when is_binary(characters) ->
          characters

        _ ->
          ""
      end

    normalize_to_codepoints(string)
  end

  defp join(words, separator, nil), do: Enum.join(words, separator)

  defp join(words, separator, maximum_length) do
    words
    |> Enum.reduce_while({[], 0}, fn word, {result, length} ->
      new_length =
        case length do
          0 -> String.length(word)
          _ -> length + String.length(separator) + String.length(word)
        end

      cond do
        new_length > maximum_length ->
          {:halt, {result, length}}

        new_length == maximum_length ->
          {:halt, {[word | result], new_length}}

        true ->
          {:cont, {[word | result], new_length}}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join(separator)
  end

  defp lower_case(string, false), do: string
  defp lower_case(string, true), do: String.downcase(string)

  defp validate_slug(""), do: nil
  defp validate_slug(string), do: string

  defp normalize_to_codepoints(string) do
    string
    |> :unicode.characters_to_nfc_binary()
    |> String.to_charlist()
  end

  defp transliterate(string, acc \\ [], ignored_codepoints)

  defp transliterate(string, acc, ignored_codepoints) when is_binary(string) do
    string
    |> normalize_to_codepoints()
    |> transliterate(acc, ignored_codepoints)
  end

  defp transliterate([], acc, _ignored_codepoints) do
    acc
    |> Enum.reverse()
    |> Enum.join()
  end

  @alphanumerics Enum.concat([?A..?Z, ?a..?z, ?0..?9])
  defp transliterate([codepoint | rest], acc, ignored_codepoints)
       when codepoint in @alphanumerics do
    transliterate(rest, [<<codepoint>> | acc], ignored_codepoints)
  end

  @replacements Path.join(:code.priv_dir(:slugify), "data.etf")
                |> File.read!()
                |> :erlang.binary_to_term()
  defp transliterate([codepoint | rest], acc, ignored_codepoints) do
    if codepoint in ignored_codepoints do
      transliterate(rest, [<<codepoint::utf8>> | acc], ignored_codepoints)
    else
      case Map.get(@replacements, codepoint) do
        nil ->
          transliterate(rest, acc, ignored_codepoints)

        replacement ->
          transliterate(rest, [replacement | acc], ignored_codepoints)
      end
    end
  end
end
