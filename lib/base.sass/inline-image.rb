module Sass::Script::Functions

  def inline_image(path, mime_type = nil)
    path = path.value
    data_url(data(path), compute_mime_type(path, mime_type))
  end

  def inline_font_files(*args)

  end


  protected

  def data_url(data, mime_type)
    data = [data].flatten.pack('m').gsub(/\s/, '')
    identifier("url(data:#{mime_type};base64,#{data})")
  end

  private

  def compute_mime_type(path, mime_type = nil)
    return mime_type.value if mime_type

    case path
    when /\.png$/i
      'image/png'
    when /\.jpe?g$/i
      'image/jpeg'
    when /\.gif$/i
      'image/gif'
    when /\.svg$/i
      'image/svg+xml'
    when /\.otf$/i
      'font/opentype'
    when /\.eot$/i
      'application/vnd.ms-fontobject'
    when /\.ttf$/i
      'font/truetype'
    when /\.woff$/i
      'application/font-woff'
    when /\.off$/i
      'font/openfont'
    when /\.([a-zA-Z]+)$/
      "image/#{Regexp.last_match(1).downcase}"
    else
      raise Sass::SyntaxError, "A mime type could not be determined for #{path}, please specify one explicitly."
    end
  end

  def data(path)
    path = File.expand_path(path)

    if File.readable?(path)
      File.open(path, 'rb') { |io| io.read }
    else
      raise Sass::SyntaxError, "File not found or cannot be read: #{path}"
    end
  end

end
