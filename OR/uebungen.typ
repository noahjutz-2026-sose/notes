#import "/deps.typ": cetz, cetz-plot, gentle-clues, mannot
#import "/style.typ": colors
#import mannot: *
#import gentle-clues: clue

#align(end)[2026-03-23 TT01]

= Grundlegende Modellierung

== Produktionsplanung

Siehe #link("https://github.com/noahjutz-2026-sose/or-ue01")[or-ue01/excel_solver.xlsx]

== Automobilproduktion

*Produkte*
$
  P_1 = L space.quad ; space.quad
  P_2 = K
$

*Koeffizienten:* Gewinn
$
  c_1=2000 euro space.quad ; space.quad
  c_2=3000 euro
$

*Variablen*
$
  x_1 := "Anzahl" P_1 space.quad ; space.quad
  x_2 := "Anzahl" P_2 space.quad ; space.quad
  x_3, x_4 := "Schlupfvariablen"
$

*Zielfunktion*

$
  F(x_1, x_2) = sum_(i=0)^p c_i x_i = 2000 x_1 + 3000 x_2
$

*Nebenbedingungen:* Kapazität PT
$
  3 x_1 + 5 x_2 + x_3 & = 180 "(Vormontage)" \
  3 x_1 + 3 x_2 + x_4 & = 135 "(Endmontage)"
$

=== Matrixform

$
  c = vec(2000, 3000) space.quad ; space.quad
  x = vec(x_1, x_2, x_3, x_4) space.quad ; space.quad
  A = mat(
    3, 5, 1, 0;
    3, 3, 0, 1
  ) space.quad ; space.quad
  b = vec(180, 135) space.quad ; space.quad
  F(x) = c^T x
$

== Python

- Google OR-Tools: #link("https://github.com/noahjutz-2026-sose/or-ue01")[or-ue01/ue1-3a]
- Scipy: #link("https://github.com/noahjutz-2026-sose/or-ue01")[or-ue01/ue1-3b]

#align(end)[2026-03-30 TT02]
= Lineare Optimierung

*Gegeben*

#table(columns: 2)[F][
  $
                F(x_1, x_2) & = 4x_1 + 3x_2 \
    stretch(<=>)^(F=20) x_2 & = (20-4x)/3 \
    stretch(<=>)^(F=10) x_2 & = (10-4x)/3
  $
][NB1][
  $
    x_1 + 3 x_2 & <= 9 \
        <=> x_2 & <= 3-x_1/3
  $
][NB2][
  $
           -x_1 + 2x_2 & <= 2 \
    <=> x_2 <= 1+x_1/2
  $
][NB3][
  $ x_1 >= 0 $
][NB4][
  $ x_2 >= 0 $
]

== Graphische Lösung

=== Optimum

#figure(
  caption: [Graphische Lösung des LP-Problems],
)[
  #cetz.canvas({
    import cetz-plot: *
    import cetz.draw: *

    let nb1 = x => 3 - x / 3
    let nb2 = x => 1 + x / 2
    let nb3 = x => 0

    let f20 = x => (20 - 4 * x) / 3
    let f10 = x => (10 - 4 * x) / 3

    let f_opt = x => 81 / 15 - 4 / 3 * x

    //content((10, 10))[#cas.display(nb2_eq)]

    plot.plot(
      size: (10, 5),
      axis-style: "school-book",
      legend-style: (stroke: none),
      x-label: $x_1$,
      x-min: 0,
      x-max: 10,
      x-tick-step: 1,
      y-label: $x_2$,
      y-min: 0,
      y-max: 4,
      y-tick-step: 1,
      {
        for (label, f) in (
          "NB1": nb1,
          "NB2": nb2,
          "NB3": nb3,
        ).pairs() {
          plot.add(
            domain: (0, 10),
            f,
            style: (
              stroke: (
                paint: black.lighten(85%),
                dash: "dashed",
              ),
            ),
            label: label,
          )
        }
        plot.add-vline(
          0,
          style: (
            stroke: (
              paint: black.lighten(85%),
              dash: "dashed",
            ),
          ),
          label: "NB4",
        )

        plot.add-fill-between(
          domain: (0, 9),
          x => calc.min(
            nb1(x),
            nb2(x),
          ),
          nb3,
          style: (stroke: none),
          label: $Z$,
        )

        for (label, f) in (
          ($F=20$, f20),
          ($F=10$, f10),
          ($F=81 slash 5$, f_opt),
        ) {
          plot.add(
            domain: (0, 10),
            f,
            label: label,
          )
        }

        plot.add(
          ((12 / 5, 11 / 5),),
          label: $"NB1"inter"NB2"$,
          mark: "triangle",
          style: (stroke: none),
          mark-style: (plot.default-mark-style(0)),
        )
        plot.add(
          ((9, 0),),
          label: $"NB1"inter"NB3"$,
          mark: "square",
          style: (stroke: none),
          mark-style: (plot.default-mark-style(0)),
        )
        plot.add(
          ((0, 1),),
          label: $"NB2"inter"NB4"$,
          mark: "o",
          style: (stroke: none),
          mark-style: (plot.default-mark-style(0)),
        )
      },
    )
  })
] <lp-graph>

*Eckpunkte*

#table(columns: 3)[][$ x_1 $][$ x_2 $][$ "NB1"="NB2" $][
  $
        3-x_1/3 & = 1+x_1/2 \
    x_1/2+x_1/3 & = 2 \
        5/6 x_1 & = 2 \
            x_1 & = 12/5
  $
][
  $
    3-(12/5)/3 = 11/5
  $
][$ "NB1" = "NB3" $][
  $
    3-x_1/3 & = 0 \
        x_1 & = 9
  $
][
  $
    3-9/3=0
  $
][$ "NB2" = "NB4" $][
  $
    x_1 = 0
  $
][
  $
    x_2 = 1+0/2=1
  $
]

*Optimale Lösung*

$
  F(mark(triangle.small, color: #blue)) & = F(12/5, 11/5) = 16.2 \
    F(mark(square.small, color: #blue)) & = F(9, 0) = 36 \
    F(mark(circle.small, color: #blue)) & = F(0, 1) = 3
$

#box(fill: green.transparentize(50%), inset: 4pt)[
  $
    max_(x_1, x_2) F(x_1, x_2) = F(0, 9) = 45
  $
]

=== Normalform in Summenform

$
   x_1 + 3x_2 + x_3 & = 9 \
  -x_1 + 2x_2 + x_4 & = 2 \
          x_1 + x_5 & = 0 \
          x_2 + x_6 & = 0 \
$

=== Normalform in Matrixform

$
  A = mat(
    1, 3, 1, 0;
    -1, 2, 0, 1;
  ) quad quad
  c = vec(4, 3) quad quad
  b = vec(9, 2)
$

== Simplex

#table(columns: (auto, 1fr))[$
  mat(
    , x_1, x_2, x_3, x_4;
    x_3, a_(1 1), a_(1 2), a_(1 3), a_(1 4), b_1, r_1;
    x_4, a_(2 1), a_(2 2), a_(2 3), a_(2 4), b_2, r_2;
    , -c_1, -c_2, 0, 0,
  )
$][$
  r_i := b_i/a_(i j) "mit Pivot-Spalte" j
$][$
  mat(
    , x_1, x_2, x_3, x_4;
    x_3, markhl(1), 3, 1, 0, 9, 9;
    x_4, -1, 2, 0, 1, 2, -2;
    , -4, -3, 0, 0
  )
$][][$
  mat(
    , x_1, x_2, x_3, x_4;
    x_1, 1, 3, 1, 0, 9, ;
    x_4, 0, 5, 1, 1, 11, ;
    , 0, 9, 4, 0, 36
  )
$][
  - $R_2 -> R_2 + 1 dot R_1$
  - $R_3 -> R_3 + 4 dot R_1$
]

== Basislösungen

Siehe @lp-graph.

#align(end)[2026-04-13 TT03]

= Dualität

== Überführung Primal zu Dual

#table(
  columns: 2,
  table.header($cal(O)$, $cal(D O)$),
  $
    max F(x) = c^T x
  $,
  $
    min F(w) = b^T w
  $,

  $
    A x <= b
  $,
  $
    A^T w >= c
  $,
)

$
  c = vec(6, 4) quad quad
  A = mat(
    1, 2;
    3, 1
  ) quad quad
  b = vec(8, 9) quad quad
  x = vec(x_1, x_2) quad quad
  w = vec(w_1, w_2)
$

== Dualer Simplex

#let p1l = <or_eq1_p1l>
#let p1r = <or_eq1_p1r>
#let p1b = <or_eq1_p1b>
#let p1t = <or_eq1_p1t>

#let p2b = <or_eq1_p2b>
#let p2t = <or_eq1_p2t>
#let p2l = <or_eq1_p2l>
#let p2r = <or_eq1_p2r>
$
     & mat(
         , x_1, mark(x_2, tag: p1t), x_3, x_4, b;
         x_3, 1, 3, 1, 0, 9;
         mark(x_4, tag: p1l), 1, -2, 0, 1, mark(-2, tag: p1r);
         c, -4, mark(-3, tag: p1b), 0, 0, 0;
         r, "N.A.", 3/2
       ) quad
       text(fill: #gray, b_2 < 0 => "Dual" => r=c/a) \
  -> & mat(
         , mark(x_1, tag: p2t), x_2, x_3, x_4, b, r;
         mark(x_3, tag: p2l), 5/2, 0, 1, 3/2, mark(6, tag: p2r), 12/5;
         bold(x_2), -1/2, 1, 0, -1/2, 1, -2;
         c, mark(-5 1/2, tag: p2b), 0, 0, 3/2, 3
       ) quad
       text(fill: #gray, exists.not b < 0 => "Primal" => r = b/a) \
  -> & mat(
         , x_1, x_2, x_3, x_4, b;
         bold(x_1), 1, 0, 2/5, 3/5, 12/5;
         x_2, 0, 1, 1/5, -1/5, 11/5;
         c, 0, 0, 12/5, 51/10, 87/5
       ) quad
       text(fill: #gray, "Optimale Lösung, da kein negativer Wert in F-Zeile") \
       #annot-cetz((p1l, p1r, p1b, p1t, p2l, p2r, p2b, p2t), cetz, {
         import cetz.draw: *
         set-style(stroke: none, fill: colors.primary.transparenter)
         rect-around("or_eq1_p1l", "or_eq1_p1r")
         rect-around("or_eq1_p1b", "or_eq1_p1t")
         rect-around("or_eq1_p2b", "or_eq1_p2t")
         rect-around("or_eq1_p2l", "or_eq1_p2r")
       })
$
