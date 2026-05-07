#import "/components.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3"

#align(end)[2026-03-19 VL01]

= Organisatorisches

= Begriffe

- _Entscheidung_
  - Bsp: Optimale Lagerbestände
- _Entscheidungskriterien_
  - Bsp: Mindestbestände $<= x <=$ Lagerkapazität,
- _Ziele_
  - Bsp: Bestände minimal halten
- _Optimale Entscheidung_: $max F(x)$ oder $min F(x)$

== Beispiel Sneaker & Stiefel

$
  x & := "Menge" \
  g & := "Gewinn"
$

#grid(
  columns: 2 * (1fr,),
  $
    P_1 & := "Sneaker" \
    x_1 & = space ? \
    g_1 & = 10 euro \
  $,
  $
    P_2 & := "Stiefel" \
    x_2 & = space ? \
    g_2 & = 20 euro \
  $,
)

Zielfunktion

$
  F(x_1, x_2) & := 10 x_1 + 20 x_2
$

Nebenbedingungen

$
    x_1 + x_2 & <= 100 \
  6x_1 + 9x_2 & <= 720 \
     x_1, x_2 & >= 0
$

== Lineares Optimierungsmodell (LP)

=== Umformungen

- $min -> max$ durch $dot (-1)$
- $x_j >= 0$ durch $x_j = x_j^' - x_j^('')$
- Schlupfvariable

=== Normalform

Nur noch "$=$"-Nebenbedingungen durch Schlupfvariablen

- $p$ Entscheidungsvariablen
- $m$ Nebenbedingungen

Maximiere

$
  F vec(x_1, ..., x_p, x_(p+1), ..., x_n) = sum_(j=1)^p c_j x_j + sum_(j=p+1)^n 0 dot x_j
$


#note(title: [Symbole])[
  - Entscheidungsvektor $x$ (beinhaltet Schlupfvariablen)
  - Zielfunktionsvektor $c$ (z.B. Gewinn, Zeit)
]

#align(end)[2026-03-26 VL02]

= LP Graphische Lösung

#cetz.canvas({
  import cetz-plot: *
  import cetz.draw: *

  let nb1 = x => 100 - x
  let nb2 = x => 80 - (2 / 3) * x
  let nb3 = x => 60
  let nb4 = x => 0

  plot.plot(
    size: (10, 5),
    x-label: $x_1$,
    y-label: $x_2$,
    {
      plot.add(
        domain: (0, 100),
        nb1,
        label: $x_1+x_2<=100$,
      )
      plot.add(
        domain: (0, 120),
        nb2,
        label: $6x_1+9x_2<=720$,
      )
      plot.add(
        domain: (0, 150),
        nb3,
        label: $x_2<=60$,
      )
      plot.add(
        domain: (0, 150),
        nb4,
        label: $x > 0$,
      )
      plot.add(
        domain: (0, 40),
        x => 20 - .5 * x,
        label: $400 = 10 x_1 + 20x_2$,
        style: (
          stroke: (
            thickness: 2pt,
            dash: "dashed",
            paint: black,
          ),
        ),
      )
      plot.add(
        domain: (0, 120),
        x => 60 - .5 * x,
        label: $1200 = 10 x_1 + 20 x_2$,
        style: (
          stroke: (
            thickness: 2pt,
            dash: "dashed",
            paint: black.transparentize(50%),
          ),
        ),
      )
      plot.add(
        domain: (0, 150),
        x => 75 - .5 * x,
        label: $1500 = 10 x_1 + 20 x_2$,
        style: (
          stroke: (
            thickness: 2pt,
            dash: "dashed",
            paint: black.transparentize(75%),
          ),
        ),
      )
      plot.add-fill-between(
        domain: (0, 100),
        x => calc.min(
          nb1(x),
          nb2(x),
          nb3(x),
        ),
        nb4,
        label: $Z$,
      )
    },
  )
})

$
  F(x_1, x_2) = 10x_1+20x_2
$

= Simplex-Algorithmus

- $n$ Variablen, davon $n-m$ Strukturvariablen und $m$ Schlupfvariablen
- Unterste Zeile: F-Zeile: Negierte Zielfunktionskoeffizienten

#example(title: [Simplex anhand Stiefel-Sneaker])[
  #set enum(start: 0)
  + Erste $n-m=2$ Variablen auf 0 setzen
    - $b_i>=0=>"Zulässig"$
    - $c_i<0=>"Nicht Optimal"$
  + Pivotspalte: Kleinstes $c$ in F-Zeile
  + $x_2$ (Pivotspalte) mit $x_5$ (Pivotzeile) tauschen
  + Elementare Zeilenumformungen
]

#align(end)[2026-04-09 VL03]

Eine Basislösung ist ein Schnittpunkt von $n-m$ Nebenbedingungsgeraden. Es gibt $binom(n, n-m)$ Basislösungen

== Dualität

- Primales Optimierungsproblem $cal(O)$
- Duales Optimierungsproblem $cal(D O)$

#table(
  columns: 3,
  table.header([], [Primal], [Dual]),
  $n$, [Variablen $x$], [?],
  $m$, [Schlupfvariablen $x$], [?],
  $n-m$, [Strukturvariablen $x$], [?],
)

#table(columns: 3)[

][Primal][Dual][][$max F(x)$][$min "FD"(w)$][
  n
][NB][Variablen $w$][
  m
][Variablen $x$][NB]


$
  F(x) = "FD"(w)
$

wenn optimal $=>$ man kann FD verwenden, um F zu optimieren.

== Duales Simplex

+ Pivotzeile mit kleinstem $b$ wählen
+ Pivotspalte mit größtem $r=c/a$ wählen
+ Primales Problem überführen
+ Zulässig wenn alle $b >= 0$
+ Optimal wenn alle $x >= 0$ in F-Zeile

#align(end)[2026-04-17 VL04]

= Integer Linear Programming

== Definition

- _LP:_ Stetig
- _ILP:_ Diskrete Variablen
- _MILP:_ Teilweise diskrete Variablen
- _Relaxation:_ ILP auf LP zurückführen

== Rounding Cuts

Kleinergleich-Bedingungen abrunden.

$
  "Ausdruck" <= b -> "Ausdruck" <= floor(b)
$

== GGT Cuts

Bedingung durch größten gemeinsamen Teiler teilen.

$
                              & a_1 x_1 + a_2 x_2     && >= b \
  stretch(<=>)^(div gcd(a_i)) & a_1^' x_1 + a_2^' x_2 && <= b/gcd(a_i)
$

== Branch & Bound

#align(end)[2026-04-23 VL05]

= Dynamische Optimierung

DAG, Knoten sind Zustände, Übergänge sind Entscheidungen.

- Zustandsvariable $z_k$: Knoten im Schritt $k$.
- Problemvariable $x_k$: Optimale Entscheidung in Schritt $k$.

_Stufenbezogene Entscheidungsfunktion:_ Gibt für eine Entscheidung $x$ vom Zustand $z$ den (zu maximierenden) Zielfunktionswert aus.

$
  f_k (z_(k-1), x_k) -> "Zielfunktionswert"
$

_Transformationsfunktion:_ Gibt für eine Entscheidung $x$ vom Zustand $z_(k-1)$ den neuen Zustand $z_k$ aus.

$
  t_k (z_(k-1), x_k) -> z_k
$

== Postkutschenproblem

=== Entscheidungsfunktionswerte in Tabelle aufnehmen

#table(
  columns: 2,
  align: horizon,
  [], [Stufe $k$],
  rotate(-90deg, reflow: true)[Stufe $k-1$], $f(z_(k-1), x_k)$,
)

=== Rückwärtsinduktion

_Stufenbezogene Zielfunktion_

Von $Z$ zu $A$: In jeder Stufe wird für jeden Zustand der optimale Pfad zu $Z$ bestimmt, indem die unmittelbaren Kosten auf die bisher akkumulierten Kosten addiert werden.

$
  min f_k + min sum_(k<i<=n) f_i
$

#align(end)[2026-04-30 VL06]

= Graphentheorie

== Minimale Kantenüberdeckung

Ziel: Minimale Anzahl Anzahl Kanten, sodass jeder Knoten mind. eine Kante hat.

#note(title: [Formulierung als LP])[
  $
    min sum_({i, j} in E) x_(i j) quad quad
    "Unter NB" quad quad
    sum_(j in V) x_(i j) >= 1 space forall i in V
  $
]

== Kürzeste Wege

#note(title: [Formulierung als NP])[
  $
    min sum_((i, j) in E) c_(i j) x_(i j) quad quad
    "Unter NB" quad quad
    sum_(j) x_(i j) - sum_(j) x_(j i) = 0 space forall i in V
  $
]

== Chinese Postman

Ziel: Kürzester Zyklus, bei dem jede Kante traversiert wird.

Eulerkreis nur möglich, wenn alle Knotengrade gerade sind.

#align(end)[2026-05-07 VL07]

== Traveling Salesman (TSP)

#further(width: 50%)[
  #link("https://www.youtube.com/watch?v=RQpFffcI-ZI")[Nearest Neighbor Method]
]

Sukzessiver Einbau

== Vehicle Routing Problem

*NB1 & NB2:* Zu jedem Kunden führt genau eine Route hin und weg.

$
  sum_i x_(i j) = 1 quad quad
  sum_j x_(i j) = 1
$

*NB3 & NB4:* Im Depot t enden und starten genau K Routen.

$
  sum_i x_(i t) = k quad quad
  sum_j x_(t j) = k
$

*NB5:* Die Touren sind zusammenhängend

$
  forall S subset.eq V \\ {t}: quad
  sum_(i in.not S) sum_(j in S) x_(i j) >= 1
$

In jede Knotenmenge muss mind. eine eingehende und eine ausgehende Kante sein.

*NB6:* Ganzzahligkeit der Variablen

$
  x_(i j) in {0, 1}
$
