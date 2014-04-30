module Sass::Script::Functions

  PATH_PARSER = /^(.*)(\.\w+)(\??[^#]*)(#?.*)$/

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

  def font_url(path, cache_buster = bool(true))
    assert_type path, :String

    ext, query, anchor = ''
    PATH_PARSER.match(path.value) do
      path, ext, query, anchor = $1 + $2, $2[1..-1].downcase.to_sym, $3, $4
    end

    raise Sass::SyntaxError, "Could not determine font type for #{path}" unless FONT_TYPES.key? ext

    query = join_query(query, cache_buster) if cache_buster.to_bool

    identifier("url(#{path}#{query}#{anchor}) format('#{FONT_TYPES[ext]}')")
  end

  def image_url(path, cache_buster = bool(true))
    assert_type path, :String

    query, anchor = ''
    PATH_PARSER.match(path.value) do
      path, query, anchor = $1 + $2, $3, $4
    end

    query = join_query(query, cache_buster) if cache_buster.to_bool

    identifier("url(#{path}#{query}#{anchor})")
  end

  def data_url(path)
    assert_type path, :String

    ext = ''
    PATH_PARSER.match(File.expand_path(path.value)) do
      path, ext = $1 + $2, $2[1..-1].downcase.to_sym
    end

    raise Sass::SyntaxError, "Could not determine mime type for #{path}" unless MIME_TYPES.key? ext

    data = [read_file(path)].flatten.pack('m').gsub(/\s/, '')
    identifier("url(data:#{MIME_TYPES[ext]};base64,#{data})")
  end


  private

  def join_query(query, cache_buster)
    query = query.to_s

    query << case query.size
      when 0
        '?'
      when 1
        ''
      else
        '&'
      end

    query << if cache_buster.is_a? Sass::Script::Value::String
      cache_buster.value
    else
      strftime.value
    end

    query
  end

end
