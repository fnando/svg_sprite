# frozen_string_literal: true

module SvgSprite
  module Template
    class SCSS
      def template
        @template ||= File.read("#{__dir__}/scss.erb")
      end

      def call(source, options)
        ERB.new(template, trim_mode: "-").result binding
      end

      private def names(source)
        source.to_a.map(&:name).join(", ")
      end
    end
  end
end
