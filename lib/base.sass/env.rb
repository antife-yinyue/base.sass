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

  # Get the configurations of current app.
  # Returns null if the named configuration does not exist.
  #
  # Examples:
  # $app-config: (timestamp: '1.0.0');
  # app-config(timestamp) => 1.0.0
  def app_config(name)
    assert_type name, :String
    config = environment.global_env.var('app-config')
    config.is_a?(Sass::Script::Value::Map) && config.to_h[name] || null
  end

end
