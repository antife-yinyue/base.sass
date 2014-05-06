module Sass::Script::Functions

  # Convert whatever a number or a string to a string.
  def to_string(number)
    return null unless is_number_or_string(number)
    identifier(number.value.to_s)
  end

  # Convert whatever a number or a string to a number.
  def to_number(string)
    return null unless is_number_or_string(string)
    number(to_if(string.value.to_s))
  end


  protected

  def to_if(s)
    s.include?('.') ? s.to_f : s.to_i
  end

  def is_number_or_string(arg)
    arg.is_a?(Sass::Script::Value::Number) || arg.is_a?(Sass::Script::Value::String)
  end

end
