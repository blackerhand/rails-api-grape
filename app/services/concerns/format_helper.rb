module FormatHelper
  def safe_text(content)
    content = content.to_s
    return content if content.length <= GRAPE_API::MAX_TEXT_LENGTH

    "#{content[0..GRAPE_API::MAX_TEXT_LENGTH]}..."
  end

  def uri_data?(base64_str)
    base64_str.match?(/^data/)
  end

  def format_data_uri(base64_str)
    return unless uri_data?(base64_str)

    uri = URI::Data.new(base64_str)
    ext =
      case uri.content_type
      when 'image/jpeg'
        'jpg'
      when 'image/png'
        'png'
      when 'image/gif'
        'gif'
      when 'text/javascript', 'text/css', 'text/html', 'text/plain'
        'txt'
      when 'image/heic'
        'heic' # 浏览器不支持, 在 uploader 处过滤
      end

    [ext, uri.data]
  rescue URI::InvalidURIError
    nil
  end

  # 获取 io 的图片格式
  def get_imgage_format!(bytes)
    get_format_from_magick(bytes) ||
      get_format_from_match(bytes) ||
      raise(GetIoFormatError, '不支持该文件类型, 请重新上传文件')
  end

  def get_format_from_magick(bytes)
    img = Magick::Image.from_blob(bytes).first
    img.format&.downcase
  rescue Magick::ImageMagickError, RuntimeError
    nil
  end

  def get_format_from_match(bytes)
    png  = Regexp.new("\x89PNG".force_encoding('binary'))
    jpg  = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding('binary'))
    jpg2 = Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding('binary'))

    # mime_type = `file #{local_file_path} --mime-type`.gsub("\n", '') # Works on linux and mac
    # raise UnprocessableEntity, "unknown file type" if !mime_type
    # mime_type.split(':')[1].split('/')[1].gsub('x-', '').gsub(/jpeg/, 'jpg').gsub(/text/, 'txt').gsub(/x-/, '')
    case bytes
    when /^GIF8/
      'gif'
    when /^#{png}/
      'png'
    when /^#{jpg}/, /^#{jpg2}/
      'jpg'
    end
  end
end
