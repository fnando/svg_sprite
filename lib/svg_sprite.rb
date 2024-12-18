# frozen_string_literal: true

require "svg_optimizer"
require "thor"
require "fileutils"
require "shellwords"
require "pathname"

class SvgSprite
  NOKOGIRI_SAVE_OPTIONS = {
    save_with: Nokogiri::XML::Node::SaveOptions::DEFAULT_XML |
               Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
  }.freeze

  DEFAULT_SPRITE_NAME = "sprite"

  require "svg_sprite/version"
  require "svg_sprite/cli"
  require "svg_sprite/svg"

  def self.call(
    input:,
    sprite_path:,
    css_path:,
    name: DEFAULT_SPRITE_NAME,
    optimize: true,
    stroke: nil,
    fill: nil
  )
    new(
      name: name,
      input: input,
      sprite_path: sprite_path,
      css_path: css_path,
      optimize: optimize,
      stroke: stroke,
      fill: fill
    ).tap(&:call)
  end

  attr_reader :name, :sprite_path, :input, :css_path, :optimize, :stroke, :fill,
              :input_files

  def initialize(
    name:, input:, sprite_path:, css_path:, optimize:, stroke:, fill:
  )
    @name = name
    @input = input
    @input_files = Dir["#{input}/**/*.svg"]
    @sprite_path = sprite_path
    @css_path = css_path
    @optimize = optimize
    @stroke = stroke
    @fill = fill
  end

  def call
    save_file sprite_path, svg_sprite
    save_file css_path, manifest(css_definitions.chomp)
    self
  end

  private def manifest(css)
    <<~TEXT
      /*
      This file was generated by https://rubygems.org/gems/svg_sprite with the
      following command:

      #{command}
      */

      #{css}
    TEXT
  end

  private def command
    cwd = Pathname.new(Dir.pwd)

    cmd = [
      "svg_sprite",
      "generate",
      "--input",
      Pathname.new(input).relative_path_from(cwd).to_s,
      "--sprite-path",
      Pathname.new(sprite_path).relative_path_from(cwd).to_s,
      "--css-path",
      Pathname.new(css_path).relative_path_from(cwd).to_s
    ]

    cmd.push("--name", name) if name != DEFAULT_SPRITE_NAME
    cmd.push("--no-optimize") unless optimize
    cmd.push("--stroke", stroke) if stroke
    cmd.push("--fill", fill) if fill

    cmd.map {|segment| Shellwords.escape(segment) }.join(" ")
  end

  private def svgs
    @svgs ||= input_files
              .map {|file| build_svg(file) }
              .sort_by(&:id)
  end

  private def build_svg(file)
    SVG.new(file, name: name, optimize: optimize, stroke: stroke, fill: fill)
  end

  private def css_definitions
    svgs.each_with_object(StringIO.new) do |svg, io|
      io << ".#{svg.id} {\n"
      io << "  width: #{svg.width};\n"
      io << "  height: #{svg.height};\n"
      io << "}\n\n"
    end.tap(&:rewind).read.chomp
  end

  private def save_file(filepath, content)
    FileUtils.mkdir_p(File.dirname(filepath))

    File.open(filepath, "w") do |io|
      io << content
    end
  end

  private def svg_sprite
    builder = sprite_builder
    add_symbols(builder.doc.css("defs").first)

    Nokogiri::XML(builder.to_xml) {|doc| doc.default_xml.noblanks }
            .to_xml(NOKOGIRI_SAVE_OPTIONS.dup.merge(indent: 2))
  end

  private def sprite_builder
    Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.svg(
        xmlns: "http://www.w3.org/2000/svg",
        class: "#{name}--sprite"
      ) do |svg|
        svg.defs { } # rubocop:disable Lint/EmptyBlock
      end
    end
  end

  private def add_symbols(defs)
    svgs.each do |svg|
      defs << svg.symbol
    end
  end
end
