module Sass::Script::Functions

  # Refer to https://github.com/ai/autoprefixer#browsers
  # Do not support global usage statistics: `> 5%`
  def parse_rules(*rules)
    @browsers ||= CanIUse.instance.browsers

    rules = rules.map { |rule| sass_to_ruby(rule) }.flatten.uniq
                 .map { |rule| rules_parser(rule.downcase) }

    ruby_to_sass(rules.compact.inject({}) { |memo, browsers|
      browsers.each { |k, v| memo[k] = (memo[k].to_a + v).uniq.sort }
      memo
    })
  end

  def browsers
    ruby_to_sass(CanIUse.instance.browsers.keys.sort)
  end

  def browser_versions(name, include_future = bool(true))
    assert_type name, :String
    name = name.value.downcase

    @browsers ||= CanIUse.instance.browsers
    assert_browser_name(name)

    versions = @browsers[name]['versions']
    versions += @browsers[name]['future'].to_a if include_future.to_bool

    ruby_to_sass(versions)
  end

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
    return null() if feature_supports.nil?

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


  protected

  def assert_browser_name(name)
    unless @browsers.key? name
      raise Sass::SyntaxError, "Unknown browser name: #{name}\nYou can find all valid names according to `browsers()`"
    end
  end

  def assert_browser_version(name, version)
    versions = sass_to_ruby(browser_versions(identifier(name)))
    unless versions.include? version
      raise Sass::SyntaxError, "Unknown version for #{name}: #{version}\nYou can find all valid versions according to `browser-versions(#{name})`"
    end
  end

  def browser_prefix(name, oldest)
    browsers = CanIUse.instance.browsers
    prefix = browsers[name]['prefix']

    if name == 'opera' && oldest <= browsers['opera']['presto']
      prefix = [prefix, '-o-']
    end
    prefix
  end


  private

  def rules_parser(rule)
    # match `last 1 version`
    if rule =~ /^last (\d+) versions?$/
      last_versions_parser($1)

    # match `last 3 chrome versions`
    elsif rule =~ /^last (\d+) (\w+) versions?$/
      last_browser_versions_parser($1, $2)

    # match `ie > 9`
    elsif rule =~ /^(\w+) (>=?) ([\d\.]+)$/
      newer_then_parser($1, $2, $3)

    # match `ios 7`
    elsif rule =~ /^(\w+) ([\d\.]+)$/
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
    assert_browser_name(browser)
    Hash[browser, @browsers[browser]['versions'].last(num.to_i)]
  end

  def newer_then_parser(browser, sign, version)
    assert_browser_name(browser)

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
    assert_browser_version(browser, version)
    Hash[browser, [version]]
  end

end
