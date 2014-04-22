module Sass::Script::Functions

  def working_path
    identifier(Dir.pwd)
  end

end
