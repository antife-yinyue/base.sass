module Sass::Script::Functions

  def empty_list(separator = nil)
    if separator.is_a?(Sass::Script::Value::String)
      list([], separator.value.to_sym)
    else
      list([], :comma)
    end
  end

end
