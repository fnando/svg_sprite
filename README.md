# svg_sprite

[![Tests](https://github.com/fnando/svg_sprite/workflows/ruby-tests/badge.svg)](https://github.com/fnando/svg_sprite)
[![Gem](https://img.shields.io/gem/v/svg_sprite.svg)](https://rubygems.org/gems/svg_sprite)
[![Gem](https://img.shields.io/gem/dt/svg_sprite.svg)](https://rubygems.org/gems/svg_sprite)

Create SVG sprites by embedding images into CSS using data URIs. The SVGs are
optimized using [svg_optimizer](https://github.com/fnando/svg_optimizer).

## Installation

```bash
gem install svg_sprite
```

Or add the following line to your project's Gemfile:

```ruby
gem "svg_sprite"
```

## Usage

Let's assume there's a directory called `images` with the following files:

```console
$ tree images
images
├── doc-fill.svg
├── doc.svg
├── trash-fill.svg
└── trash.svg

0 directories, 4 files
```

The following command will export the SVG sprite and a CSS file with all
dimensions.

```
$ svg_sprite generate --input images \
                      --css-path sprite/icons.css \
                      --sprite-path sprite/icons.svg \
                      --name icon
```

All SVGs will be combined into one simple file. You can then refer to the SVG by
using a link.

```html
<svg>
  <use href="sprite/icons.svg#trash" role="presentation">
</svg>
```

If you want to restrict the SVG to the original dimensions, use the export CSS
file. Classes are defined using the `--name` name (defaults to `sprite`),
together with the file name. This is an example:

```css
/*
This file was generated by https://rubygems.org/gems/svg_sprite with the
following command:

svg_sprite generate --input images --sprite-path sprite/icons.svg --css-path sprite/icons.css --optimize --name icon
*/

.icon--doc-fill {
  width: 42px;
  height: 52px;
}

.icon--doc {
  width: 42px;
  height: 52px;
}

.icon--trash-fill {
  width: 48px;
  height: 53px;
}

.icon--trash {
  width: 48px;
  height: 54px;
}
```

By default, SVGs will keep their stroke and fill colors. You can remove or use
`currentColor` instead by using `--stroke` and `--fill`.

```
$ svg_sprite generate --input images \
                      --sprite-path sprite/icons.svg \
                      --css-path sprite/icons.css \
                      --name icon \
                      --stroke current-color \
                      --fill current-color

$ svg_sprite generate --input images \
                      --sprite-path sprite/icons.svg \
                      --css-path sprite/icons.css \
                      --name icon \
                      --stroke remove \
                      --fill remove
```

Finally, all SVGs will be optimized using
[svg_optimizer](https://github.com/fnando/svg_optimizer). To disable it, use
`--no-optimize`.

### Using sprites in practice

You need to embed the final SVG sprite on your HTML page. With Rails, you can
use a helper like this:

```ruby
module ApplicationHelper
  def svg_tag(file)
    File.open(Rails.root.join("app/assets/images", "#{file}.svg")).html_safe
  end
end
```

Then, on your layout file (e.g. `application.html.erb`), you can render it as
`<%= svg_tag(:icons) %>`.

Now, you need to reference those SVG links by adding `<use href="#id">`. You can
create a helper method like this to make things easy.

```ruby
module ApplicationHelper
  def icon(name)
    content_tag :svg, class: "icon icon--#{name}" do
      content_tag :use, nil, href: "##{name}", role: :presentation
    end
  end
end
```

You can render icons by using `<%= icon(:trash) %>`.

### Programming API

To export both the CSS and SVG files:

```ruby
require "svg_sprite"

SvgSprite.call(
  input: "./images/icons",
  name: "icon",
  css_path: "./sprite/icons.css",
  svg_path: "./sprite/icons.svg",
  optimize: true,
  stroke: "remove",
  fill: remove
)
```

## Maintainer

- [Nando Vieira](https://github.com/fnando)

## Contributors

- <https://github.com/fnando/svg_sprite/contributors>

## Contributing

For more details about how to contribute, please read
<https://github.com/fnando/svg_sprite/blob/main/CONTRIBUTING.md>.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be
found at <https://github.com/fnando/svg_sprite/blob/main/LICENSE.md>.

## Code of Conduct

Everyone interacting in the svg_sprite project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/svg_sprite/blob/main/CODE_OF_CONDUCT.md).
