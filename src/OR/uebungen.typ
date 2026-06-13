#import "/deps.typ": cetz, cetz-plot, diagraph, gentle-clues, mannot, timeliney
#import "/style.typ": colors
#import "/components/admonitions.typ": *
#import "components/utils.typ": *
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
         c, mark(-5 1/2, tag: p2b), 0, 0, -3/2, 3
       ) quad
       text(fill: #gray, exists.not b < 0 => "Primal" => r = b/a) \
  -> & mat(
         , x_1, x_2, x_3, x_4, b;
         bold(x_1), 1, 0, 2/5, 3/5, 12/5;
         x_2, 0, 1, 1/5, -1/5, 11/5;
         c, 0, 0, 11/5, 9/5, 81/5
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

== Duale Normalform

=== Primal zu Dual

#table(
  columns: 2,
  table.header([Primal P], [Dual D]),
  [Maxmiere $F(x) = 2x_1 + x_2 + 3x_3 + x_4$], [Minimiere $F(w) = 5w_1 + 4w_2 - 1w_3$],
  $
    x_1 + x_2 + x_3 + x_4 & <= 5 \
       -2x_1 + x_2 - 3x_3 & = 4 \
         -x_1 + x_3 - x_4 & <= -1 \
  $,
  $
    w_1 - 2w_2 - w_3 & >= 2 \
           w_1 + w_2 & = 1 \
    w_1 - 3w_2 + w_3 & >= 3 \
           w_1 - w_3 & = 1
  $,

  $
    x_1, x_3 & >= 0 \
    x_2, x_4 & in RR
  $,
  $
     w_1, w_3 & >= 0 \
    w_2 in RR
  $,
)

=== Normalform PI

$
  A = mat(
    1, 1, 1, 1;
    -2, 1, -3, 0;
    -1, 0, 1, -1
  ) stretch(->)^"Schlupf" mat(
    1, 1, 1, 1, markhl(1), markhl(0);
    -2, 1, -3, 0, markhl(0), markhl(0);
    -1, 0, 1, -1, markhl(0), markhl(1)
  ) stretch(->)^"Nichtnegativ" mat(
    1, 1, markhl(-1), 1, 1, markhl(-1), 1, 0;
    -2, 1, markhl(-1), -3, 0, markhl(0), 0, 0;
    -1, 0, markhl(0), 1, -1, markhl(1), 0, 1
  )
$

Mit $x_1, x_2, ..., x_8 >= 0$.

Maximiere $F(x) = 2x_1 + x_2 - x_3 + 3x_4 + x_5 - x_6 + 0x_7 + 0x_8$.

=== Normalform DI

$
  A^T = mat(
    1, -2, -1;
    1, 1, 0;
    -1, -1, 0;
    1, -3, 1;
    1, 0, -1;
    -1, 0, 1;
    1, 0, 0;
    0, 0, 1
  ) quad quad
  c = vec(2, 1, -1, 3, 1, -1, 0, 0) quad quad
  b = vec(5, 4, -1) quad quad
  w = vec(w_1, w_2, w_3)
$

Mit $w_1, w_2, w_3 in RR$.

Minimiere $F(w) = b^T w$ unter den NB $A^T w >= c$

=== Äquivalenz D und DI

D und DI sind äquivalent, weil

$
  underbrace(
    mat(
      augment: #{ -1 },
      1, 1, 0, 1;
      -1, -1, 0, -1
    ), "NB2, NB3 (DI)" (>=)
  )
  <=> underbrace(
    mat(augment: #{ -1 }, 1, 1, 0, 1),
    "NB2 (D)" (=)
  )
$

Analog für NB5, NB6 (DI) und NB4 (D).

== Ganzzahlige Optimierung

=== Formulieren

Maximiere

$
  F(x) = vec(3, 6, 6, 8, 1) x
$

Unter NB

$
  vec(5, 4, 2, 2 2) x <= 15
$

Mit $x_i in {0, 1, 2}$

=== Lösen

Siehe #link("https://github.com/noahjutz-2026-sose/practice/blob/b272e4903507888812c772da1218ac201ad347be/OR/ue03/main.py")[practice/OR/ue03].

#align(end)[2026-04-20 TT04]

= Branch & Bound

== Cuts

=== GGT und Rounding Cuts

$
      && 10x_1 + 18x_2 & <= 109 \
  <=> &&   5x_1 + 9x_2 & <= 54.5 \
   => &&   5x_1 + 9x_2 & <= 54
$

$
      && 21x_1 - 24x_2 & <= 44 \
  <=> &&   7x_1 - 8x_2 & <= 14 2/3 \
   => &&   7x_1 - 8x_2 & <= 14
$

=== Integer Linear Programming

Maximiere

$
  F(x) = 7x_1 + 10x_2
$

Unter NB

$
  5x_1 + 9x_2 & <= 54 \
    7x_1-8x_2 & <= 14 \
     x_1, x_2 & in ZZ_(>=0)
$

== LP-Relaxation Graphisches Lösen <or_ue0402_ilp_relax>

=== Aufstellen

Ersetze NB $x_1, x_2 in ZZ_(>=0)$ mit $x_1, x_2 >= 0$.

=== Lösen

$
            "NB1" & = "NB2" \
     -5/9 x_1 + 6 & = 7/8x_1 - 1 3/4 \
  (7/8 + 5/9) x_1 & = 7 3/4 \
              x_1 & = (7 dot 4 + 3)/4 dot ((7 dot 9)/(8 dot 9) + (5 dot 8)/(9 dot 8))^(-1) \
                  & = 31/4 dot 72/103 \
                  & = (31 dot 18)/103 \
                  & = 558/103
$

$
  x_2 & = -5/9x_1+6 \
      & = -5/9 dot 558/103 + 6 \
      & = 308/103
$

$
  => "Optimum in " (558/103, 308/103)
$

Zielgraph anpassen

$
  x_2 & = -7/10 x_1 \
  x_2 & = -7/10 (x_1-558/103) + 308/103 \
  x_2 & = -7/10 x_1 + 3493/515
$

Zielfunktion berechnen

$
  F(x) & = 7x_1 + 10x_2 \
       & = 7 dot 558/103 + 10 dot 308/103 \
       & = 6986/103
$

=== Obere Schranke

Das Maximum des relaxierten Problems ist die obere Schranke des diskreten Problems. Ferner kann die Lösung nur Ganzzahlig sein.

$
  floor(6986/103) = 67
$

== Branch & Bound

+ ILP relaxieren und optimale $x, F(x)$ berechnen (siehe @or_ue0402_ilp_relax)
  $
    hat(x) = vec(558/103, 308/103) quad quad
    F(hat(x)) = 6986/103
  $
+ Nicht-ganzzahlige Variable wählen (beide): $hat(x)_1$
+ Branch: $x_1 <= floor(hat(x)_1)$ und $x_1 >= ceil(hat(x)_1)$
  + $x_1 <= 5$ \
    ILP relaxieren und optimale $x, F(x)$ berechnen (siehe #link("https://github.com/noahjutz-2026-sose/practice/blob/f02f5c6ca42eb6149fb59ec23855cf4f1016e04c/OR/ue04/main.py")[practice/OR/ue04])
    $
      hat(x) = vec(5, 3) quad quad
      F(hat(x)) = 65
    $
  + $x_1 >= 6$ \
    Nicht lösbar

Branchen nicht mehr möglich $=>$ Optimale Lösung gefunden

== Schwierigkeiten

=== Lösung

$
  sum_(i=1)^n 0.75 x_i & <= 1 \
   3/4 sum_(i=1)^n x_i & <= 1 \
$

Jedes $x_i$ hat den gleichen Koeffizienten ($0.1$), und es darf aufgrund der NB nur ein $x_i$ gewählt werden. Die optimale Lösung ist also

$
  x_k = 1 \
  x_i = 0 quad forall x_i in {x_1, ..., x_n} \\ {x_k}
$

für ein beliebiges $k$.

=== Limitation Branch & Bound

Der maximal erreichbarte Wert ist $0.1 dot 1 1/3$. Das ist immer größer als die optimale Lösung des ILPs von $0.1$, für alle möglichen Kombinationen $binom(n, 3)$.

=== Neuer Cut

#align(end)[2026-04-23 TT05]

= Dynamische Optimierung

== Zeit minimieren

- Bernd hat 6 Wochen
- Je Woche eine Disziplin aus ${"schwimmen", "radfahren", "laufen"}$
- Jede Disziplin: 1 bis 3 Wochen

=== Zustandswertemengen

$
  Z_0 = {0} \
  Z_1 = {1, 2, 3} \
  Z_2 = {3, 4, 5} \
  Z_3 = {6}
$

#diagraph.raw-render(
  ```
  digraph G {
  rankdir=LR
  node[math=false,shape=none,width=0,height=0,margin=0]
  edge[math=false]
  0 -> 1 [label="1,8"]
  0 -> 2 [label="2,9"]
  0 -> "3a" [label="3,10"]

  1 -> "3b" [label="2,10"]
  1 -> 4 [label="3,13"]

  2 -> "3b" [label="1,6"]
  2 -> 4 [label="2,10"]
  2 -> 5 [label="3,13"]

  "3a" -> 4 [label="1,6"]
  "3a" -> 5 [label="2,10"]

  "3b" -> 6 [label="3,16"]
  4 -> 6 [label="2,12"]
  5 -> 6 [label="1,10"]
  "k=0"->"k=1" [label="x1"]
  "k=1"->"k=2" [label="x2"]
  "k=2"->"k=3" [label="x3"]
  }
  ```,
  labels: rect,
)

=== Transformationsfunktion

=== Zielfunktion

$
  F(x_1, x_2, x_3) = sum_(k=1)^3 f_k (z_(k-1), x_k)
$

=== Entscheidungsfunktionen

$
  f_3(z_2, x_3 = 1) = 10 \
  f_2(z_1, x_2 = 3) = 13
$

=== Rückwärtsinduktion

#table(
  columns: 2,
  $k=2$,
  table(
    columns: 2,
    [], [6],
    [3b], [3,16],
    [4], [2,12],
    [5], [1,10],
  ),

  $k=1$,
  table(
    columns: 4,
    [], [3b], [4], [5],
    [1], $2,16+10=26$, $3,12+13=25$, [],
    [2], $1,16+6=32$, $2,12+10=22$, $3,10+13=23$,
    [3a], [], $1,12+6=18$, $2,10+10=20$,
  ),

  $k=0$,
  table(
    columns: 4,
    [], [1], [2], [3],
    [0], $1,26+8=34$, $2,23+9=32$, $3,20+10=30$,
  ),
)

== Bestellungen

#table(
  columns: 2,
  $k=4$,
  table(
    columns: 2,
    [], [0e],
    [0d], $1Phi_4 + 0c_4=52$,
    [60], $0Phi_4 + 0c_4=0$,
  ),

  $k=3$,
  table(
    columns: 4,
    [], [0d], [60], $min$,
    [0c], $mark(color: #gray, 52) + 1Phi_3 + 0c_3=89$, $mark(color: #gray, 0) + 2Phi_3 + 60c_3=92$, [0d],
    [50], $mark(color: #gray, 52) + 0Phi_3 + 0c_3=52$, [], [0d],
    [110], [], $mark(color: #gray, 0) + 0Phi_3 + 60c_3 = 18$, [60],
  ),

  $k=2$,
  table(
    columns: 5,
    [], [0c], [50], [110], $min$,
    [0b],
    $mark(color: #gray, 55) + 1Phi_2 + 0c_2 = 85$,
    $mark(color: #gray, 52) + 1Phi_2 + 50c_2 = 102$,
    $mark(color: #gray, 18) + 2Phi_2 + 110c_2 = 122$,
    [0c],

    [40], $mark(color: #gray, 55) + 0Phi_2 + 0c_2 = 55$, [], [], [0c],
    [90], [], $mark(color: #gray, 52) + 0Phi_2 + 50c_2 = 72$, [], [50],
    [150], [], [], $mark(color: #gray, 18) + 0Phi_2 + 110c_2 = 62$, [110],
  ),

  $k=1$,
  table(
    columns: 6,
    [], [0b], [40], [90], [150], $min$,
    [0a],
    $mark(color: #gray, 85) + 1Phi_1 + 0c_1 = 110$,
    $mark(color: #gray, 55) + 2Phi_1 + 40c_1 = 125$,
    $mark(color: #gray, 72) + 3Phi_1 + 90c_1 = 192$,
    $mark(color: #gray, 62) + 4Phi_1 + 150c_1 = 237$,
    [0b],
  ),
)

Der Optimale Pfad ist

$
  "0a" -> "0b" -> "0c" -> "0d" -> "0e"
$

#align(end)[2026-07-05]

= Graphen

== Kürzeste Wege

$
  min F(x) = sum_((i, j) in E) c_(i j) x_(i j) \
$

Unter NB

$
  sum_j x_(i j) - sum_j x_(j i) = cases(
    1 & "wenn" i=s,
    -1 & "wenn" i=t,
    0 & "sonst"
  )
$

Siehe practice/OR/ue06.

== Maximum Flow

$
  G = (V, E, c)
$

$
  c = (c_(i j) mid(|) "Flusskapazität von" i "nach" j) \
  x = (x_(i j) mid(|) "Fluss von" i "nach" j)
$

$
  max sum_{j mid(|) (s, j) in E} x_(s j)
$

Unter NB

$
  sum_j x_(i j) - sum_j x_(j i) = cases(
    F(x) & "wenn" i=s,
    -F(x) & "wenn" i=t,
    =0 & "sonst"
  )
$

und

$
  0 <= x_(i j) <= c_(i j)
$

== Chinese Postman

#further(width: 50%)[
  #link("https://www.youtube.com/watch?v=EsECAdYGA1w")[Chinese Postman Problem]
]

Ungerade Knoten: A, C, E, G

Paare:

#table(
  columns: 3,
  [GE], [CA], [],
  [8], [9], [17],
  [GC], [EA], [],
  [11], [5], [*16*],
  [GA], [CE], [],
  [13], [7], [20],
)

#align(end)[2026-05-16]

= Graphen

== Travelling Salesman Problem (TSP)

=== Spiel

--

=== Distanzmatrix

Siehe OR/ue07.

=== Subtour Elimination Constraint

$
  abs(V)-1
$

bzw

$
  abs(V) + 1
$

=== TSP als LP

Minimiere die Summe der Kantengewichte $c$, indem Kanten $i j$ gewählt werden ($x$ ist boolean)

$
  min sum_j sum_i c_(i j) x_(i j)
$

Unter der Nebenbedingung, dass alle Knoten in einem geschlossenen Kreis besucht werden.

$
  forall j: sum_i x_(i j) = 1 quad quad
  forall i: sum_j x_(j i) = 1 \
  forall S subset.neq V: abs(E(S)) <= abs(S) - 1
$

=== Mengenlehre

+ $
    abs(V) = 127 => abs(E) = 127
  $
+ $
    abs(cal(P)(V)) = 2^abs(V) = 2^127 = 128 "Gi"
  $

== Vehicle Routing Problem (VRP)

+ TSP
+ $
    E = {(i, j) mid(|) i = t or j = t; i != j}
  $

== Savings-Algorithmus für VRP

Auf Papier.

= Maschinenbelegung und Spieltheorie

== Johnson

=== Optimale Auftragsfolge

Erster und letzter Auftrag:

$
  min_(a in A) a.M_1 = A_2 \
  min_(a in A) a.M_2 = A_1
$

Gruppen:

$
  A_(M_1<=M_2) = (
    A_2, A_4
  ) \
  A_(M_1>M_2) = (
    A_3, A_5, A_1
  )
$

Gantt:

#timeliney.timeline(show-grid: true, {
  import timeliney: *
  let n = 30
  headerline(
    ..range(1, n, step: 2).map(it => (str(it), 2)),
  )

  taskgroup(title: $bold(M_2)$, {
    task($A_1$, (from: 28, to: 30), ..s(1))
    task($A_2$, (from: 1, to: 7), ..s(2))
    task($A_3$, (from: 15, to: 22), ..s(3))
    task($A_4$, (from: 7, to: 15), ..s(4))
    task($A_5$, (from: 23, to: 27), ..s(5))
  })

  taskgroup(title: $bold(M_1)$, {
    task($A_1$, (from: 23, to: 28), ..s(1))
    task($A_2$, (from: 0, to: 1), ..s(2))
    task($A_3$, (from: 4, to: 13), ..s(3))
    task($A_4$, (from: 1, to: 4), ..s(4))
    task($A_5$, (from: 13, to: 23), ..s(5))
  })
})

- Zykluszeit: 30
- Leerzeiten: $M_1=2$, $M_2=3$

=== Durchlaufzeiten

$
  A_1=7 \
  A_2=14 \
  A_3=18 \
  A_4=14 \
  A_5=7
$

== Akers

=== Minimale Zykluszeit

#cetz.canvas({
  import cetz-plot: *
  import cetz.draw: *

  plot.plot(
    size: (8, 8),
    x-label: $A_1$,
    y-label: $A_2$,
    x-min: 0,
    x-max: 14,
    y-min: 0,
    y-max: 15,
    x-grid: "minor",
    y-grid: "minor",
    x-tick-step: none,
    x-minor-tick-step: 1,
    x-ticks: (
      (3, $M_1$),
      (7, $M_2$),
      (9, $M_3$),
      (14, $M_4$),
    ),
    y-tick-step: none,
    y-minor-tick-step: 1,
    y-ticks: (
      (3, $M_4$),
      (6, $M_2$),
      (9, $M_1$),
      (15, $M_3$),
    ),
    {
      plot.add(((0, 0),))

      plot.annotate({
        set-style(stroke: none, fill: colors.primary.transparent)
        rect((9, 0), (14, 3))
        rect((3, 3), (7, 6))
        rect((0, 6), (3, 9))
        rect((7, 9), (9, 15))

        group({
          set-style(
            stroke: (
              thickness: 8pt,
              paint: colors.secondary.normal,
            ),
            fill: none,
          )
          line((0, 0), (3, 3))
          group({
            set-style(stroke: 4pt)
            line((3, 3), (7, 3), (14, 10), (14, 15))
            line((3, 3), (3, 6), (6, 9), (7, 9))
            group({
              set-style(stroke: 2pt)
              line((7, 9), (9, 9), (14, 14), (14, 15))
              line((7, 9), (7, 15), (14, 15))
            })
          })
        })
      })
    },
  )
})

- 23
- *18*
- 19

=== Gantt Auftragsbezogen

#timeliney.timeline(show-grid: true, {
  import timeliney: *
  import cetz.draw: *

  headerline(..range(1, 20, step: 2).map(it => (str(it), 2)))

  taskgroup(title: $bold(A_1)$, {
    task($M_4$, ..s(4), (from: 12, to: 17))
    task($M_3$, ..s(3), (from: 10, to: 12))
    task($M_2$, ..s(2), (from: 6, to: 10))
    task($M_1$, ..s(1), (from: 0, to: 3))
  })

  taskgroup(title: $bold(A_2)$, {
    task($M_4$, ..s(4), (from: 0, to: 3))
    task($M_3$, ..s(3), (from: 12, to: 18))
    task($M_2$, ..s(2), (from: 3, to: 6))
    task($M_1$, ..s(1), (from: 6, to: 9))
  })
})

Wartezeiten:

- $A_1=4$
- $A_2=3$

=== Gantt Maschinenbezogen

#timeliney.timeline(show-grid: true, {
  import timeliney: *
  import cetz.draw: *

  headerline(..range(1, 20, step: 2).map(it => (str(it), 2)))

  taskgroup(title: $bold(M_1)$, {
    task($A_1$, ..s(1), (from: 0, to: 3))
    task($A_2$, ..s(1), (from: 6, to: 9))
  })

  taskgroup(title: $bold(M_2)$, {
    task($A_1$, ..s(2), (from: 6, to: 10))
    task($A_2$, ..s(2), (from: 3, to: 6))
  })
  taskgroup(title: $bold(M_3)$, {
    task($A_1$, ..s(3), (from: 10, to: 12))
    task($A_2$, ..s(3), (from: 12, to: 18))
  })
  taskgroup(title: $bold(M_4)$, {
    task($A_1$, ..s(4), (from: 12, to: 17))
    task($A_2$, ..s(4), (from: 0, to: 3))
  })
})

== Stein-Schere-Papier

=== Spielwert

Einzelner Strategien:

$
  V_(Z,1) = -1 \
  V_(Z,2) = -1 \
  V_(Z,3) = -1 \
  V_(S,1) = 1 \
  V_(S,2) = 1 \
  V_(S,3) = 1
$

Gesamtspielwert:

$
  V_Z & = max_i min_j m_(i j) \
      & = -1 \
  V_S & = min_j max_i m_(i j) \
      & = 1
$

=== LP

$
  1="Stein" \
  2="Schere" \
  3="Papier"
$

$
  max F(p_1, p_2, p_3, z) = z
$

Unter NB

$
  m_(1 1) p_1 + m_(2 1) p_2 + m_(3 1) p_3 = p_3-p_2 & >= z \
    m_(1 2) p_1 + m_(2 2) p_2 + m_(3 2) p_3=p_3-p_1 & >= z \
    m_(1 3) p_1 + m_(2 3) p_2 + m_(3 3) p_3=p_2-p_1 & >= z \
                                          sum_i p_i & = 1 \
                                                p_i & >= 0 \
                                                  z & in RR
$

=== Solver

Siehe OR/ue08/ue03.

=== Optimale Gemischte Strategie

Weil es ein symmetrisches, faires Spiel ist.

=== Bedingung

$M^T=-M$

== Stein-Schere-Papier-Brunnen

=== Lineare Optimierung

Siehe OR/ue08/ue03.

=== Stein

Weil Brunnen alles kann was Stein kann und noch mehr.

#align(end)[2026-06-09]

= Genetische Verfahren

== Investplanung

=== Übersicht

=== Chromosomen

Problemmenge: $x = {x_1, ..., x_10}$

Population: Potenzmenge der Projekte

$ cal(P)(x) = {x' subset.eq x} $

Beispiele für Individuen: ${x_1}, {x_1, x_2}$

Es gibt $abs(cal(P)(x)) = 2^abs(x) = 2^10 = 1024$ Individuen.

=== Fitness

$
  f : x' subset.eq x |-> - "sgn"((sum "Investition"(x_i))/(35 dot 10^6)-1) dot sum_(x_i in x') "Gewinn"(x_i)
$

Beispiele:

$
  f({x_1}) = 0.5 dot 10^6 \
  f({x_1, x_2}) = (0.5 + 0.8) dot 10^6
$

=== Selektion

*Einfache Selektion*

Jedem Individuum wird eine Überlebenswahrscheinlichkeit zugewiesen.

$
  p^i = f(x^i)/(sum_j f(x^j))
$

Wiederholt ein Individuum ziehen und überleben lassen.

*Rank Selection*

Die Wahrscheinlichkeit ist für jedes Individuum

$
  p^i = r/(sum i)
$

wobei $r$ der Rank ist, also $n$ für das Individuum $i$ mit höchstem Zielwert $f(x^i)$, $n-1$ für das zweitbeste, etc.

=== Crossover

*Single Point Crossover*

Beispiel für ${x_1}, {x_1, x_2}$:

Codieren wir die Individuen $x^i$ als 10-Bit-Folge $x$, wobei $x_i=1 <=> x_i in x^i$.

#table(
  columns: 2,
  [Phänotyp (Decodiert)], [Genotyp (Encodiert)],
  ${x_1}$, `1000000000`,
  ${x_1, x_2}$, `1100000000`,
)

Wählen wir den Kreuzungspunkt $z=5$. Dann ist das Resultat

$
  overbrace(10000, {x_1}) underbrace(00000, {x_1, x_2})
$

=== Mutation

Ein Gen ist ein Bit. Wenn $p=0.3$, Dann ist für ein Individuum (10 Bit) $p=1-(1-0.3)^10$. Dann ist für 10 Individuen die Anzahl an Mutationen $E(X)=100 dot 0.3 = 30$.

=== Abbruchkriterium

$
  (f(x^i) >= max_(x' in cal(P)(x)) sum_(x_i in x') x_i)
  or
  ?
$

== Vierfarbenproblem

=== Kodierung

Es gibt vier Farben $C = {r, g, b, y}$. Ein Individuum ist ein $b in C$. Es gibt 16 Individuen im Chromosom $B = (b_1, ..., b_16)$.

=== Fitnessfunktion

$
  f(B) = sum_((b_i, b_j) in B^2) b_i, b_j "benachbart" and b_i = b_j
$

=== Individuen

$
  B_1 = [r, r, g, y, r, y, y, b, y, g, r, r, y, b, b, b] \
  B_2 = [y, g, r, b, r, b, g, y, r, y, g, r, r, r, g, g] \
  B_3 = [r, y, r, g, r, b, r, r, g, b, y, b, y, b, g, b] \
  B_4 = [b, y, b, b, g, b, g, r, b, r, b, b, y, b, y, r]
$

=== Selektion

Einfache Selektion:

$
  p^i(B) = (f(B))/(sum_(B') f(B'))
$

=== Crossover

Single point crossover:

$
  (B_1, B_2) stretch(|->)^(z=7) [r, r, g, y, r, y, y, y, r, y, g, r, r, r, g, g] \
  (B_3, B_4) stretch(|->)^(z=1) [r, y, b, b, g, b, g, r, b, r, b, b, y, b, y, r]
$
