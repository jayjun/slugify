defmodule Slug do
  @moduledoc """
  Turns any string into a slug.

  It works by transliterating any Unicode character to alphanumeric ones, and
  replacing whitespaces with hyphens.

  The goal is to generate general purpose human and machine-readable slugs. So
  `-`, `.`, `_` and `~` characters are stripped from input even though they are
  "unreserved" characters for URLs (see
  [RFC 3986][https://www.ietf.org/rfc/rfc3986.txt]). Having said that, any
  character can be used as a separator, including the ones above.
  """

  @doc """
  Returns `string` as a slug or nil if it failed.

  ## Options

    * `:separator` - Replace whitespaces with this string. Leading, trailing or
    repeated whitespaces are still trimmed. Defaults to `-`.
    * `:lowercase` - Set to `false` if you wish to retain
    your uppercase letters. Defaults to `true`.
    * `:ignore` - Pass in a string (or list of strings) of characters to ignore.

  ## Examples

    iex> Slug.slugify("Hello, World!")
    "hello-world"

    iex> Slug.slugify("Madam, I'm Adam", separator: "")
    "madamimadam"

    iex> Slug.slugify("StUdLy CaPs", lowercase: false)
    "StUdLy-CaPs"

    iex> Slug.slugify("你好，世界")
    "nihaoshijie"

    iex> Slug.slugify("你好，世界", ignore: ["你", "好"])
    "你好shijie"

  """
  @spec slugify(String.t, Keyword.t) :: String.t | nil
  def slugify(string, opts \\ []) do
    separator = Keyword.get(opts, :separator, "-")
    force_lowercase = Keyword.get(opts, :lowercase, true)
    ignored_codepoints =
      opts
      |> Keyword.get(:ignore, "")
      |> case do
        characters when is_list(characters) ->
          Enum.join(characters)
        characters when is_binary(characters) ->
          characters
      end
      |> normalize_to_codepoints()

    result =
      string
      |> String.split(~r{[\s]}, trim: true)
      |> Enum.map(& transliterate(&1, ignored_codepoints))
      |> Enum.join(separator)

    case separator do
      "" ->
        lower_case(result, force_lowercase)
      separator ->
        case String.replace(result, separator, "") do
          "" ->
            nil
          _ ->
            lower_case(result, force_lowercase)
        end
    end
  end

  defp lower_case(string, false), do: string
  defp lower_case(string, true), do: String.downcase(string)

  defp normalize_to_codepoints(string) do
    string
    |> String.normalize(:nfc)
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

  @alphanumerics [
    ?A, ?B, ?C, ?D, ?E, ?F, ?G, ?H, ?I, ?J, ?K, ?L, ?M, ?N, ?O, ?P, ?Q, ?R, ?S,
    ?T, ?U, ?V, ?W, ?X, ?Y, ?Z,
    ?a, ?b, ?c, ?d, ?e, ?f, ?g, ?h, ?i, ?j, ?k, ?l, ?m, ?n, ?o, ?p, ?q, ?r, ?s,
    ?t, ?u, ?v, ?w, ?x, ?y, ?z,
    ?0, ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9
  ]
  defp transliterate([codepoint | rest], acc, ignored_codepoints)
       when codepoint in @alphanumerics do
    transliterate(rest, [<<codepoint>> | acc], ignored_codepoints)
  end

  @replacements "lib/replacements.exs" |> Code.eval_file() |> elem(0)
  defp transliterate([codepoint | rest], acc, ignored_codepoints) do
    if codepoint in ignored_codepoints do
      character = List.to_string([codepoint])
      transliterate(rest, [character | acc], ignored_codepoints)
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
