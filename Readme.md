# Awesome Extensions For Sass :kiss:

[![Build Status](https://travis-ci.org/jsw0528/base.sass.svg?branch=master)](https://travis-ci.org/jsw0528/base.sass)
[![Gem Version](https://badge.fury.io/rb/base.sass.svg)](http://badge.fury.io/rb/base.sass)

> Requires Sass >= 3.3

![SassMeister](http://ww3.sinaimg.cn/large/624f9842jw1ejz905ocbhj21kw0nvdlc.jpg)

## Installation

In your [`Gemfile`](http://bundler.io/v1.6/gemfile.html):

```ruby
gem 'base.sass', '~> 1.3'
```

Or in command line:

```sh
$ gem install base.sass
```

## Usage

At top of your Sass file:

```scss
@import 'base.sass/*';
```

Then, use `-r` option in command line:

```sh
$ sass --watch -r base.sass src:dist
```

Or in `config.rb`:

```ruby
require 'base.sass'
```

## Examples

Please refer to [wiki](https://github.com/jsw0528/base.sass/wiki) page.

## Features

### Read environment variables (case insensitive)

When you run:

```sh
$ SASS_ENV=production sass --update -r base.sass src:dist
```

Then you can use `env()` in Sass files to get the value:

```scss
env(SASS_ENV) //=> production
env(sass_env) //=> production
env(sass-env) //=> production
```

> You can use any `KEY=value` if you want.

### Parse local json file

Returns a map, and the result will be cached per process.

```scss
$map: parse-json('~/Desktop/example.json');
$pkg: parse-json('package.json');

// Then, you can:
map-keys($map)
map-get($pkg, 'some key')
```

> Now you can use the same configurations both in js and css.

### Parse browser supports (case insensitive)

All supported browsers: `chrome`, `firefox`, `safari`, `ie`, `opera`, `ios`, `android`.

> Rules data are from [Can I Use](http://beta.caniuse.com/).

**Rules:**

- `last 1 version` is last versions for each browser.
- `last 2 Chrome versions` is last versions of the specified browser.
- `IE > 8` is IE versions newer than 8.
- `IE >= 8` is IE version 8 or newer.
- `iOS 7` to set browser version directly.

```scss
// You can use multi params
$browser-supports: parse-rules('last 1 version', 'IE >= 8');

// Or a list
$rules: 'last 1 version', 'IE >= 8';
$browser-supports: parse-rules($rules);

// Then, you can:
@if support-browser(Android) {
  // ...
}

@if not support-browser(ie 8) {
  // ...
}
```

### Enhanced `url()`

If you want to activate the enhanced `url()`, you should wrap paths with quotes.

```scss
url(http://a.com/b.png)
//=> url(http://a.com/b.png) # Did nothing

url('http://a.com/b.png')
//=> url(http://a.com/b.png?1399394203)

url('a.png', 'b.png')
//=> url(a.png?1399394203), url(b.png?1399394203)

url('a.eot#iefix', 'b.woff')
//=> url(a.eot?1399394203#iefix) format('embedded-opentype'), url(b.woff?1399394203) format('woff')
```

The timestamp be added automatically by default, but you can remove it, or change it to whatever string you wanted.

```scss
url('a.png', $timestamp: false)
//=> url(a.png)

url('a.png', $timestamp: '1.0.0')
//=> url(a.png?1.0.0)
```

Also, you can defined timestamp as a global configuration in `app-config` namespace:

```scss
$app-config: (
  development: (
    timestamp: '1.1.0.alpha'
  ),
  production: (
    timestamp: '1.0.0'
  )
);

url('a.png')
//=> url(a.png?1.1.0.alpha) if SASS_ENV is development
//=> url(a.png?1.0.0) if SASS_ENV is production
```

The data uri is also be supported.

```scss
url('a.png', $base64: true)
//=> url(data:image/png;base64,iVBORw...)

url('a.eot', 'b.woff', $base64: true)
//=> url(data:application/vnd.ms-fontobject;base64,HAcAA...), url(data:application/font-woff;base64,d09GR...)
```

### Powerful map functions

> Overrides official map functions to support nest keys.

```scss
map-get($map, a)
map-get($map, a, b, c)

map-delete($map, a)
map-delete($map, a, b, c)

map-has-key($map, a)
map-has-key($map, a, b, c)

map-merge($map1, $map2)
map-merge($map1, $map2, true) // deep merge
```

### Placeholder-style mixins

If you want to let css contents appear in the place where it used first time, this is yours! :sunglasses:

Please refer to [ellipsis-overflow](stylesheets/base.sass/mixins/_ellipsis-overflow.scss) mixin.

```scss
.foo {
  @include ellipsis-overflow;
}

.bar {
  @include ellipsis-overflow;
}
```

Compiles to:

```css
.foo, .bar {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
```

## Test

```sh
$ git clone https://github.com/jsw0528/base.sass && cd base.sass && rake
```

## License

Licensed under the [MIT License](http://www.opensource.org/licenses/mit-license.php).
