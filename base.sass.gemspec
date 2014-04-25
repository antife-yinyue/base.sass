Gem::Specification.new do |spec|
  spec.name = 'base.sass'
  spec.version = '0.2.0'
  spec.summary = 'The beginning of your stylesheets'
  spec.homepage = 'https://github.com/jsw0528/base.sass'
  spec.author = 'junjun.zhang <http://MrZhang.me>'
  spec.license = 'MIT'
  spec.files = Dir[
    'lib/**/*.rb',
    'stylesheets/**/*.scss',
    'data/*.json',
    'Rakefile'
  ]

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 1.9'

  spec.add_runtime_dependency 'sass', '~> 3.3.5'
  spec.add_development_dependency 'multi_json', '~> 1.0'
end
