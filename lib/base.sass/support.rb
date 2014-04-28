module Sass::Script::Functions
  # https://github.com/ai/autoprefixer#browsers
  # https://github.com/ai/autoprefixer/blob/master/lib/browsers.coffee#L45

  def parse_rules(*rules)
    @browsers ||= CanIUse.instance.browsers
    rules = rules.map { |r| sass_to_ruby(r) }.flatten.uniq

    rules.map! do |rule|
      rule = rule.to_s.downcase

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

    ruby_to_sass(rules.compact.inject({}) { |memo, browsers|
      browsers.each do |k, v|
        memo[k] ||= []
        memo[k] += v
        memo[k].uniq!
        memo[k].sort!
      end
      memo
    })
  end

  def browsers
    ruby_to_sass(CanIUse.instance.browsers.keys.sort)
  end

  def browser_versions(name)
    @browsers ||= CanIUse.instance.browsers
    assert_browser_name(name.value)

    browser = @browsers[name.value]
    versions = browser['versions']
    versions += browser['future'] if browser.key? 'future'

    ruby_to_sass(versions)
  end

  def grep_features(regexp)
    assert_type regexp, :String
    regexp = Regexp.new(regexp.value, Regexp::IGNORECASE)
    ruby_to_sass(CanIUse.instance.supports.keys.sort.select { |k| k =~ regexp })
  end


  protected

  def assert_browser_name(name)
    unless @browsers.key? name
      raise Sass::SyntaxError, "Unknown browser name: #{name}\nYou can find all valid names according to `browsers()`"
    end
  end

  def assert_browser_version(name, version)
    unless @browsers[name]['versions'].include? version
      raise Sass::SyntaxError, "Unknown version of #{name}: #{version}\nYou can find all valid versions according to `browser-versions(#{name})`"
    end
  end


  private

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
    assert_browser_name(browser)

    version = version.include?('.') ? version.to_f : version.to_i
    assert_browser_version(browser, version)

    Hash[browser, [version]]
  end
end
