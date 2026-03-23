#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3"
#import "@preview/gentle-clues:1.3.1": *
#import "@preview/mannot:0.3.2": *
#import "@preview/meander:0.4.1"
#import "@preview/codly:1.3.0"
#import "@preview/codly-languages:0.1.10"

#let template(body) = {
  set text(lang: "de", font: "Fira Sans")
  set heading(numbering: (n0, ..x) => numbering("1.1",   n0 - 1, ..x))
  set page(numbering: "1")

  show link: set text(blue)
  show math.equation: set text(font: "Fira Math")
  show math.equation.where(block: true): align.with(start)
  show: gentle-clues.with(
    breakable: true
  )
  show: codly.codly-init

  codly.codly(
      number-format: none,
      languages: codly-languages.codly-languages
  )

  body
}

#let template_exercises(body, prefix: "Ü") = {
    counter(heading).update(0)
    set heading(numbering: (..x) => numbering(prefix + "1.1", ..x))

    body
}
