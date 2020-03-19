# frozen_string_literal: true

module SvgSprite
  class Sprite
    def initialize(source, template, options)
      @source = source
      @template = template
      @options = options
    end

    def render
      @template.call(@source, @options)
    end
  end
end
