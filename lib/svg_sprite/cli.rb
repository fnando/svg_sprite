# frozen_string_literal: true

module SvgSprite
  class CLI < Thor
    check_unknown_options!

    def self.exit_on_failure?
      true
    end

    def self.formats
      TEMPLATES.keys
    end

    desc "version", "Display svg_sprite version"
    map %w[-v --version] => :version

    def version
      say SvgSprite::VERSION
    end

    desc "generate",
         "Generate the SVG sprite by embedding the images as data URIs."
    option :source,
           aliases: %w[-s],
           required: true,
           desc: "The source directory. Will match SOURCE/**/*.svg."
    option :output,
           aliases: %w[-o],
           required: true,
           desc: "The output file."
    option :name,
           aliases: %w[-n],
           default: "sprite",
           desc: "The sprite name. This will be used as the variable for dynamic files."
    option :format,
           aliases: %w[-f],
           desc: "The output format. When not provided, will be inferred from output file's extension. Can be any of #{formats.join('|')}."
    def generate
      format = options["format"] || File.extname(options["output"])[1..-1]

      unless valid_format?(format)
        raise Error,
              "ERROR: invalid output format. Must be one of #{formats.join('|')}."
      end

      SvgSprite.export(
        source: File.expand_path(options["source"]),
        output: File.expand_path(options["output"]),
        format: format,
        name: options["name"]
      )
    end

    no_commands do
      def valid_format?(format)
        formats.include?(format)
      end

      def formats
        self.class.formats
      end
    end
  end
end
