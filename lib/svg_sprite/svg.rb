module SvgSprite
  class SVG
    attr_reader :path

    def initialize(path)
      @path = path
    end

    # Return the image file name without the extension.
    def name
      File.basename(path, ".*")
    end

    # Detect if SVG has all dimensions defined.
    def has_dimensions?
      width && height
    end

    # Return a Nokogiri representation of the <svg> element.
    def svg
      @svg ||= Nokogiri::XML(contents).css("svg").first
    end

    # Return the <svg>'s width.
    def width
      svg["width"]
    end

    # Return the <svg>'s height.
    def height
      svg["height"]
    end

    # Return the raw content. This content is not optimized by svg_optimizer.
    def contents
      @contents ||= File.read(path)
    end

    # Return the optimized content.
    def optimized
      @optimized ||= SvgOptimizer.optimize(contents)
    end

    # Return the URL-encoded version of the content.
    def encoded
      CGI.escape(contents)
    end

    # Return the Base64-encoded version of the content.
    def base64
      Base64.strict_encode64(optimized)
    end

    # Return the smaller data URI
    def data_uri
      [base64_data_uri, urlencoded_data_uri].sort_by(&:bytesize).first
    end

    # Return the Base64 version of the data URI.
    def base64_data_uri
      %[data:image/svg+xml;base64,#{base64}]
    end

    # Return the URL-encoded version of the data URI.
    def urlencoded_data_uri
      %[data:image/svg+xml;charset=#{encoding},#{encoded}]
    end

    # The output encoding based on the global configuration.
    def encoding
      Encoding.default_external.name
    end
  end
end
