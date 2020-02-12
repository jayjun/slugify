# Changelog

## 1.3.0

### Enhancements

- Stop using deprecated `String.normalize/2`
- Drop support for Elixir 1.7 and below

## 1.2.0

### Enhancements

- Diacritical marks no longer delimit word boundaries
- Add Latin Extended-D character set

### Fixes

- Delimit words with pre-existing separators [#6](https://github.com/jayjun/slugify/pull/6)

## 1.1.0

### Enhancements

- Add `truncate` option to limit slug length to the nearest word
- Support passing codepoints (e.g. `?-`) as a separator

## 1.0.0

Initial release :tada:
