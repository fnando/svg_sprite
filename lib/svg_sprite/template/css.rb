module SvgSprite
  module Template
    class CSS
      def template
        @template ||= File.read("#{__dir__}/css.erb")
      end

      def call(source, options)
        ERB.new(template, nil, "-").result binding
      end
    end
  end
end
