path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'stylesheets'))

if ENV.has_key?('SASS_PATH')
  ENV['SASS_PATH'] = ENV['SASS_PATH'] + File::PATH_SEPARATOR + path
else
  ENV['SASS_PATH'] = path
end
