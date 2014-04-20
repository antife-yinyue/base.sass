Gem::Specification.new do |s|
  s.name = 'base.sass'
  s.version = '0.1.0'
  s.summary = 'The beginning of your stylesheets'
  s.author = 'junjun.zhang <http://MrZhang.me>'
  s.homepage = 'https://github.com/jsw0528/base.sass'
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.files = Dir['lib/*.rb', 'stylesheets/**/*.scss']

  s.add_development_dependency 'sass', '~> 3.3.5'
  s.add_development_dependency 'compass', '~> 1.0.0.alpha'
end
