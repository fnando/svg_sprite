# Changelog

<!--
Prefix your message with one of the following:

- [Added] for new features.
- [Changed] for changes in existing functionality.
- [Deprecated] for soon-to-be removed features.
- [Removed] for now removed features.
- [Fixed] for any bug fixes.
- [Security] in case of vulnerabilities.
-->

## v1.0.3

- [Changed] SVG sprite won't include `display: none` anymore; instead, a class
  `:name--sprite` is added. This eases the CSP setups, as it won't include a
  inline style. Make sure you hide the sprite with something like
  `.icon--sprite { display: none }`.

## v1.0.2

- [Changed] Remove `<symbol>`'s `width` and `height` property, otherwise Google
  Chrome and Firefox won't be able to resize the SVG properly. The `viewBox`
  will determine the svg's dimensions.

## v1.0.1

- [Changed] SVG sprite now includes the sprite name as the id. It means you'll
  to use a link href like `#icons--trash` (previously the sprite name wasn't
  included).
