# Slugify

[![CI](https://github.com/jayjun/slugify/actions/workflows/main.yml/badge.svg)](https://github.com/jayjun/slugify/actions/workflows/main.yml)
[![Module Version](https://img.shields.io/hexpm/v/slugify.svg)](https://hex.pm/packages/slugify)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/slugify/)
[![Total Download](https://img.shields.io/hexpm/dt/slugify.svg)](https://hex.pm/packages/slugify)
[![License](https://img.shields.io/hexpm/l/slugify.svg)](https://github.com/jayjun/slugify/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/jayjun/slugify.svg)](https://github.com/jayjun/slugify/commits/master)

Transform strings from any language into slugs.

It works by transliterating Unicode characters into alphanumeric strings (e.g.
`字` into `zi`). All punctuation is stripped and whitespace between words are
replaced by hyphens.

This package has no dependencies.

## Examples

```elixir
Slug.slugify("Hello, World!")
"hello-world"

Slug.slugify("你好，世界")
"nihaoshijie"

Slug.slugify("Wikipedia case", separator: ?_, lowercase: false)
"Wikipedia_case"

# Remember to check for nil if a valid slug is important!
Slug.slugify("🙅‍")
nil
```

## Options

Whitespaces are replaced by separators (defaults to `-`). Pass any codepoint or
string to customize the separator, or pass `""` to have none.

```elixir
Slug.slugify("  How are   you?  ")
"how-are-you"

Slug.slugify("John Doe", separator: ?.)
"john.doe"

Slug.slugify("Wide open spaces", separator: "%20")
"wide%20open%20spaces"

Slug.slugify("Madam, I'm Adam", separator: "")
"madamimadam"
```

Slugs are forced lowercase by default, unless `lowercase: false` is passed.

```elixir
Slug.slugify("StUdLy CaPs", lowercase: false)
"StUdLy-CaPs"
```

Set `truncate` so slugs don‘t exceed a certain length. They are trimmed to the
closest word, as delimited by separators.

```elixir
Slug.slugify("Call Me Maybe", truncate: 7)
"call-me"

Slug.slugify("Call Me Maybe", truncate: 10)
"call-me"
```

To avoid transforming certain characters, pass a string (or a list of strings)
of graphemes to `ignore`.

```elixir
Slug.slugify("你好，世界", ignore: "你好")
"你好shijie"

Slug.slugify("你好，世界", ignore: ["你", "好"])
"你好shijie"
```

## Caveats

Slugify cannot differentiate between Chinese characters and Japanese Kanji.
In the same vein as other libraries, Japanese Kanji will transform into Chinese
pinyin.

## Installation

Add `:slugify` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:slugify, "~> 1.3"}
  ]
end
```

## Links

- [Documentation][2]
- [Hex][3]

## License

Copyright (c) 2017 Tan Jay Jun.

Slugify is released under [MIT](./LICENSE.md) license.

## Credits

Inspired by [Unidecode][4], [Transliteration][5] and [Slugger][6]. Data from [dzcpy/transliteration][6].

[1]: https://www.ietf.org/rfc/rfc3986.txt
[2]: https://hexdocs.pm/slugify
[3]: https://hex.pm/packages/slugify
[4]: http://search.cpan.org/~sburke/Text-Unidecode-1.30/lib/Text/Unidecode.pm
[5]: https://github.com/dzcpy/transliteration
[6]: https://github.com/h4cc/slugger
