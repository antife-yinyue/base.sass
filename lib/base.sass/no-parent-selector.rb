module Sass::Script::Functions

  def no_parent_selector
    bool(environment.selector.nil?)
  end

end
