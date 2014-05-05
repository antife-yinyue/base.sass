module Sass::Script::Functions

  # Get the value of the specified global variable
  def var(name)
    assert_type name, :String
    environment.global_env.var(name.value) || null
  end

  # Get the configuration settings
  def config(name)
    namespace = 'sass-config'
    config = environment.global_env.var(namespace)

    raise Sass::SyntaxError, "The global variable `$#{namespace}` not found" if config.nil?
    raise Sass::SyntaxError, "The global variable `$#{namespace}` is not a map" unless config.is_a? Sass::Script::Value::Map

    map_get(config, name)
  end

end
