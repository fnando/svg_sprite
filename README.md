# SvgSprite

Create SVG sprites by embedding images into CSS using data URIs.

## Installation

    $ gem install svg_sprite

## Usage

### Sass support

To create a sprite:

```
$ svg_sprite -s images/icons -o styles/_icons.scss -n icons
```

Let's say the `images/icons` directory has a file called `user.svg`. The command above will create some mixins and placeholders.

```
// this variable holds all image names
$icons-names

// this placeholder sets a background image
%icons-user

// this mixin will set the background image on the element's `:before` pseudo-element.
@include icons-before("user");

// this mixin will set the background image on the element's `:after` pseudo-element.
@include icons-after("user");
```

When using SCSS, the generated stylesheet will have a variable with a list of all images inside the generated sprite, so you can hack own your own on top of that.

```scss
@each $image in $icons-names {
  .my-class-for-#{$image} {
    @extend %icons-#{$image};
  }
}
```

### CSS support

To create a sprite:

```
$ svg_sprite -s images/icons -o styles/_icons.css -n icons
```

Let's say the `images/icons` directory has a file called `user.svg`. The command above will create some classes.

```
// this class will set the background image on the element.
.icons-user

// this class will set the background image on the element's `:before` pseudo-element.
.icons-user-before

// this mixin will set the background image on the element's `:after` pseudo-element.
.icons-user-after
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fnando/svg_sprite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

