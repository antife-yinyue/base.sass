require 'json'
require 'singleton'

class CanIUse
  include Singleton

  DATA_DIR = File.join(File.dirname(__FILE__), '..', '..', 'data')

  def initialize
    @caniuse_browsers = load(File.join(DATA_DIR, 'browsers.json'))
    @caniuse_supports = load(File.join(DATA_DIR, 'supports.json'))
  end

  def browsers(prefix = nil)
    if prefix
      @caniuse_browsers.select { |k, v| v['prefix'] == prefix }.keys
    else
      @caniuse_browsers.keys
    end
  end

  def load(path)
    path = File.expand_path(path)

    if File.readable? path
      puts "Loading JSON file: #{path}"
      JSON.load(File.read(path))
    else
      raise Sass::SyntaxError, "JSON file not found or cannot be read: #{path}"
    end
  end

end
