# The beginning of your stylesheets.

[![Build Status](https://travis-ci.org/jsw0528/base.sass.svg?branch=master)](https://travis-ci.org/jsw0528/base.sass)

## Installation

```ruby
gem 'base.sass', :github => 'jsw0528/base.sass'
```

## Dependence

```ruby
gem 'sass', '~> 3.3'
```

## Rules (case insensitive)

### Browsers

```scss
browsers() //=> android, chrome, firefox, ie, ios, opera, safari
```

- `last 1 version` is last versions for each browser.
- `last 2 Chrome versions` is last versions of the specified browser.
- `IE > 8` is IE versions newer than 8.
- `IE >= 8` is IE version 8 or newer.
- `iOS 7` to set browser version directly.

## Usage

```scss
$browser-supports: parse-rules('last 1 version', 'IE >= 8');
```

## Test

```sh
$ git clone https://github.com/jsw0528/base.sass && cd base.sass && rake
```

## License

Licensed under the [MIT License](http://www.opensource.org/licenses/mit-license.php).
