module Sass::Script::Functions

  def convert_to_string(number)
    identifier(number.value.to_s)
  end

  def convert_to_number(string)
    s = string.value.to_s
    number(s.include?('.') ? s.to_f : s.to_i)
  end

end
