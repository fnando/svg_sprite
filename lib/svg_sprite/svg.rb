module SvgSprite
  class SVG
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def has_dimensions?
      width && height
    end

    def svg
      @svg ||= xml.css("svg").first
    end

    def width
      svg["width"]
    end

    def height
      svg["height"]
    end

    def xml
      @xml ||= Nokogiri::XML(contents)
    end

    def contents
      @contents ||= File.read(path)
    end

    def optimized
      @optimized ||= SvgOptimizer.optimize(contents)
    end

    def base64
      Base64.strict_encode64(optimized)
    end

    def name
      File.basename(path, ".*")
    end
  end
end
