module Sass::Script::Functions

  def ruby_to_sass(obj)
    return bool(obj) if obj.is_a?(TrueClass) || obj.is_a?(FalseClass)
    return null() if obj.nil?
    return number(obj) if obj.is_a? Numeric
    return to_sass_list(obj) if obj.is_a? Array
    return to_sass_map(obj) if obj.is_a? Hash
    identifier(obj.to_s)
  end


  private

  def to_sass_map(ruby_hash)
    sass_map = map({})

    return sass_map if ruby_hash.empty?

    ruby_hash.each do |k, v|
      _ = {}
      _[quoted_string(k.to_s)] = ruby_to_sass(v)

      sass_map = map_merge(sass_map, map(_))
    end

    sass_map
  end

  def to_sass_list(ruby_array)
    return comma_list() if ruby_array.empty?

    list(ruby_array.map { |item|
      ruby_to_sass(item)
    }, :comma)
  end

end
