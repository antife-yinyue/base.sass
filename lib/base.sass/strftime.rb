module Sass::Script::Functions

  def strftime(format = nil)
    time = Time.now.localtime

    if format.is_a?(Sass::Script::Value::String)
      identifier(time.strftime(format.value))
    else
      identifier(time.to_i.to_s)
    end
  end

end
