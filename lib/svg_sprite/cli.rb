# frozen_string_literal: true

class SvgSprite
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

    desc "generate",
         "Generate the SVG sprite by embedding the images as data URIs."
    option :input,
           aliases: %w[-i],
           required: true,
           desc: "The input directory. Will match INPUT/**/*.svg."
    option :css_path,
           aliases: %w[-c],
           required: true,
           desc: "The CSS output file path."
    option :sprite_path,
           aliases: %w[-s],
           required: true,
           desc: "The SVG output file path."
    option :name,
           aliases: %w[-n],
           default: "sprite",
           desc: "The sprite name. This will be used as the variable for dynamic files."
    option :optimize,
           aliases: %w[-o],
           default: true,
           type: :boolean,
           desc: "Optimize SVG files."
    option :stroke,
           aliases: %w[-t],
           enum: %w[current-color remove],
           desc: "Stroke replacement strategy."
    option :fill,
           aliases: %w[-f],
           enum: %w[current-color remove],
           desc: "Fill replacement strategy."
    def generate
      input = File.expand_path(options["input"])

      SvgSprite.call(
        input: input,
        sprite_path: File.expand_path(options["sprite_path"]),
        css_path: File.expand_path(options["css_path"]),
        name: options["name"],
        optimize: options["optimize"],
        stroke: options["stroke"],
        fill: options["fill"]
      )
    end
  end
end
