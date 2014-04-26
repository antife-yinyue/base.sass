module Sass::Script::Functions

  $cached_files = {}

  def json_parse(path)
    assert_type path, :String
    path = File.expand_path(path.value)

    if $cached_files.key? path
      puts "Read data from cache: #{path}"
      $cached_files[path]
    else
      $cached_files[path] = ruby_to_sass(json_load(path))
    end
  end


  protected

  def json_load(path)
    path = File.expand_path(path)

    if File.readable? path
      puts "Load JSON file: #{path}"
      JSON.load(File.read(path).to_s.gsub(/(\\r|\\n)/, ''))
    else
      raise Sass::SyntaxError, "JSON file not found or cannot be read: #{path}"
    end
  end

end
