module Sass::Script::Functions

  def convert_to_string(number)
    identifier(number.value.to_s)
  end

  def convert_to_number(string)
    number(to_if(string))
  end


  protected

  def to_if(s)
    s = s.value if s.is_a?(Sass::Script::Value::String) || s.is_a?(Sass::Script::Value::Number)
    s = s.to_s
    s.include?('.') ? s.to_f : s.to_i
  end
end
