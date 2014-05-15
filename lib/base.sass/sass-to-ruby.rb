module Sass::Script::Functions

  protected

  def sass_to_ruby(obj)
    return to_ruby_hash(obj) if obj.is_a? Sass::Script::Value::Map
    return to_ruby_array(obj) if obj.is_a? Sass::Script::Value::List
    return obj.inspect if obj.is_a? Sass::Script::Value::Color
    obj.value
  end

  def to_ruby_hash(sass_map)
    sass_map.to_h.inject({}) do |memo, (k, v)|
      memo[k.to_s] = sass_to_ruby(v)
      memo
    end
  end

  def to_ruby_array(sass_list)
    sass_list.to_a.map do |item|
      sass_to_ruby(item)
    end
  end

end
