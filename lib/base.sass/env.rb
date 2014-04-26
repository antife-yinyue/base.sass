module Sass::Script::Functions

  def env(name)
    assert_type name, :String
    identifier(ENV[name.value.upcase])
  end

  # def current(name)
  #   assert_type name, :String

  #   names = {
  #     'output-style' => options[:style],
  #     'sass-file' => options[:original_filename],
  #     'css-file' => options[:css_filename]
  #   }

  #   identifier(names[name.value].to_s)
  # end

end
