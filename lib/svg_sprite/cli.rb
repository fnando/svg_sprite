module SvgSprite
  class CLI < Thor
    check_unknown_options!

    def self.exit_on_failure?
      true
    end

    desc "version", "Display svg_sprite version"
    map %w[-v --version] => :version

    def version
      say SvgSprite::VERSION
    end

    desc "generate", "Generate the SVG sprite by embedding the images as data URIs."
    option :source, aliases: %w[-s], required: true, desc: "The source directory. Will match SOURCE/**/*.svg."
    option :output, aliases: %w[-o], required: true, desc: "The output file. Must be a file with a known format extension (#{OUTPUT_FORMATS.join(", ")})"
    option :name, aliases: %w[-n], default: "sprite", desc: "The sprite name. This will be used as the variable for dynamic files."
    def generate
      format = File.extname(options["output"])[1..-1]
      fail Error, "ERROR: invalid output extension. Must be one of #{OUTPUT_FORMATS.join("|")}." unless valid_format?(format)

      SvgSprite.export(
        source: File.expand_path(options["source"]),
        output: File.expand_path(options["output"]),
        format: format,
        name: options["name"]
      )
    end

    private

    def valid_format?(format)
      OUTPUT_FORMATS.include?(format)
    end
  end
end
