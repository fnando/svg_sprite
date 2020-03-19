# frozen_string_literal: true

module SvgSprite
  module Template
    class CSS
      def template
        @template ||= File.read("#{__dir__}/css.erb")
      end

      def call(source, options)
        ERB.new(template, trim_mode: "-").result binding
      end
    end
  end
end
