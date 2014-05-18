require 'singleton'

class CanIUse
  include Singleton
  include Sass::Script::Functions

  def initialize
    @data = load_json(File.join(File.dirname(__FILE__), '..', '..', 'data', 'browsers.json'))
  end

  def browsers
    @data.keys.sort
  end

  def versions(browser, include_future)
    return [] unless @data.key? browser

    versions = @data[browser]['versions']
    return versions unless include_future

    versions + @data[browser]['future'].to_a
  end

end


module Sass::Script::Functions

  # Returns the data in CanIUse which base.sass used.
  #
  # Examples:
  # caniuse(browsers)
  # caniuse(Chrome versions)
  # caniuse(Chrome all versions)
  def caniuse(cond)
    cond = [sass_to_ruby(cond)].flatten.map { |w| w.downcase }

    output = if cond.first == 'browsers'
      caniuse_browsers
    elsif cond.last == 'versions'
      browser = cond.first
      assert_valid_browser(browser)
      caniuse_versions(browser, cond.include?('all'))
    else
      raise Sass::SyntaxError, "Unknown condition.\nYou can try `caniuse(browsers)` or `caniuse(Chrome versions)`"
    end

    ruby_to_sass(output)
  end

end
