# The beginning of your stylesheets.

## Usage

```scss
// The list of browsers you want to support.
// Defaults to `browsers()`.
// $supported-browsers: chrome, firefox, safari;

// Minimum browser versions that must be supported.
// The keys of this map are any valid browser according to `browsers()`.
// The values of this map are the min version that is valid for that browser according to `browser-versions($browser)`.
// $browser-minimum-versions: (firefox: '20', ie: '9');

// Set this to true to generate comments that will explain why a prefix was included or omitted.
// $debug-browser-support: true;

@import 'index';
```

## Dependence

```ruby
gem "sass", "~> 3.3.0.rc"
gem "compass", "~> 1.0.0.alpha"
```

## License

Licensed under the [MIT License](http://www.opensource.org/licenses/mit-license.php).
