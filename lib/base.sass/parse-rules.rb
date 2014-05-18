module Sass::Script::Functions

  # Returns the specified browsers and versions associated with the given rules.
  #
  # Rules:
  # 1. last 1 version         is last versions for each browser.
  # 2. last 2 Chrome versions is last versions of the specified browser.
  # 3. IE > 8                 is ie versions newer than 8.
  # 4. IE >= 8                is ie version 8 or newer.
  # 5. iOS 7                  to set browser version directly.
  def parse_rules(*rules)
    rules = rules.map { |r| sass_to_ruby(r) }.flatten.uniq

    # Parse
    selected = rules.map { |r| rules_parser(r.downcase) }.compact
    # Merge
    selected = selected.inject { |memo, p|
      memo.merge(p) { |k, orig, added| orig + added }
    }
    # Uniq & Sort
    selected.each { |k, v|
      v.uniq!
      v.sort!
    }

    ruby_to_sass(selected)
  end


  protected

  def caniuse_browsers
    @browsers ||= CanIUse.instance.browsers
  end

  def caniuse_versions(browser, include_future)
    @versions ||= {}
    k = browser.to_s + include_future.to_s
    @versions[k] ||= CanIUse.instance.versions(browser, include_future)
  end

  def assert_valid_browser(browser, version = nil)
    unless caniuse_browsers.include? browser
      raise Sass::SyntaxError, "Unknown browser name: #{browser}\nYou can find all valid names according to `caniuse(browsers)`"
    end

    unless version.nil? || caniuse_versions(browser, true).include?(version)
      raise Sass::SyntaxError, "Unknown version for #{browser}: #{version}\nYou can find all valid versions according to `caniuse(#{browser} all versions)`"
    end
  end


  private

  def rules_parser(rule)
    case rule

    # match `last 1 version`
    when /^last (\d+) versions?$/
      last_versions_parser($1)

    # match `last 3 chrome versions`
    when /^last (\d+) (\w+) versions?$/
      last_browser_versions_parser($1, $2, true)

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
    caniuse_browsers.map { |browser|
      last_browser_versions_parser(num, browser, false)
    }.inject :merge
  end

  def last_browser_versions_parser(num, browser, assert)
    assert_valid_browser(browser) if assert
    Hash[browser, caniuse_versions(browser, false).last(num.to_i)]
  end

  def newer_then_parser(browser, sign, version)
    assert_valid_browser(browser)

    versions = caniuse_versions(browser, false)
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
