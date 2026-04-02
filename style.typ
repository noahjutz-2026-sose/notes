#let colors = (
  primary: rgb("#cc5de8"),
  secondary: rgb("#f06595"),
  error: rgb("#ff0000"),
  success: rgb("#00ff00"),
  on_surface: black,
)

#let colors = colors.pairs().map(((k, v)) => (
  k, (
    normal: v,
    lighter: v.lighten(85%),
    light: v.lighten(50%),
    dark: v.darken(50%)
  )
)).to-dict()
