module Sass::Script::Functions

  # Returns the value of environment variable associated with the given name.
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

  # Returns the config associated with the given name.
  # Configs are be grouped by `SASS_ENV` environment.
  #
  # Examples:
  # $app-config: (
  #   development: (
  #     foo: bar
  #   ),
  #   production: (
  #     foo: baz
  #   )
  # );
  #
  # $ sass --watch -r base.sass src:dist
  # app-config(foo) => bar
  #
  # $ SASS_ENV=production sass --watch -r base.sass src:dist
  # app-config(foo) => baz
  def app_config(name)
    assert_type name, :String

    config = environment.global_env.var('app-config')
    return null unless config.is_a? Sass::Script::Value::Map

    map_get(config, *[env(identifier('sass-env')), name])
  end

end
