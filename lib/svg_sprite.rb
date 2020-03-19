# frozen_string_literal: true

module SvgSprite
  require "base64"
  require "cgi"
  require "erb"
  require "svg_optimizer"
  require "thor"
  require "fileutils"

  require "svg_sprite/version"
  require "svg_sprite/template/scss"
  require "svg_sprite/template/css"
  require "svg_sprite/template"
  require "svg_sprite/sprite"
  require "svg_sprite/source"
  require "svg_sprite/svg"
  require "svg_sprite/cli"

  def self.create(options)
    Sprite.new(
      Source.new(options[:source]),
      find_template(options[:format]),
      options
    )
  end

  def self.export(options)
    FileUtils.mkdir_p(File.dirname(options[:output]))
    File.open(options[:output], "w") do |file|
      file << create(options).render
    end
  end

  def self.find_template(format)
    TEMPLATES[format] || raise("Invalid output format.")
  end
end
