module SvgSprite
  require "erb"
  require "base64"
  require "svg_optimizer"
  require "thor"

  OUTPUT_FORMATS = %w[scss css].freeze
  require "svg_sprite/cli"
  require "svg_sprite/version"
  require "svg_sprite/template/scss"
  require "svg_sprite/template/css"
  require "svg_sprite/sprite"
  require "svg_sprite/source"
  require "svg_sprite/svg"

  TEMPLATES = {
    "scss" => Template::SCSS.new,
    "css"  => Template::CSS.new
  }

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
    TEMPLATES[format] || fail("Invalid output format.")
  end
end
