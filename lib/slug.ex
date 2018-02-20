defmodule Slug do
  @moduledoc """
  Transform strings in any language into slugs.
  It works by transliterating Unicode characters into alphanumeric strings (e.g.
  `字` into `zi`). All punctuation is stripped and whitespace between words are
  replaced by hyphens.
  This package has no dependencies.
  """

  @doc """
  Returns `string` as a slug or nil if it failed.
  ## Options
    * `separator` - Replace whitespaces with this string. Leading, trailing or
    repeated whitespaces are trimmed. Defaults to `-`.
    * `lowercase` - Set to `false` if you wish to retain capitalization.
    Defaults to `true`.
    * `truncate` - Truncates slug at this character length, shortened to the
    nearest word.
    * `ignore` - Pass in a string (or list of strings) of characters to ignore.
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
      "你好shi-jie"
  """

  @on_load :init

  @alphanumerics (Enum.into(?0..?9, []) ++ Enum.into(?A..?Z, []) ++ Enum.into(?a..?z, []))

  def init do
    :ok = :erlang.load_nif("./priv/slug_nif", 0)
  end

  def do_slugify(_X) do
    exit(:nif_library_not_loaded)
  end

  def slugify(s, opts \\ []) do
    sp = get_separator(opts)
    tl = get_truncate_length(opts)
    lc? = Keyword.get(opts, :lowercase, true)
    ic = get_ignored_codepoints(opts)

    {l1, l2, l3} = Enum.reduce(to_charlist(s), {[], [], []}, fn x, {l1, l2, l3} ->
      case Enum.any?(ic, fn c -> c == x end) do
        true -> {[Enum.reverse(l3) | l1], [x | l2], []}
        false -> {l1, l2, [x | l3]}
      end
    end)

    ll1 = Enum.reverse([Enum.reverse(l3) | l1]) |> Enum.map(fn x -> to_string([x]) end)
    ll2 = Enum.reverse([[] | l2]) |> Enum.map(fn x -> to_string([x]) end)

    Enum.map(ll1, fn s ->
      cond do
        s == "" -> ""
        true ->
          s
          |> to_charlist
          |> Enum.filter(fn x -> valid_map0(x) end)
          |> to_string
          |> (fn x -> Regex.replace(~r/([\p{Mn}\p{Lm}])/u, x, "") end).()
          |> Base.encode64
          |> String.to_charlist
          |> do_slugify
          |> to_string
          |> lower_case(lc?)
          |> to_charlist
          |> Enum.map(fn x -> valid_map1(x) end)
          |> to_string
          |> String.split(" ", trim: true)
          |> join(sp, tl)
      end
    end)
    |> Enum.zip(ll2)
    |> Enum.map(fn {x, y} -> x <> y end)
    |> Enum.join("")
    |> validate_slug

  end

  # helper functions

  defp valid_map0(x) do
    cond do
      x <= 128 && !(Enum.any?(@alphanumerics, fn y -> y == x end) || x == 32) -> false
      true -> true
    end
  end

  defp valid_map1(x) do
    cond do
      Enum.any?(@alphanumerics, fn y -> y == x end) || x == 32 -> x
      true -> ' '
    end
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

  defp normalize_to_codepoints(string) do
    string
    |> String.normalize(:nfc)
    |> String.to_charlist()
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
end
