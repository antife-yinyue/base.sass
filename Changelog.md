# Changelog

## v1.3.2

### Update data for Chrome and Opera

## v1.3.1

### Register as a Compass extension

## v1.3.0

### Adds a multifunctional helper

- caniuse($cond)

### Removes legacy functions

- browsers()
- browser-versions($browser, [$include-future])

## v1.2.0

### Upgrades `app-config()`

## v1.1.0

### Overrides official map functions to support nest keys

- map-get($map, $key-router...)
- map-remove($map, $key-router...)
- map-has-key($map, $key-router...)
- map-merge($map1, $map2, $deep: false)

### Removes legacy functions

- map-deep-merge($map1, $map2)
- map-find($map, $keys)

## v1.0.1

### Fix font url in `font-face()` for ie9

## v1.0.0

**Milestone Release**

### Extensions

- env($name)
- app-config($name)
- parse-json($path)
- strftime([$format])
- parse-rules($rules...)
- browsers()
- browser-versions($browser, [$include-future])
- url($paths...)
- nest($selectors...)
- append-selector($selector, $to-append)
- enumerate($prefix, $from, $through, [$separator])
- headings([$from], [$to])

### Functions

- comma-list([$list])
- slice($list, [$min], [$max])
- map-deep-merge($map1, $map2)
- map-find($map, $keys)
- support-browser($browser [$version])

### Mixins

- placeholder-wrapper($name)
- clearfix
- ellipsis-overflow
- inline-block
- float($side, [$important])
- font-face($font-family, $paths...)
