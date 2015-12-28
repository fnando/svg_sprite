# Exporting Sass files

Run this command to export the sprite:

```
RUBYOPT="-I./lib" ./exe/svg_sprite generate -s examples/source -o examples/source/_icons.scss
```

Then run this command to export the styles:

````
scss examples/source/scss.scss examples/dist/scss.css
````

# Exporting vanilla CSS

```
RUBYOPT="-I./lib" ./exe/svg_sprite generate -s examples/source -o examples/dist/css.css
```
