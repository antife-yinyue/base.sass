module Sass::Script::Functions

  # Get the value of the specified global variable
  def var(name)
    assert_type name, :String
    environment.global_env.var(name.value) || null
  end

  # Get the configurations
  def config(name)
    assert_type name, :String
    config = var(identifier('sass-config')).value
    config.is_a?(Hash) && config[name] || null
  end

end
