#import "/components.typ": *
#import "/style.typ": *
#import "/deps.typ": cetz, cetz-plot, gentle-clues, suiji

#align(end)[2026-03-16 VL01]

= Dreiecke und Pixel

Rendering turns triangles to pixels.

$
  { triangle } -> [[ square ]]
$

== Farben

- RGB
- CMY(K)

== Netze

Triangulieren von Polygonen

- Konvex trivial
- Konkav möglich

In 3D: Vertexe definieren polygon nicht eindeutig, aber Dreiecke schon

- Bezier, B-Spline, ...
- Subdivision Surfaces

#align(end)[2026-03-23 VL02]

=== Effizientes Speichern von Dreiecken

#let index_list = (4, 5, 2, 4, 6, 5)

#cetz.canvas({
  import cetz.draw: *
  let rng = suiji.gen-rng-f(40)
  let (rng, v) = suiji.uniform-f(rng, low: 0, high: 10, size: 2 * 10)
  let positions = v.chunks(2)
  for (i, pos) in positions.enumerate() {
    circle(pos, radius: 2pt, stroke: none, fill: black)
    content(pos, anchor: "north", padding: 2pt)[$v_#i$]
  }

  for (v1, v2, v3) in index_list.chunks(3) {
    line(positions.at(v1), positions.at(v2), positions.at(v3), close: true)
  }
})

- Statt Vertexe nur indizes speichern $(1+S_I/S_V)$

Ein Vertex besteht aus
- Position $RR^3$
- Normale $RR^3$
- Texturkoordinate $RR^2$

= Rasterisieren

$
  {triangle} -> "magic" -> {triangle_"2D"} stretch(->)^"Wir sind hier" [[square]]
$

Ist ein Punkt in einem konvexen Polygon?

Kanten entlang laufen, wenn der Punkt immer auf der Seite nach innen liegt, ist er innen.

#grid(
  columns: 2,
  align: horizon,
  column-gutter: 32pt,
  cetz.canvas({
    import cetz.draw: *
    let mid = (x1, x2) => ((x1.at(0) + x2.at(0)) / 2, (x1.at(1) + x2.at(1)) / 2)
    let a = (3, 0)
    let b = (5, 5)
    let c = (0, 6)
    let p = (3, 2)

    circle(p, radius: 3pt, stroke: none, fill: red)
    set-style(mark: (end: "straight"))
    line(a, b)
    line(b, c)
    line(c, a)

    for (v, w) in ((a, b), (b, c), (c, a)) {
      line(
        mid(v, w),
        p,
        stroke: gray,
        name: "real",
      )
      line(
        mid(v, w),
        cetz.vector.add(
          cetz.util.line-normal(v, w),
          mid(v, w),
        ),
        name: "norm",
      )
      cetz.angle.angle(
        "real.start",
        "norm.end",
        "real.end",
        mark: none,
        direction: "near",
      )
    }
  }),
  cetz.canvas({
    import cetz-plot: *

    plot.plot(
      size: (5, 3),
      axis-style: "school-book",
      x-tick-step: calc.pi,
      y-tick-step: 1,
      {
        plot.add(
          domain: (-calc.pi, calc.pi),
          calc.cos,
        )
        plot.add-fill-between(
          domain: (-calc.pi / 2, calc.pi / 2),
          calc.cos,
          it => 0,
          style: (stroke: none),
        )
      },
    )
  }),
)

#align(end)[2026-03-30 VL03]

== Lineare Interpolation

_Lerp:_

$
  "lerp"(a, b, t) = (1-t) dot h(a) + t dot h(b) quad quad t in [0;1]
$

#alternative[
  $
    "lerp"(a, b)(t) \
    "lerp"(t)(a, b)
  $
]

== Baryzentrische Interpolation

#figure(
  include "figures/bary_interp.typ",
  caption: [Baryzentrischer Mittelpunkt],
)

Wenn die längste Kante weniger als ein Pixel ist, muss man nur einen Pixel prüfen.

== Clipping

Bounding Box auf View begrenzen

#align(end)[2026-04-13 VL04]

= Transformationen

_Affine Transformation:_ Translation, (Nicht-)Uniforme Skalierung, Rotation, Scherung

#figure(
  include "figures/shear.typ",
  caption: [
    Shear in #text(blue)[x], #text(green)[y] und #text(red)[z].
  ],
)

#align(end)[2026-04-13 VL05]

== Konkatenation

#clue[
  Es ist einfacher, jedes mal ein Matrixvektorprodukt zu berechnen, statt die Transformationsmatrizen zu multiplizieren.

  $
    A_1 A_2 A_3 x = A_1 A_2 x' = A_1 x'' = x'''
  $
]


== Homogene koordinaten

Man kann die Translation in die Transformationsmatrix einbinden.

$
  A x + t = mat(
    A, t;
    0^T, 1
  ) x
$

In 1D:

$
  x in RR -> vec(x, 1) in RR^2
$

== Normalenvektor unter Transformation

$
  n^T t = n^T I t = n^T A^(-1) A t = n^T A^(-1) t'
$

$=>$ Man kann den durch $A$ transformierten Vektor $t'$ mit $A^(-1)$ transformieren, um seine Normale zu finden

== Rotation

#clue[
  Figur auf Folie 15:

  + Rotiere um $z$ um $alpha$
  + Um $N$ um $beta$
  + Um $y$ um $gamma$
]
