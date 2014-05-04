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

  def url(*args)
    kwargs = args.last.is_a?(Hash) ? args.pop : {}
    raise Sass::SyntaxError, 'url() needs one path at least' if args.empty?

    t = bool(true)
    ts = timestamp(kwargs['timestamp'] || t)
    encode = kwargs['base64'] == t

    args = args.map { |arg| sass_to_ruby(arg) }.flatten.map do |arg|
      raise Sass::SyntaxError, "#{arg} is not a string for `url()`" unless arg.is_a? String

      output = "url(#{arg})"

      if arg =~ PATH_REGEX
        path, ext, query, anchor =
          $1 + $2,
          $2[1..-1].downcase.to_sym,
          $3,
          $4

        if MIME_TYPES.key? ext
          if encode
            data = [read_file(File.expand_path(path))].flatten.pack('m').gsub(/\s/, '')
            output = "url(data:#{MIME_TYPES[ext]};base64,#{data})"
          else
            query += sign(query) + ts unless ts.nil?
            output = "url(#{path}#{query}#{anchor})"
            output << " format('#{FONT_TYPES[ext]}')" if FONT_TYPES.key? ext
          end
        end
      end

      identifier(output)
    end

    list(args, :comma)
  end
  declare :url, [], var_args: true, var_kwargs: true


  # def font_url(paths, cache_buster = bool(true))
  #   ts = timestamp(cache_buster)

  #   urls = resolve_paths(paths).map do |path|
  #     if path =~ PATH_REGEX
  #       path, ext, query, anchor = $1 + $2, $2[1..-1].downcase.to_sym, $3, $4

  #       raise Sass::SyntaxError, "Could not determine font type for #{path}" unless FONT_TYPES.key? ext

  #       query += sign(query) + ts unless ts.nil?
  #       identifier("url(#{path}#{query}#{anchor}) format('#{FONT_TYPES[ext]}')")
  #     else
  #       quoted_string(path)
  #     end
  #   end

  #   list(urls, :comma)
  # end

  # def image_url(paths, cache_buster = bool(true))
  #   ts = timestamp(cache_buster)

  #   urls = resolve_paths(paths).map do |path|
  #     if path =~ PATH_REGEX
  #       path, ext, query, anchor = $1 + $2, $2[1..-1].downcase.to_sym, $3, $4
  #       query += sign(query) + ts unless ts.nil?

  #       identifier("url(#{path}#{query}#{anchor})")
  #     else
  #       quoted_string(path)
  #     end
  #   end

  #   list(urls, :comma)
  # end

  # def data_url(paths)
  #   urls = resolve_paths(paths).map do |path|
  #     if path =~ PATH_REGEX
  #       path, ext = $1 + $2, $2[1..-1].downcase.to_sym

  #       raise Sass::SyntaxError, "Could not determine mime type for #{path}" unless MIME_TYPES.key? ext

  #       data = [read_file(File.expand_path(path))].flatten.pack('m').gsub(/\s/, '')
  #       identifier("url(data:#{MIME_TYPES[ext]};base64,#{data})")
  #     else
  #       quoted_string(path)
  #     end
  #   end

  #   list(urls, :comma)
  # end


  private

  def timestamp(cache_buster)
    return nil unless cache_buster.to_bool
    (assert_valid_type(cache_buster) ? cache_buster : strftime).value.to_s
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

  # def resolve_paths(paths)
  #   [paths].map { |path| sass_to_ruby(path) }.flatten
  # end

  # def data_uri(path, ext)
  #   raise Sass::SyntaxError, "Could not determine mime type for #{path}" unless MIME_TYPES.key? ext

  #   data = [read_file(File.expand_path(path))].flatten.pack('m').gsub(/\s/, '')
  #   identifier("url(data:#{MIME_TYPES[ext]};base64,#{data})")
  # end

end
