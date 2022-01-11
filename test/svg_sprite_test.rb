# frozen_string_literal: true

require "test_helper"

class SvgSpriteTest < Minitest::Test
  let(:input) { File.expand_path("#{__dir__}/fixtures") }
  let(:sprite_path) { File.expand_path("./tmp/sprite.svg") }
  let(:css_path) { File.expand_path("./tmp/sprite.css") }

  setup do
    FileUtils.rm_rf("./tmp")
    FileUtils.mkdir_p("./tmp")
  end

  test "generates files" do
    SvgSprite.call(
      input: input,
      sprite_path: sprite_path,
      css_path: css_path
    )

    assert File.file?(sprite_path)
    assert File.file?(css_path)
  end

  test "generates css file" do
    SvgSprite.call(
      input: input,
      sprite_path: sprite_path,
      css_path: css_path
    )

    css_parser = CssParser::Parser.new
    css_parser.load_file!(css_path)

    icon = css_parser.find_rule_sets([".sprite--trash"]).first
    refute_nil icon
    assert_equal "16px;", icon[:width]
    assert_equal "16px;", icon[:height]

    icon = css_parser.find_rule_sets([".sprite--trash-filled"]).first
    refute_nil icon
    assert_equal "16px;", icon[:width]
    assert_equal "16px;", icon[:height]
  end

  test "generates svg file" do
    SvgSprite.call(
      input: input,
      sprite_path: sprite_path,
      css_path: css_path
    )

    xml = Nokogiri::XML(File.read(sprite_path))
    svg = xml.css("svg").first
    symbols = svg.css("defs > symbol")

    assert_equal "display: none", svg[:style]
    assert_equal 2, symbols.count

    symbol = symbols.first

    assert_equal "sprite--trash", symbol[:id]
    assert_equal "#FF0000", symbol.css("path").first[:fill]
    assert_equal "0 0 16 16", symbol[:viewBox]

    symbol = symbols.last

    assert_equal "sprite--trash-filled", symbol[:id]
    assert_equal "#727272", symbol.css("g > g").first[:fill]
    assert_equal "0 0 16 16", symbol[:viewBox]
  end

  test "generates svg file using current color" do
    SvgSprite.call(
      input: input,
      sprite_path: sprite_path,
      css_path: css_path,
      fill: "current-color",
      stroke: "current-color"
    )

    xml = Nokogiri::XML(File.read(sprite_path))
    svg = xml.css("svg").first
    symbols = svg.css("defs > symbol")

    assert_equal 2, symbols.count

    symbol = symbols.first

    assert_equal "sprite--trash", symbol[:id]
    assert_equal "currentColor", symbol.css("path").first[:fill]
    assert_equal "0 0 16 16", symbol[:viewBox]

    symbol = symbols.last

    assert_equal "sprite--trash-filled", symbol[:id]
    assert_equal "currentColor", symbol.css("g > g").first[:fill]
    assert_equal "0 0 16 16", symbol[:viewBox]
  end

  test "generates svg file without optimization" do
    SvgSprite.call(
      input: input,
      sprite_path: sprite_path,
      css_path: css_path,
      optimize: false
    )

    xml = Nokogiri::XML(File.read(sprite_path))
    svg = xml.css("svg").first

    assert_equal 1, svg.css("g#trash").count
    assert svg.css("title").any?
  end

  test "removes with and height attributes" do
    SvgSprite.call(
      input: input,
      sprite_path: sprite_path,
      css_path: css_path,
      optimize: false
    )

    xml = Nokogiri::XML(File.read(sprite_path))
    svg = xml.css("symbol").first

    refute_includes svg.attributes.keys, "width"
    refute_includes svg.attributes.keys, "height"
  end

  test "generates command comment on css file" do
    # No optimization flag
    SvgSprite.call(
      input: input,
      sprite_path: sprite_path,
      css_path: css_path,
      optimize: false
    )

    command = "\nsvg_sprite generate --input test/fixtures --sprite-path " \
              "tmp/sprite.svg --css-path tmp/sprite.css --no-optimize\n"
    assert_includes File.read(css_path), command

    # Using stroke and fill
    SvgSprite.call(
      input: input,
      sprite_path: sprite_path,
      css_path: css_path,
      stroke: "current-color",
      fill: "current-color"
    )

    command = "\nsvg_sprite generate --input test/fixtures --sprite-path " \
              "tmp/sprite.svg --css-path tmp/sprite.css --stroke " \
              "current-color --fill current-color\n"
    assert_includes File.read(css_path), command

    # Using custom name
    SvgSprite.call(
      input: input,
      sprite_path: sprite_path,
      css_path: css_path,
      name: "icons"
    )

    command = "\nsvg_sprite generate --input test/fixtures --sprite-path " \
              "tmp/sprite.svg --css-path tmp/sprite.css --name icons\n"
    assert_includes File.read(css_path), command
  end
end
