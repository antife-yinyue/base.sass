require 'json'

module Sass::Script::Functions

  def json_parse(path)
    assert_type path, :String
    to_sass_type(load_json_file(path.value))
  end

  private

  def load_json_file(path)
    path = File.expand_path(path)

    if File.readable? path
      JSON.load(File.read(path))
    else
      raise Sass::SyntaxError, "JSON file not found or cannot be read: #{path}"
    end
  end

  def to_sass_type(obj)
    return bool(obj) if obj.is_a?(TrueClass) || obj.is_a?(FalseClass)
    return null() if obj.nil?
    return number(obj) if obj.is_a? Numeric
    return to_sass_list(obj) if obj.is_a? Array
    return to_sass_map(obj) if obj.is_a? Hash
    quoted_string(obj.to_s)
  end

  def to_sass_map(ruby_hash)
    sass_map = map({})

    return sass_map if ruby_hash.empty?

    ruby_hash.each do |k, v|
      _ = {}
      _[quoted_string(k.to_s)] = to_sass_type(v)

      sass_map = map_merge(sass_map, map(_))
    end

    sass_map
  end

  def to_sass_list(ruby_array)
    return comma_list() if ruby_array.empty?

    list(ruby_array.map { |item|
      to_sass_type(item)
    }, :comma)
  end
end
