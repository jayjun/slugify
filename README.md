# Slugify

[![Build Status](https://secure.travis-ci.org/jayjun/slugify.svg?branch=master "Build Status")][build-status]

Turn any string into a slug.

It works by transliterating any Unicode character to alphanumeric ones, and
replaces whitespaces with hyphens.

The goal is to generate general purpose human and machine-readable slugs. So
`-`, `.`, `_` and `~` characters are stripped from input even though they are
"unreserved" characters for URLs (see [RFC 3986][1]). Having said that, any
character can be used as a separator, including the ones above.

This package has no dependencies.

## Examples

```elixir
Slug.slugify("Hello, World!")
"hello-world"

Slug.slugify("你好，世界")
"nihaoshijie"

Slug.slugify("さようなら")
"sayounara"

Slug.slugify("🙅‍")
nil # Remember nil check if a valid slug is important!
```

## Options

You can use any string as a separator, or pass `""` to have none.

```elixir
Slug.slugify("1 2 3", separator: " != ")
"1 != 2 != 3"

Slug.slugify("Madam, I'm Adam", separator: "")
"madamimadam"
```

Slugs are forced lowercase by default, unless `lowercase: false` is passed.

```elixir
Slug.slugify("StUdLy CaPs", lowercase: false)
"StUdLy-CaPs"
```

Specific graphemes can be ignored if you pass a string (or a list of strings)
containing characters to ignore.

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

Add `slugify` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:slugify, "~> 1.0.0"}]
end
```

Don’t forget to update your dependencies.

```
$ mix deps.get
```

## License

Slugify is released under [MIT][2] license.

## Credits

* Inspired by [Unidecode][3], [Transliteration][4] and [Slugger][5].

* Data ported from andyhu's excellent [Transliteration][4] package.


[1]: https://www.ietf.org/rfc/rfc3986.txt

[2]: https://github.com/jayjun/slugify/blob/master/LICENSE

[3]: http://search.cpan.org/~sburke/Text-Unidecode-1.30/lib/Text/Unidecode.pm

[4]: https://github.com/andyhu/transliteration

[5]: https://github.com/h4cc/slugger
