# The base Sass structure for you and me
---

## Usage

```scss
// Core Variables and Mixins
@import 'variables', 'mixins';

// [optional] Change the legacy-support-for-ie* settings in specific contexts.
@include set-legacy-ie-support();
// [optional] Change the experimental-support settings in specific contexts.
@include capture-and-adjust-experimental();

// CSS Reset
@import 'reset';

// Custom styles for your app
.class {
  // ...
}
```

## License

Licensed under the [MIT License](http://www.opensource.org/licenses/mit-license.php).
