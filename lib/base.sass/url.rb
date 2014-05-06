module Sass::Script::Functions

  PATH_REGEX = /^(.*)(\.\w+)(\??[^#]*)(#?.*)$/

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
    if ts.nil?
      cfg = app_config(identifier('timestamp'))
      ts = cfg == null ? bool(true) : cfg
    end

    return nil unless ts.to_bool
    (is_number_or_string(ts) ? ts : strftime).value.to_s
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

  def to_url(arg, encode, ts)
    output = "url(#{arg})"

    if arg.is_a?(String) && arg =~ PATH_REGEX

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
