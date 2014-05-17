require 'json'

BROWSER_NAMES = {
  # -webkit-
  chrome: 'chrome',
  safari: 'safari',
  opera: 'opera',
  ios_saf: 'ios',
  android: 'android',
  # -moz-
  firefox: 'firefox',
  # -ms-
  ie: 'ie'
}

task :default => [:test]
task :upgrade => [:download, :generate_browsers]

desc 'Download the JSON file from GitHub'
task :download do
  require 'uri'
  require 'net/http'
  require 'net/https'

  uri = URI.parse('https://raw.githubusercontent.com/Fyrd/caniuse/master/data.json')
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  req = Net::HTTP::Get.new(uri.path)
  res = https.request(req)

  @data = JSON.load(res.body)
end

desc 'Generate data to browsers.json'
task :generate_browsers do
  keeps = ['prefix', 'prefix_exceptions', 'versions']
  browsers = BROWSER_NAMES.inject({}) do |memo, (k, v)|
    memo[v] = @data['agents'][k.to_s].select { |n| keeps.include? n }
    memo
  end

  # String to Number
  browsers.each do |k, v|
    versions = v['versions']
    future_versions = versions.last(3).compact.collect { |n| n.to_i }

    v['prefix'] = '-' + v['prefix'] + '-'
    v['versions'] = versions[0...-3].compact.collect { |n| n.split('-') }.flatten.collect { |n| n.to_f }.sort
    v['future'] = future_versions unless future_versions.empty?
  end

  # The last version for Presto
  presto = browsers['opera'].delete('prefix_exceptions')
  browsers['opera'].merge! presto: presto.keys.collect { |v| v.to_f }.sort.last

  file = File.join(File.dirname(__FILE__), 'data', 'browsers.json')
  open(file, 'wb') do |f|
    f.write(JSON.dump(browsers).gsub(/\.0/, ''))
    puts "#{file} - #{(f.size.to_f / 1024).round(2)}k"
  end
end

# y => supported
# a => partial support
# x => requires prefix
# n => not supported
# p => has polyfill available
# u => support unknown
desc 'Generate data to supports.json'
task :generate_supports do
  supports = {}

  @data['data'].select { |k, v|
    v['categories'].any? { |n| n =~ /CSS/ }
  }.each do |f, v|
    stats = v['stats']
    supports[f] = {}

    BROWSER_NAMES.each do |k, n|
      # Find versions which supports current feature
      features = stats[k.to_s].select { |i, s| s =~ /(y|a|x)/ }
      versions = features.keys.collect { |i| i.to_f }.sort

      # Find the last version which requires prefix
      prefixed = features.select { |i, s| s =~ /x/ }
      official = if prefixed.length > 0
        versions.select { |i| i > prefixed.keys.collect { |i| i.to_f }.sort.last }.first
      else
        versions.first
      end

      supports[f].merge! Hash[n, { beginning: versions.first, official: official }]
    end
  end

  file = File.join(File.dirname(__FILE__), 'data', 'supports.json')
  open(file, 'wb') do |f|
    f.write(JSON.dump(supports).gsub(/\.0/, ''))
    puts "#{file} - #{(f.size.to_f / 1024).round(2)}k"
  end
end

desc 'Unit test'
task :test do
  system 'cd test && bundle --quiet && bundle exec sass -r base.sass -r true -t expanded tests.scss:report.css'
  open('test/report.css') do |f|
    output = f.read.to_s
    raise if output.include?('- FAIL:') || !output.include?('Passed')
  end
end
