module Sass::Script::Functions

  FONT_TYPES = {
    eot: 'embedded-opentype',
    woff: 'woff',
    ttf: 'truetype',
    svg: 'svg'
  }

  def font_url(path, cache_buster = bool(true))
    type, query, anchor = ''

    /^(.*)(\.\w+)(\??[^#]*)(#?.*)$/.match(path.value) do
      path, type, query, anchor = $1 + $2, $2[1..-1].to_sym, $3, $4
    end

    raise Sass::SyntaxError, "Could not determine font type for #{path}" unless FONT_TYPES.key?(type)

    query = join_query(query, cache_buster) if cache_buster.to_bool

    identifier("url(#{path}#{query}#{anchor}) format('#{FONT_TYPES[type]}')")
  end

  def image_url(path, cache_buster = bool(true))
    query, anchor = ''

    /^([^\?#]*)(\??[^#]*)(#?.*)$/.match(path.value) do
      path, query, anchor = $1, $2, $3
    end

    query = join_query(query, cache_buster) if cache_buster.to_bool

    identifier("url(#{path}#{query}#{anchor})")
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

    query << if cache_buster.is_a?(Sass::Script::Value::String)
      cache_buster.value
    else
      strftime().value
    end

    query
  end

end
