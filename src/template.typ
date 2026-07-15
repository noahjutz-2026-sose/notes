#import "/deps.typ": codly, codly-languages, gentle-clues, hydra, touying
#import "/style.typ": *

#let template_base(body) = {
  set document(
    author: "Noah Jutz",
  )
  set text(
    lang: "de",
    font: "Lato",
  )
  set heading(numbering: "1.1")
  set math.mat(delim: "[")
  set table(
    stroke: black.lighten(85%),
    align: bottom,
  )

  show link: set text(blue)
  show math.equation: set text(font: "Lete Sans Math")
  show math.equation.where(block: true): align.with(start)
  show math.equation.where(block: true): set block(breakable: true)
  show: gentle-clues.gentle-clues.with(
    breakable: true,
  )
  show: codly.codly-init

  show raw: set text(
    font: "JetBrainsMono NF",
  )

  codly.codly(
    number-format: none,
    languages: codly-languages.codly-languages,
    header-transform: it => align(start, text(
      weight: "bold",
      it,
    )),
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

#let template_document(body, doc_title: none) = {
  show: template_base
  let text_size = 11pt
  show title: set text(size: 32pt, weight: "black")
  set text(
    size: text_size,
  )
  set heading(numbering: none)

  show outline.entry.where(level: 1): it => {
    show: strong
    it
  }
  set outline(depth: 3)
  body
}

#let template_document_part(body) = {
  counter(heading).update(0)
  set heading(
    offset: 1,
    numbering: (..x) => {
      let x = x.pos()
      numbering("1.1", ..x.slice(1))
    },
  )
  body
}

#let template_cheatsheet(body) = {
    set page(margin: 1cm)
    set heading(
        numbering: (..nums) => {
            if nums.len() == 2 {nums.pos().last()} else {none}
    })
    body
}

#let template_presentation(body) = {
  import touying: *
  show: template_base
  let font_size = 20pt

  set text(size: font_size)

  show: touying-slides.with(
    config-page(
      margin: 32pt,
      footer-descent: 0em,
    ),
    config-common(
      slide-fn: themes.simple.slide,
      zero-margin-footer: true,
      zero-margin-header: true,
    ),
    config-store(
      header: none,
      subslide-preamble: block(below: 1em)[
        #text(2em, weight: "black", utils.display-current-heading(level: 1)) \
        #text(1em, weight: "bold", utils.display-current-heading(level: 2))
      ],
      header-right: none,
      footer: none,
      footer-right: {}, // context utils.slide-counter.display() + " / " + utils.last-slide-number,
    ),
  )

  set page(
    fill: gradient.linear(
      angle: 45deg,
      color.hsv(200deg, 50%, 10%),
      color.hsv(200deg, 50%, 25%),
    ),
  )

  show title: set text(
    size: 80pt,
    weight: "black",
    fill: gradient.linear(
      angle: 15deg,
      color.hsv(200deg, 00%, 90%),
      color.hsv(200deg, 30%, 100%),
    ),
  )

  show title: set par(leading: 8pt)
  show title: set block(spacing: 8pt)

  set text(fill: white)

  codly.codly(
    stroke: 2pt
      + gradient.linear(
        angle: 45deg,
        color.hsv(200deg, 80%, 80%),
        color.hsv(200deg, 40%, 100%),
      ),
  )

  set raw(theme: "/assets/cyberdream.tmTheme")

  set table(stroke: 2pt, inset: 12pt)

  body
}
