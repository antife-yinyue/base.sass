path = File.expand_path(File.dirname(__FILE__))

if ENV.has_key?('SASS_PATH')
  ENV['SASS_PATH'] = ENV['SASS_PATH'] + File::PATH_SEPARATOR + path
else
  ENV['SASS_PATH'] = path
end
