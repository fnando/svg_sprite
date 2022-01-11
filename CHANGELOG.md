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

## Unreleased

- [Changed] Remove `<symbol>`'s `width` and `height` property, otherwise Google
  Chrome and Firefox won't be able to resize the SVG properly. The `viewBox`
  will determine the svg's dimensions.

## v1.0.1

- [Changed] SVG sprite now includes the sprite name as the id. It means you'll
  to use a link href like `#icons--trash` (previously the sprite name wasn't
  included).
