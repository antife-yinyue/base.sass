module Sass::Script::Functions
  # https://github.com/ai/autoprefixer#browsers
  # https://github.com/ai/autoprefixer/blob/master/lib/browsers.coffee#L45

  def parse_rules(*rules)
    @browsers ||= CanIUse.instance.browsers_data

    rules.collect! do |rule|
      rule = rule.value.to_s.downcase

      # match `last 1 version`
      if rule =~ /^last (\d+) versions?$/
        @browsers.inject({}) do |memo, (k, v)|
          memo[k] = v['versions'].last($1.to_i)
          memo
        end

      # match `last 3 chrome versions`
      elsif rule =~ /^last (\d+) (\w+) versions?$/
        assert_browser_name($2)
        Hash[$2, @browsers[$2]['versions'].last($1.to_i)]

      # match `ie > 9`
      elsif rule =~ /^(\w+) (>=?) ([\d\.]+)$/
        assert_browser_name($1)

        versions = @browsers[$1]['versions']
        Hash[$1,
          case $2
          when '>='
            versions.select { |n| n >= $3.to_f }
          when '>'
            versions.select { |n| n > $3.to_f }
          end
        ]

      # match `ios 7`
      elsif rule =~ /^(\w+) ([\d\.]+)$/
        assert_browser_name($1)

        version = $2.include?('.') ? $2.to_f : $2.to_i
        assert_browser_version($1, version)

        Hash[$1, [version]]

      else
        raise Sass::SyntaxError, "Unknown rule: `#{rule}`"
      end
    end

    ruby_to_sass(rules.inject({}) { |memo, browsers|
      browsers.each do |k, v|
        memo[k] ||= []
        memo[k] += v
        memo[k].uniq!
        memo[k].sort!
      end
      memo
    })
  end

  def browser_versions(name)
    @browsers ||= CanIUse.instance.browsers_data
    assert_browser_name(name.value)

    browser = @browsers[name.value]
    versions = browser['versions']
    versions += browser['future'] if browser.key? 'future'

    ruby_to_sass(versions)
  end


  protected

  def assert_browser_name(name)
    unless @browsers.key? name
      raise Sass::SyntaxError, "Unknown browser name: #{name}\nAll valid browsers are #{@browsers.keys}"
    end
  end

  def assert_browser_version(name, version)
    unless @browsers[name]['versions'].include? version
      raise Sass::SyntaxError, "Unknown version of #{name}: #{version}\nYou can find all valid versions according to `browser-versions(#{name})`"
    end
  end

  # def browser_prefix(browser)
  #   assert_type browser, :String
  # end

  # def browser_prefixes(browsers)
  #   assert_type browsers, :List
  # end

end
