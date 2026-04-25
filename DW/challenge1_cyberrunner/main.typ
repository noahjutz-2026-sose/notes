#import "/template.typ": template_presentation
#import "/deps.typ": cetz, cetz-plot, codly, diagraph, touying
#import "/style.typ": *
#import "/components/presentation.typ": *
#import touying: *

#show: template_presentation

#slide()[
  #set align(horizon)
  #title[CyberRunner Warehouse]
  Analyse von Reinforcement Learning Daten

  #place(bottom + end)[
    #set text(size: 14pt, fill: white.transparentize(50%))
    Noah Jutz #sym.dot
    2026-04-28 #sym.dot
    Data Warehousing
  ]
]

= Thema

#place(bottom + left, dx: -32pt, dy: 96pt)[
  #cetz.canvas(length: 8cm, {
    import cetz-plot: *
    import cetz.draw: *

    let data = json("assets/score.json").map(it => (it.at(1), it.at(2)))
    set-style(stroke: 4pt)

    plot.plot(
      axis-style: none,
      size: (3, 1),
      plot.add(data, style: (stroke: color.hsv(200deg, 50%, 80%).transparentize(80%))),
    )
  })
]

#align(horizon)[
  KI lernt, Kugel durch Labyrinth zu führen.

  Dabei entstehen Performance-Daten über Zeit.

  Verraten diese Daten, welche Optimierungen nötig sind?
]

#pagebreak()

#align(center + horizon)[
  #quot[
    OTH-Stundent beschleunigt KI-Roboter um 200%
  ]
]

= Daten

#align(horizon)[
  - TensorBoard
]

= Schema

= Fragen

#align(horizon)[
  -
]
