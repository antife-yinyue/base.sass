require 'singleton'

class CanIUse
  include Singleton
  include Sass::Script::Functions

  DATA_DIR = File.join(File.dirname(__FILE__), '..', '..', 'data')

  def initialize
    @caniuse_browsers = json_load(File.join(DATA_DIR, 'browsers.json'))
    @caniuse_supports = json_load(File.join(DATA_DIR, 'supports.json'))
  end

  def browsers_data
    @caniuse_browsers
  end

  def supports_data
    @caniuse_supports
  end

end
