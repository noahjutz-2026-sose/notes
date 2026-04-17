#import "/deps.typ": cetz
#import "/style.typ": *

#cetz.canvas(length: 5cm, {
  import cetz.draw: *
  circle((0, 0), radius: 1)
  set-style(mark: (end: "straight"), stroke: colors.on_surface.lighter)

  let dim = 1.25
  line((-dim, 0), (dim, 0))
  line((0, -dim), (0, dim))

  for (i, (label_x, label_y, rotation)) in (
    ($sqrt(3)/2$, $1/2$, calc.pi / 6),
    ($sqrt(2)/2$, $sqrt(2)/2$, calc.pi / 4),
    ($1/2$, $sqrt(3)/2$, calc.pi / 3),
  ).enumerate() {
    set-style(mark: (end: ">"), stroke: colors.on_surface.lighter)
    arc(
      (0, 0),
      start: 0rad,
      delta: 1rad * rotation,
      radius: .3 + i * .1,
      anchor: "origin",
      name: "a",
    )

    // on-layer(1, {
    //   content(
    //     "a.arc-center",
    //     anchor: "south-west",
    //   )[#label_rad]
    // })

    group({
      rotate(1rad * rotation)
      set-style(mark: none, stroke: (dash: "dashed"))
      line((0, 0), (1, 0), name: "l")
      rotate(1rad * -rotation)
      set-style(stroke: (dash: "solid", paint: red.transparentize(50%)))
      line("l.end", ("l.end", "|-", (0, 0)), name: "cos")
      set-style(stroke: (dash: "solid", paint: blue.transparentize(50%)))
      line("l.end", ("l.end", "-|", (0, 0)), name: "sin")

      content(
        ("sin", "-|", (0, 0)),
        anchor: "east",
        padding: 10pt,
      )[#label_y]
      content(
        ("cos", "|-", (0, 0)),
        anchor: "north",
        padding: 16pt,
      )[#label_x]
    })
  }

  for (label_rad, label_deg, rotation) in (
    ($0$, $0degree$, 0),
    ($pi/6$, $30degree$, calc.pi * 1 / 6),
    ($pi/4$, $45degree$, calc.pi * 1 / 4),
    ($pi/3$, $60degree$, calc.pi * 1 / 3),
    ($pi/2$, $90degree$, calc.pi * 1 / 2),
    ($(2pi)/3$, $120degree$, calc.pi * 2 / 3),
    ($(3pi)/4$, $135degree$, calc.pi * 3 / 4),
    ($(5pi)/6$, $150degree$, calc.pi * 5 / 6),
    ($pi$, $180degree$, calc.pi),
    ($(7pi)/6$, $210degree$, calc.pi * 7 / 6),
    ($(5pi)/4$, $225degree$, calc.pi * 5 / 4),
    ($(4pi)/3$, $240degree$, calc.pi * 4 / 3),
    ($(3pi)/2$, $270degree$, calc.pi * 3 / 2),
    ($(5pi)/3$, $300degree$, calc.pi * 5 / 3),
    ($(7pi)/4$, $315degree$, calc.pi * 7 / 4),
    ($(11pi)/6$, $330degree$, calc.pi * 11 / 6),
  ) {
    group({
      rotate(1rad * rotation)
      circle((1, 0), fill: black, stroke: none, radius: 2pt)
      content((1.1, 0))[#text(colors.on_surface.light)[#label_rad]]
      content((.9, 0))[#text(colors.on_surface.light)[#label_deg]]
    })
  }
})
