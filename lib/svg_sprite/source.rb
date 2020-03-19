# frozen_string_literal: true

module SvgSprite
  class Source
    def initialize(directory)
      @directory = directory
    end

    def each(&block)
      to_a.each(&block)
    end

    def to_a
      Dir["#{@directory}/**/*.svg"].map do |file|
        SVG.new(file)
      end
    end
  end
end
