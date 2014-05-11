require 'json'

module Sass::Script::Functions

  $cached_files = {}

  # Parses a local json file, returns a map, and the result will be cached.
  # If the `path` is not a absolute path, relative to current process directory.
  #
  # Examples:
  # parse-json('~/Desktop/example.json')
  # parse-json('package.json')
  def parse_json(path)
    assert_type path, :String
    path = File.expand_path(path.value)

    if $cached_files.key? path
      Sass.logger.debug "Reading file from cache: #{path}"
      $cached_files[path]
    else
      $cached_files[path] = ruby_to_sass(load_json(path))
    end
  end


  protected

  def load_json(path)
    JSON.load(
      read_file(File.expand_path(path)).to_s.gsub(/(\\r|\\n)/, '')
    )
  end

  def read_file(path)
    raise Sass::SyntaxError, "File not found or cannot be read: #{path}" unless File.readable? path

    Sass.logger.debug "Reading file: #{path}"
    File.open(path, 'rb') { |f| f.read }
  end

end
