require 'json'

module Sass::Script::Functions

  $cached_files = {}

  def json_parse(path)
    assert_type path, :String
    path = File.expand_path(path.value)

    if $cached_files.key? path
      Sass.logger.debug "Reading file from cache: #{path}"
      $cached_files[path]
    else
      $cached_files[path] = ruby_to_sass(json_load(path))
    end
  end


  protected

  def json_load(path)
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
