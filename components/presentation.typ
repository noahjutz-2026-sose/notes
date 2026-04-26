#let quot(body) = context box(
  // stroke: 4pt + color.hsv(200deg, 50%, 90%),
  // inset: 16pt,
  inset: 0pt,
)[
  #let quotation(l: true) = [
    #set text(size: 64pt, weight: "black", fill: white.transparentize(50%))
    #if l [\u{f027e}] else [\u{f0757}]
  ]
  #let (width, height) = measure(quotation())
  #place(bottom + left, dx: -width / 2, dy: height / 3 * 2)[
    #quotation()
  ]
  #place(top + right, dx: width / 2, dy: -height / 3 * 2)[
    #quotation(l: false)
  ]

  #body
]
