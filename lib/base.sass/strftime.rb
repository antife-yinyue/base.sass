module Sass::Script::Functions

  # Formats time according to the directives in the given format string.
  # Read more: http://www.ruby-doc.org/core-2.1.1/Time.html#method-i-strftime
  #
  # Examples:
  # strftime()             => 1399392214
  # strftime('%FT%T%:z')   => 2014-05-07T00:03:34+08:00
  # strftime('at %I:%M%p') => at 12:03AM
  def strftime(format = nil)
    time = Time.now.localtime

    if format
      assert_type format, :String
      identifier(time.strftime(format.value))
    else
      identifier(time.to_i.to_s)
    end
  end

end
