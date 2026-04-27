#import "/template.typ": template_presentation
#import "/deps.typ": cetz, cetz-plot, codly, diagraph, suiji, touying
#import "/style.typ": *
#import "/components/presentation.typ": *
#import touying: *

#show: template_presentation

#let fggrad = gradient.linear(
  angle: 15deg,
  color.hsv(200deg, 00%, 90%),
  color.hsv(200deg, 30%, 100%),
)

#align(horizon)[
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

#place(bottom + end, dy: 50%, dx: 10%)[
  #image("assets/labyrinth.png", height: 100%)
]

#align(horizon)[
  Reinforcement Learning lernt, Kugel durch Labyrinth zu führen.

  Dabei entstehen Performance-Daten über Zeit.

  Verraten diese Daten, welche Optimierungen nötig sind?
]

#pagebreak()

#align(center + horizon)[
  #quot[
    OTH-Stundent beschleunigt KI-Roboter um 200%
  ]
]

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

= Daten

== Quelle

#align(horizon)[
  Eigenes Training (einige Stunden, 2-20 GB)
]

== Format

#align(horizon)[
  #grid(
    columns: 2,
    column-gutter: 24pt,
    align: top,
    row-gutter: 24pt,
    [
      #codly.codly(header: [.ckpt])
      ```py
      ckpt = pickle.load("file.ckpt")
      ```
    ],
    [
      #codly.codly(header: [.tfevents])
      ```sh
      tensorboard --logdir .
      ```
    ],

    [
      #codly.codly(header: [.npz])
      ```py
      with np.load("file.npz") as data:
            print(data["reward"])
      ```
    ],
    [
      #codly.codly(header: [.jsonl])
      ```py
      with open("data.jsonl") as f:
          for line in f:
              json.loads(line)
      ```
    ],

    [
      #codly.codly(header: [.sqlite3])
      ```

      ```
    ],
    [
      #codly.codly(header: [.csv])
      ```

      ```
    ],
  )
]

== Inhalt

#align(horizon)[
  #grid(
    columns: (1fr,) * 2,
    column-gutter: 24pt,
    stroke: (x, y) => if x == 0 { (right: 2pt + fggrad) },
    inset: (y: 32pt),
    [
      #text(fill: fggrad, weight: "black")[Dimensionen]

      - Step
      - Timestamp
      - Hyperparameter
      - Run ID
    ],
    [
      #text(fill: fggrad, weight: "black")[Fakten]

      - Reward
      - Observation (z.B. Ball-Position)
      - PC-Auslastung (z.B. GPU)
      - etc.
    ],
  )
]

== Schema

#align(horizon + center)[
  #set text(font: "JetBrainsMono NF")
  #set table(stroke: fggrad)
  #grid(
    columns: 2,
    column-gutter: 16pt,
    align: top + start,
    table(
      [*Step*],
      [
        count \
        timestamp \
        reward \
        ball_x \
        ball_y \
        plate_alpha \
        plate_beta \
        action_1 \
        action_2 \
        ...
      ],
    ),
    table(
      [*Load*],
      [
        timestamp \
        cpu0 \
        cpu1 \
        ... \
        gpu \
        vram \
        ram
      ],
    ),
  )
]

= Mögliche Erkenntnisse

#align(horizon)[
  #text(fill: fggrad, weight: "black")[Hardware]
  - Welche Ressourcen sind bei geringen FPS ausgelastet?
  #text(fill: fggrad, weight: "black")[Hyperparameter]
  - Welche Entropy maximiert den Reward?
  - Welche Replay Size maximiert den Reward?
  - Wie verhält sich der Gradient descent, wenn länger kein Fortschritt gemacht wird?
  #text(fill: fggrad, weight: "black")[Sonstiges]
  - Ist der Reward direkt an den Fortschritt gebunden?
]
