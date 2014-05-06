# Thanks for Compass
# Document reference: http://beta.compass-style.org/reference/compass/helpers/selectors/
module Sass::Script::Functions
  COMMA_SEPARATOR = /\s*,\s*/

  def nest(*args)
    nested = args.map { |a| a.value }.inject do |memo, arg|
      ancestors = memo.split(COMMA_SEPARATOR)
      descendants = arg.split(COMMA_SEPARATOR)

      ancestors.map { |a|
        descendants.map { |d|
          "#{a} #{d}"
        }.join(', ')
      }.join(', ')
    end

    identifier(nested)
  end

  def append_selector(selector, to_append)
    ancestors = selector.value.split(COMMA_SEPARATOR)
    descendants = to_append.value.split(COMMA_SEPARATOR)

    nested = ancestors.map { |a|
      descendants.map { |d|
        "#{a}#{d}"
      }.join(', ')
    }.join(', ')

    identifier(nested)
  end

  def enumerate(prefix, from, through, separator = identifier('-'))
    selectors = (from.value..through.value).map { |i|
      "#{prefix.value}#{separator.value}#{i}"
    }.join(', ')

    identifier(selectors)
  end

  def headers(from = nil, to = nil)
    if from && !to
      if from.is_a?(Sass::Script::Value::String) && from.value == 'all'
        from = number(1)
        to = number(6)
      else
        to = from
        from = number(1)
      end
    else
      from ||= number(1)
      to ||= number(6)
    end

    list((from.value..to.value).map { |n| identifier("h#{n}") }, :comma)
  end
  alias headings headers

end
