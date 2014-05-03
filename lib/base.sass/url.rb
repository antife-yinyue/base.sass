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

  def font_url(paths, cache_buster = bool(true))
    ts = timestamp(cache_buster)

    urls = resolve_paths(paths).map do |path|
      if path =~ PATH_REGEX
        path, ext, query, anchor = $1 + $2, $2[1..-1].downcase.to_sym, $3, $4

        raise Sass::SyntaxError, "Could not determine font type for #{path}" unless FONT_TYPES.key? ext

        query += sign(query) + ts unless ts.nil?
        identifier("url(#{path}#{query}#{anchor}) format('#{FONT_TYPES[ext]}')")
      else
        quoted_string(path)
      end
    end

    list(urls, :comma)
  end

  def image_url(paths, cache_buster = bool(true))
    ts = timestamp(cache_buster)

    urls = resolve_paths(paths).map do |path|
      if path =~ PATH_REGEX
        path, query, anchor = $1 + $2, $3, $4
        query += sign(query) + ts unless ts.nil?

        identifier("url(#{path}#{query}#{anchor})")
      else
        quoted_string(path)
      end
    end

    list(urls, :comma)
  end

  def data_url(paths)
    urls = resolve_paths(paths).map do |path|
      if path =~ PATH_REGEX
        path, ext = $1 + $2, $2[1..-1].downcase.to_sym

        raise Sass::SyntaxError, "Could not determine mime type for #{path}" unless MIME_TYPES.key? ext

        data = [read_file(File.expand_path(path))].flatten.pack('m').gsub(/\s/, '')
        identifier("url(data:#{MIME_TYPES[ext]};base64,#{data})")
      else
        quoted_string(path)
      end
    end

    list(urls, :comma)
  end


  private

  def timestamp(cache_buster)
    return nil unless cache_buster.to_bool

    if cache_buster.is_a? Sass::Script::Value::String
      cache_buster.value
    else
      strftime.value
    end
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

  def resolve_paths(paths)
    [paths].map { |path| sass_to_ruby(path) }.flatten
  end

end
