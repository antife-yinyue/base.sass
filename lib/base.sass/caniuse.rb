require 'singleton'

class CanIUse
  include Singleton
  include Sass::Script::Functions

  DATA_DIR = File.join(File.dirname(__FILE__), '..', '..', 'data')

  def initialize
    @caniuse_browsers = load_json(File.join(DATA_DIR, 'browsers.json'))
    # @caniuse_supports = load_json(File.join(DATA_DIR, 'supports.json'))
  end

  def browsers
    @caniuse_browsers
  end

  # def supports
  #   @caniuse_supports
  # end

end
