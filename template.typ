#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3"
#import "@preview/gentle-clues:1.3.1": *
#import "@preview/mannot:0.3.2": *
#import "@preview/meander:0.4.1"
#import "@preview/codly:1.3.0"
#import "@preview/codly-languages:0.1.10"

#let template(body) = {
  let text_size = 11pt
  show title: set text(size: 32pt, weight: "black")
  set document(
    author: "Noah Jutz"
  )
  set text(
      lang: "de",
      font: "Lato",
      size: text_size
  )
  set heading(numbering: (n0, ..x) => numbering("1.1",   n0 - 1, ..x))
  set page(numbering: "1")
  set math.mat(delim: "[")
  set table(
      stroke: black.lighten(85%),
      align: bottom,
  )

  show link: set text(blue)
  show math.equation: set text(font: "Lete Sans Math")
  show math.equation.where(block: true): align.with(start)
  show: gentle-clues.with(
    breakable: true
  )
  show: codly.codly-init

  show raw: set text(
      font: "JetBrainsMono NF",
      size: text_size - 2pt
  )

  codly.codly(
      number-format: none,
      languages: codly-languages.codly-languages,
      header-transform: it => align(start,
          text(
              weight: "bold",
              it
          )
      ),
      header-cell-args: (
          stroke: 1pt + black.transparentize(85%),
      ),
      stroke: 1pt + black.transparentize(85%),
      zebra-fill: none,
      lang-stroke: none,
      lang-fill: it => rgb(0, 0, 0, 0),
  )

  body
}

#let template_exercises(body, prefix: "Ü") = {
    counter(heading).update(0)
    set heading(numbering: (..x) => numbering(prefix + "1.1", ..x))

    body
}
