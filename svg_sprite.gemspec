# frozen_string_literal: true

require "./lib/svg_sprite/version"

Gem::Specification.new do |spec|
  spec.name          = "svg_sprite"
  spec.version       = SvgSprite::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]

  spec.summary       = "Create SVG sprites using data URIs."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/fnando/svg_sprite"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "svg_optimizer"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-fnando"
end
