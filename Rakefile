require 'multi_json'

BROWSER_NAMES = {
  chrome: 'Chrome',
  firefox: 'Firefox',
  safari: 'Safari',
  ie: 'IE',
  opera: 'Opera',
  ios_saf: 'iOS',
  android: 'Android', # Chrome for Android, Opera Mobile
  # and_ff: 'Firefox for Android',
  ie_mob: 'Windows Phone'
  # Not support Opera Mini and Blackberry
}

pretty = false

task :gb => [:mock, :generate_browsers]
task :gp => [:mock, :generate_prefixes]
task :default => [:download, :generate_browsers, :generate_prefixes]

desc 'Mock data.'
task :mock do
  @data = MultiJson.load(
    File.read(
      File.join(File.dirname(__FILE__), 'data/caniuse.json')
    )
  )
end

desc 'Download the JSON file from caniuse.com'
task :download do
  require 'uri'
  require 'net/http'
  require 'net/https'

  uri = URI.parse('https://raw.github.com/Fyrd/caniuse/master/data.json')
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  req = Net::HTTP::Get.new(uri.path)
  res = https.request(req)

  @data = MultiJson.load(res.body)
end

desc 'Generate data to browsers.json'
task :generate_browsers do
  browsers = {}
  keeps = ['prefix', 'prefix_exceptions', 'versions']

  BROWSER_NAMES.each do |k, v|
    browsers[v] = @data['agents'][k.to_s].select { |n| keeps.include? n }
  end

  # String to Number
  browsers.each do |k, v|
    v = v['versions']
    v.compact!
    v.collect! { |n| n.split('-') }
    v.flatten!
    v.collect! { |n| n.to_f }
    v.sort!
  end

  # The last version for Presto
  oldVersions = browsers['Opera'].delete('prefix_exceptions')
  browsers['Opera'].merge! presto: oldVersions.keys.collect { |v| v.to_f }.sort.last

  file = File.join(File.dirname(__FILE__), 'data/browsers.json')
  open(file, 'wb') do |f|
    f.write(MultiJson.dump(browsers, pretty: pretty).gsub(/\.0/, ''))
  end
end

# y => supported
# a => partial support
# x => requires prefix
# n => not supported
# p => has polyfill available
# u => support unknown
desc 'Generate data to prefixes.json'
task :generate_prefixes do
  prefixes = {}
  features = @data['data'].select { |k, v| v['categories'].any? { |n| n =~ /CSS/ } }

  features.each do |f, v|
    stats = v['stats']
    prefixes[f] = {}

    BROWSER_NAMES.each do |k, n|
      # Find versions which supports current feature
      supports = stats[k.to_s].select { |i, s| s =~ /(y|a|x)/ }
      versions = supports.keys.collect { |i| i.to_f }.sort

      # Find the last version which requires prefix
      prefixed = supports.select { |i, s| s =~ /x/ }
      standard = if prefixed.length > 0
        versions.select { |i|
          i > prefixed.keys.collect { |i| i.to_f }.sort.last
        }.first
      else # needless
        versions.first
      end

      prefixes[f][n] = {
        support: versions.first,
        standard: standard
      }
    end
  end

  file = File.join(File.dirname(__FILE__), 'data/prefixes.json')
  open(file, 'wb') do |f|
    f.write(MultiJson.dump(prefixes, pretty: pretty).gsub(/\.0/, ''))
  end
end
