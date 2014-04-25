module Sass::Script::Functions

  def comma_list
    list([], :comma)
  end

  def comma_join(list)
    assert_type list, :List
    identifier(list.value.join(', '))
  end

end
