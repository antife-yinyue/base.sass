module Sass::Script::Functions

  def json_parse(path)
    assert_type path, :String
    ruby_to_sass(CanIUse.instance.load(path.value))
  end

end
