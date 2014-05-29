load_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'stylesheets'))

# Register on the Sass path via the environment.
ENV['SASS_PATH'] = [ENV['SASS_PATH'], load_path].compact.join(File::PATH_SEPARATOR)
ENV['SASS_ENV'] ||= 'development'

# Register as a Compass extension.
begin
  require 'compass'
  Compass::Frameworks.register('base.sass', stylesheets_directory: load_path)
rescue LoadError
end

%w(
  caniuse
  env
  map
  parse-json
  parse-rules
  ruby-to-sass
  sass-to-ruby
  selector
  strftime
  url
).each do |lib|
  require "base.sass/#{lib}"
end
