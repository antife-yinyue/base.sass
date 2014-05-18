Gem::Specification.new do |spec|
  spec.name = 'base.sass'
  spec.version = '1.3.0'
  spec.summary = 'Awesome Extensions For Sass'
  spec.description = 'Awesome features that you wanted'
  spec.homepage = 'https://github.com/jsw0528/base.sass'
  spec.author = 'junjun.zhang'
  spec.email = 'i@mrzhang.me'
  spec.license = 'MIT'
  spec.files = Dir[
    'lib/**/*.rb',
    'stylesheets/**/*.scss',
    'data/*.json',
    '*.md'
  ]

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 1.9'

  spec.add_runtime_dependency 'sass', '>= 3.3', '< 3.5'
end
