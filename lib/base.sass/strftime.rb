module Sass::Script::Functions

  def strftime(format = nil)
    time = Time.now.localtime

    if format.is_a?(Sass::Script::Value::String)
      unquoted_string(time.strftime(format.value))
    else
      unquoted_string(time.to_i.to_s)
    end
  end

end
