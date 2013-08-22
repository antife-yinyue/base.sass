# Less reset, Powerful mixins, Useful helpers. You deserve to have!
---

## Usage

```scss
// Core Variables and Mixins
@import 'variables', 'mixins';

// Adjust browser support. Defaults: ie7+ & modern browsers
@include support($legacy-webkit: false, $legacy-moz: false);

// Reset
@import 'reset';

// Helper classes
@import 'placeholders', 'helpers';

// Custom styles for your app
.selector {
  // ...
}
```

## Dependence

```ruby
gem 'compass', :git => 'https://github.com/chriseppstein/compass.git', :ref => '34159da'
```

## License

Licensed under the [MIT License](http://www.opensource.org/licenses/mit-license.php).
