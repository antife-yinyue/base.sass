Gem::Specification.new do |spec|
  spec.name = 'base.sass'
  spec.version = '0.2.0'
  spec.summary = 'The beginning of your stylesheets'
  spec.author = 'junjun.zhang <http://MrZhang.me>'
  spec.homepage = 'https://github.com/jsw0528/base.sass'
  spec.license = 'MIT'
  spec.platform = Gem::Platform::RUBY
  spec.files = Dir['lib/*.rb', 'stylesheets/**/*.scss']

  spec.add_dependency 'sass', '~> 3.3.5'
  spec.add_dependency 'compass', '~> 1.0.0.alpha'
end
