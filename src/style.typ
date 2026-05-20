#let colors = (
  primary: rgb("#cc5de8"),
  secondary: rgb("#f06595"),
  error: rgb("#ff0000"),
  success: rgb("#00ff00"),
  on_surface: black,
)

#let colors = (
  colors
    .pairs()
    .map(((k, v)) => (
      k,
      (
        normal: v,
        light: v.lighten(50%),
        lighter: v.lighten(85%),
        transparent: v.transparentize(50%),
        transparenter: v.transparentize(85%),
        dark: v.darken(50%),
      ),
    ))
    .to-dict()
)
