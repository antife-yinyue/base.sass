require 'base.sass/caniuse'
require 'base.sass/ruby-to-sass'
require 'base.sass/sass-to-ruby'
require 'base.sass/json-parse'
require 'base.sass/support'
require 'base.sass/convert'
require 'base.sass/env'
require 'base.sass/strftime'
require 'base.sass/url'
require 'base.sass/selector'


root_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
load_path = File.join(root_path, 'stylesheets')

if ENV.key? 'SASS_PATH'
  ENV['SASS_PATH'] += File::PATH_SEPARATOR + load_path
else
  ENV['SASS_PATH'] = load_path
end

ENV['SASS_ENV'] ||= 'development'
ENV['WHICH_BASE.SASS'] = root_path
