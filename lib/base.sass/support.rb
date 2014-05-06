module Sass::Script::Functions

  # Refer to https://github.com/ai/autoprefixer#browsers
  # Do not support global usage statistics: `> 5%`
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

  # Returns all the known browsers according to `data/browsers.json`.
  def browsers
    ruby_to_sass(CanIUse.instance.browsers.keys.sort)
  end

  # Returns the versions for the given browser.
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

  def required_prefix(browsers, feature)
    assert_type browsers, :Map
    assert_type feature, :String

    feature_supports = CanIUse.instance.supports[feature.value]
    return null if feature_supports.nil?

    prefix = sass_to_ruby(browsers).inject({}) do |memo, (k, v)|
      beginning = feature_supports[k]['beginning']
      official = feature_supports[k]['official']

      memo[k] = if official && v.first >= official
        false
      elsif beginning && v.last >= beginning
        browser_prefix(k, v.first)
      else
        nil
      end
      memo
    end

    ruby_to_sass(prefix)
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

  def browser_prefix(browser, oldest)
    browsers = CanIUse.instance.browsers
    prefix = browsers[browser]['prefix']

    if browser == 'opera' && oldest <= browsers['opera']['presto']
      prefix = [prefix, '-o-']
    end
    prefix
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

end
