# Less reset, Powerful mixins, Utility classes. You deserve to have!
---

## Usage

```scss
// Core Variables and Mixins
@import 'variables', 'mixins';

// Adjust browser support. Defaults: ie7+ & modern browsers
@include support($legacy-webkit: false, $legacy-moz: false);

// Reset
@import 'reset';

// Utility classes
@import 'placeholders', 'utilities';

// Custom styles for your app
.class {
  // ...
}
```

## Dependence

```ruby
gem 'compass', :git => 'https://github.com/chriseppstein/compass.git', :ref => '34159da'
```

## License

Licensed under the [MIT License](http://www.opensource.org/licenses/mit-license.php).
