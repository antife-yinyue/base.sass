module Sass::Script::Functions

  # Get the value of the specified global variable
  def var(name)
    assert_type name, :String
    environment.global_env.var(name.value) || null
  end

  # Get the configurations of current app
  def app_config(name)
    assert_type name, :String
    config = var(identifier('app-config')).value
    config.is_a?(Hash) && config[name] || null
  end

end
