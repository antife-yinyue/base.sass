module Sass::Script::Functions

  def env(name)
    assert_type name, :String
    identifier(ENV[name.value.upcase])
  end

end
