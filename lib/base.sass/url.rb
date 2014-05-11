module Sass::Script::Functions

  FONT_TYPES = {
    eot: 'embedded-opentype',
    woff: 'woff',
    ttf: 'truetype',
    svg: 'svg'
  }

  MIME_TYPES = {
    png: 'image/png',
    jpg: 'image/jpeg',
    jpeg: 'image/jpeg',
    gif: 'image/gif',
    eot: 'application/vnd.ms-fontobject',
    woff: 'application/font-woff',
    ttf: 'font/truetype',
    svg: 'image/svg+xml'
  }

  PATH_REGEX = /^(.*)(\.\w+)(\??[^#]*)(#?.*)$/

  # Reinforce the official `url()` in CSS to support multi url and data url.
  # Activates only when all paths are wrapped with quotes.
  #
  # Examples:
  # url(http://a.com/b.png)      => url(http://a.com/b.png) # Did nothing
  # url('http://a.com/b.png')    => url(http://a.com/b.png?1399394203)
  # url('a.png', 'b.png')        => url(a.png?1399394203), url(b.png?1399394203)
  # url('a.eot#iefix', 'b.woff') => url(a.eot?1399394203#iefix) format('embedded-opentype'), url(b.woff?1399394203) format('woff')
  #
  # url('a.png', $timestamp: false)   => url(a.png)
  # url('a.png', $timestamp: '1.0.0') => url(a.png?1.0.0)
  #
  # $app-config: (timestamp: '1.0.0');
  # url('a.png') => url(a.png?1.0.0)
  #
  # $app-config: (timestamp: 'p1');
  # url('a.png', $timestamp: 'p0') => url(a.png?p0)
  #
  # url('a.png', $base64: true) => url(data:image/png;base64,iVBORw...)
  def url(*paths)
    kwargs = paths.last.is_a?(Hash) ? paths.pop : {}
    raise Sass::SyntaxError, 'url() needs one path at least' if paths.empty?

    encode = kwargs['base64'] == bool(true)
    ts = timestamp(kwargs['timestamp'])

    paths = paths.map { |path| sass_to_ruby(path) }.flatten
                 .map { |path| to_url(path, encode, ts) }

    list(paths, :comma)
  end
  declare :url, [], var_args: true, var_kwargs: true


  private

  def timestamp(ts)
    # no kwargs
    if ts.nil?
      cfg = app_config(identifier('timestamp'))
      ts = cfg == null ? bool(true) : cfg
    end

    return nil unless ts.to_bool
    return strftime.value if ts.is_a? Sass::Script::Value::Bool
    ts.value.to_s
  end

  def sign(query)
    case query.size
    when 0
      '?'
    when 1
      ''
    else
      '&'
    end
  end

  def to_url(path, encode, ts)
    output = "url(#{path})"

    if path.is_a?(String) && path =~ PATH_REGEX

      path, ext, query, anchor = $1 + $2, $2[1..-1].downcase.to_sym, $3, $4

      if MIME_TYPES.key? ext
        output = if encode
          output_data(path, ext)
        else
          output_path(path, ext, query, anchor, ts)
        end
      end

    end

    identifier(output)
  end

  def output_data(path, ext)
    data = [read_file(File.expand_path(path))].pack('m').gsub(/\s/, '')
    "url(data:#{MIME_TYPES[ext]};base64,#{data})"
  end

  def output_path(path, ext, query, anchor, ts)
    query += sign(query) + ts unless ts.nil?
    output = "url(#{path}#{query}#{anchor})"
    output << " format('#{FONT_TYPES[ext]}')" if FONT_TYPES.key? ext
    output
  end

end
