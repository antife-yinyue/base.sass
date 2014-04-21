module Sass::Script::Functions

  def enumerate(prefix, from, separator, through)
    selectors = (from.value..through.value).map { |i|
      "#{prefix.value}#{separator.value}#{i}"
    }.join(', ')

    unquoted_string(selectors)
  end

end
