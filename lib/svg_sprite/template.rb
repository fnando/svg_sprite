# frozen_string_literal: true

module SvgSprite
  TEMPLATES = {
    "scss" => Template::SCSS.new,
    "css" => Template::CSS.new
  }.freeze
end
