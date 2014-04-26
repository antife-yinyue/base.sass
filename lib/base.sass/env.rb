module Sass::Script::Functions

  def env(name)
    assert_type name, :String
    identifier(ENV[name.value.upcase])
  end

  def argv(name = nil)
    argv = {
      output_style: options[:style],
      sass_file: options[:original_filename],
      css_file: options[:css_filename]
    }

    if name.is_a?(Sass::Script::Value::String) && argv.key?(name = name.value.to_sym)
      identifier(argv[name].to_s)
    else
      null()
    end
  end

end
