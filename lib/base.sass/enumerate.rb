module Sass::Script::Functions

  def enumerate(prefix, from, separator, through)
    selectors = (from.value..through.value).map { |i|
      "#{prefix.value}#{separator.value}#{i}"
    }.join(', ')

    identifier(selectors)
  end

end
