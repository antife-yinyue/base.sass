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

      output = "url(#{arg})"

      if arg.is_a?(String) && arg =~ PATH_REGEX

        path, ext, query, anchor = $1 + $2, $2[1..-1].downcase.to_sym, $3, $4

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


  private

  def timestamp(arg)
    return nil unless arg.to_bool
    (assert_valid_type(arg) ? arg : strftime).value.to_s
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

end
