module Sass::Script::Functions

  # Returns the value for environment variable name as a string.
  # Returns null if the named variable does not exist.
  #
  # Examples:
  # env(SASS_ENV) => development
  # env(sass_env) => development
  # env(sass-env) => development
  def env(name)
    assert_type name, :String
    ruby_to_sass(ENV[name.value.gsub('-', '_').upcase])
  end

end
