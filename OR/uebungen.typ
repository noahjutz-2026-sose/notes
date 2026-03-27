#import "@preview/cetz-plot:0.1.3"
#import "/deps.typ": cetz, cetz-plot, gentle-clues, mannot
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
3 x_1 + 5 x_2 + x_3 &= 180 "(Vormontage)" \
3 x_1 + 3 x_2 + x_4 &= 135 "(Endmontage)"
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
        F(x_1, x_2) &= 4x_1 + 3x_2 \
        stretch(<=>)^(F=20) x_2 &= (20-4x)/3 \
        stretch(<=>)^(F=10) x_2 &= (10-4x)/3
    $
][NB1][
    $
        x_1 + 3 x_2 &<= 9 \
        <=> x_2 &<= 3-x_1/3
    $
][NB2][
    $
        -x_1 + 2x_2 &<= 2 \
        <=> x_2 <= 1+x_1/2
    $
][NB3][
    $ x_1 >= 0 $
][NB4][
    $ x_2 >= 0 $
]

== Graphische Lösung

=== Optimum

#cetz.canvas({
    import cetz-plot: *
    import cetz.draw: *

    let nb1 = x => 3 - x/3
    let nb2 = x => 1 + x/2
    let nb3 = x => 0

    let f20 = x => (20-4*x)/3
    let f10 = x => (10-4*x)/3

    let f_opt = x => 81/15 - 4/3 * x

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
                "NB3": nb3
            ).pairs() {
                plot.add(
                    domain: (0, 10),
                    f,
                    style: (stroke: (
                        paint: black.lighten(85%),
                        dash: "dashed"
                    )),
                    label: label
                )
            }
            plot.add-vline(
                0,
                style: (stroke: (
                    paint: black.lighten(85%),
                    dash: "dashed"
                )),
                label: "NB4"
            )

            plot.add-fill-between(
                domain: (0, 9),
                x => calc.min(
                    nb1(x),
                    nb2(x),
                ),
                nb3,
                style: (stroke: none),
                label: $Z$
            )

            for (label, f) in (
                ($F=20$, f20),
                ($F=10$, f10),
                ($F=81 slash 5$, f_opt)
            ) {
                plot.add(
                    domain: (0, 10),
                    f,
                    label: label
                )
            }

            plot.add(
                ((12/5, 11/5),),
                label: $"NB1"inter"NB2"$,
                mark: "triangle",
                style: (stroke: none),
                mark-style: (plot.default-mark-style(0))
            )
            plot.add(
                ((9, 0),),
                label: $"NB1"inter"NB3"$,
                mark: "square",
                style: (stroke: none),
                mark-style: (plot.default-mark-style(0))
            )
            plot.add(
                ((0, 1),),
                label: $"NB2"inter"NB4"$,
                mark: "o",
                style: (stroke: none),
                mark-style: (plot.default-mark-style(0))
            )
        }
    )
})

*Eckpunkte*

#table(columns: 3)[][$ x_1 $][$ x_2 $][$ "NB1"="NB2" $][
    $
        3-x_1/3 &= 1+x_1/2 \
        x_1/2+x_1/3 &= 2 \
        5/6 x_1 &= 2 \
        x_1 &= 12/5
    $
][
    $
        3-(12/5)/3 = 11/5
    $
][$ "NB1" = "NB3" $][
    $
        3-x_1/3 &= 0 \
        x_1 &= 9
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
    F(mark(triangle.small, color: #blue))
    &= F(12/5, 11/5) = 16.2 \

    F(mark(square.small, color: #blue))
    &= F(0, 9) = 45 \

    F(mark(circle.small, color: #blue))
    &= F(0, 1) = 3
$

#box(fill: green.transparentize(50%), inset: 4pt)[
    $
        max_(x_1, x_2) F(x_1, x_2) = F(0, 9) = 45
    $
]

=== Normalform in Summenform

$
    x_1 + 3x_2 + x_3 &= 9 \
    -x_1 + 2x_2 + x_4 &= 2 \
    x_1 + x_5 &= 0 \
    x_2 + x_6 &= 0 \
$

=== Normalform in Matrixform

$
    A = mat(
        1,  3, 1, 0, 0, 0;
        -1, 2, 0, 1, 0, 0;
        1,  0, 0, 0, 1, 0;
        0,  1, 0, 0, 0, 1;
    ) quad quad

    c = vec(4, 3) quad quad

    b = vec(9, 2, 0, 0)
$

== Simplex

#table(columns: (1fr,) * 2)[$
    mat(
        , x_1, x_2, x_3, x_4, x_5, x_6;
        x_3, a_(1 1), a_(1 2), a_(1 3), a_(1 4), a_(1 5), a_(1 6), b_1, r_1;
        x_4, a_(2 1), a_(2 2), a_(2 3), a_(2 4), a_(2 5), a_(2 6), b_2, r_2;
        x_5, a_(3 1), a_(3 2), a_(3 3), a_(3 4), a_(3 5), a_(3 6), b_3, r_3;
        x_6, a_(4 1), a_(4 2), a_(4 3), a_(4 4), a_(4 5), a_(4 6), b_4, r_4;
        , -c_1, -c_2, 0, 0, 0, 0
    )
$][$
    r_i := b_i/a_(i j) "mit Pivot-Spalte" j
$][$
    mat(
        , x_1, x_2, x_3, x_4, x_5, x_6;
        x_3, markhl(1), 3, 1, 0, 0, 0, 9, 9;
        x_4, -1, 2, 0, 1, 0, 0, 2, -2;
        x_5, 1, 0, 0, 0, 1, 0, 0, 0;
        x_6, 0, 1, 0, 0, 0, 1, 0, 0;
        , -4, -3, 0, 0, 0, 0
    )
$][][$
    mat(
        , x_1, x_2, x_3, x_4, x_5, x_6;
        x_1, 1, 3, 1, 0, 0, 0, 9, ;
        x_4, 0, 5, 1, 1, 0, 0, 11, ;
        x_5, 0, -1, -1, 0, 1, 0, -9, ;
        x_6, 0, 1, 0, 0, 0, 1, 0, ;
        , 0, 9, 4, 0, 0, 0, 36
    )
$][
    - $R_2 -> R_2 + 1 dot R_1$
    - $R_3 -> R_3 - 1 dot R_1$
    - $R_5 -> R_5 + 4 dot R_1$
]
