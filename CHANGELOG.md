# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.3.1 (19.06.2020)

### Fixes

- Support punctuation in `:ignore` option ([#10](https://github.com/jayjun/slugify/pull/10))

## 1.3.0 (12.02.2020)

### Enhancements

- Stop using deprecated `String.normalize/2` ([d4d675](https://github.com/jayjun/slugify/commit/d4d675058a622b84a3794c80e40ca9ec89563441))
- Require Elixir 1.8 and OTP 20 ([8e56cf](https://github.com/jayjun/slugify/commit/8e56cfce3c58b7839b72dcd2012bdcb5198b96ee))

## 1.2.0 (27.08.2019)

### Enhancements

- Diacritical marks no longer delimit word boundaries ([8cb03e](https://github.com/jayjun/slugify/commit/8cb03e9dce7b511c24a21ef0a85b18d2c934f200))
- Add Latin Extended-D character set ([6435e8](https://github.com/jayjun/slugify/commit/6435e810a01f0bf297c19445405ee2a0a8e8c4ee))

### Fixes

- Delimit words with pre-existing separators ([#6](https://github.com/jayjun/slugify/pull/6))

## 1.1.0 (23.06.2017)

### Enhancements

- Add `:truncate` option to limit slug length to the nearest word ([116aa1](https://github.com/jayjun/slugify/commit/116aa1b5614379a29bb22aa0a302c35e731badde))
- Support passing codepoints (e.g. `?-`) as a separator ([8aaa94](https://github.com/jayjun/slugify/commit/8aaa94763457282e1d0312eea171eceb2ef67f47))

## 1.0.0 (22.06.2017)

Initial release :tada:
