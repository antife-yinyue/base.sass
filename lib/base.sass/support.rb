module Sass::Script::Functions

  # Which browsers you wanted support?
  #
  # `last 1 version`
  #   is last versions for each browser.
  # `last 2 Chrome versions`
  #   is last versions of the specified browser.
  # `IE > 8`
  #   is IE versions newer than 8.
  # `IE >= 8`
  #   is IE version 8 or newer.
  # `iOS 7`
  #   to set browser version directly.
  def parse_rules(*rules)
    rules = rules.map { |rule| sass_to_ruby(rule) }.flatten.uniq

    @browsers ||= CanIUse.instance.browsers
    selected_browsers =
      rules.map { |rule| rules_parser(rule.downcase) }.compact
           .inject { |memo, versions|
             memo.merge(versions) { |k, orig, added| orig + added }
           }

    ruby_to_sass(selected_browsers.each { |k, v| v.uniq!; v.sort! })
  end

  # Returns `(android, chrome, firefox, ie, ios, opera, safari)`.
  def browsers
    ruby_to_sass(CanIUse.instance.browsers.keys.sort)
  end

  # Returns the versions by the given browser.
  def browser_versions(browser, include_future = bool(true))
    assert_type browser, :String

    @browsers ||= CanIUse.instance.browsers
    browser = browser.value.downcase
    assert_valid_browser(browser)

    versions = @browsers[browser]['versions']
    versions += @browsers[browser]['future'].to_a if include_future.to_bool

    ruby_to_sass(versions)
  end

  # Grep feature names according to caniuse by regex.
  #
  # Examples:
  # grep-features('^css3?')     => /^css3?/
  # grep-features('box sizing') => /box|sizing/
  # grep-features('box-sizing') => /box|sizing/
  def grep_features(regex)
    assert_type regex, :String

    regex = regex.value.strip.sub(/^-+|-+$/, '')
    regex = regex.gsub(/\s+|-+/, '|') if regex =~ /^[\w\s-]+$/
    regex = Regexp.new(regex, Regexp::IGNORECASE)

    ruby_to_sass(CanIUse.instance.supports.keys.select { |k| k =~ regex }.sort)
  end


  private

  def assert_valid_browser(browser, version = nil)
    unless @browsers.key? browser
      raise Sass::SyntaxError, "Unknown browser name: #{browser}\nYou can find all valid names according to `browsers()`"
    end

    unless version.nil? || sass_to_ruby(browser_versions(identifier(browser))).include?(version)
      raise Sass::SyntaxError, "Unknown version for #{browser}: #{version}\nYou can find all valid versions according to `browser-versions(#{browser})`"
    end
  end

  def rules_parser(rule)
    case rule

    # match `last 1 version`
    when /^last (\d+) versions?$/
      last_versions_parser($1)

    # match `last 3 chrome versions`
    when /^last (\d+) (\w+) versions?$/
      last_browser_versions_parser($1, $2)

    # match `ie > 9`
    when /^(\w+) (>=?) ([\d\.]+)$/
      newer_then_parser($1, $2, $3)

    # match `ios 7`
    when /^(\w+) ([\d\.]+)$/
      direct_parser($1, $2)

    else
      raise Sass::SyntaxError, "Unknown rule: `#{rule}`"
    end
  end

  def last_versions_parser(num)
    @browsers.inject({}) do |memo, (k, v)|
      memo[k] = v['versions'].last(num.to_i)
      memo
    end
  end

  def last_browser_versions_parser(num, browser)
    assert_valid_browser(browser)
    Hash[browser, @browsers[browser]['versions'].last(num.to_i)]
  end

  def newer_then_parser(browser, sign, version)
    assert_valid_browser(browser)

    versions = @browsers[browser]['versions']
    versions = case sign
      when '>='
        versions.select { |n| n >= version.to_f }
      when '>'
        versions.select { |n| n > version.to_f }
      end

    versions.empty? ? nil : Hash[browser, versions]
  end

  def direct_parser(browser, version)
    version = to_if(version)
    assert_valid_browser(browser, version)
    Hash[browser, [version]]
  end

  def to_if(s)
    s.include?('.') ? s.to_f : s.to_i
  end

end
