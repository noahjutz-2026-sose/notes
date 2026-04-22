#import "/components.typ": *
#import "/deps.typ": mannot
#import "components/ieee754.typ"
#import mannot: *

= Fehler und Kondition

== Mathematik-Grundlagen

*Lineare Algebra (MA1)*
- _Vektor_ $arrow(v) = (v_1, ..., v_n)^T$
  - _Ortsvektor_ und _Richtungsvektor_
  - Vektoren sind _linear unabhängig_, wenn man sie nicht durch Linearkombination ineinander umwandeln kann
  - _Linearkombination_: Zusammenaddieren und Skalieren: $arrow(w) = sum lambda_i arrow(v)_i$
  - Ein _Lineaerer Unterraum_ eines _Vektorraums_ $V = RR^n$ ist eine abgeschlossene Teilmenge $U subset.eq RR^n$ mit $dim(U) = m$ mit $0<=m<=n$. z.B. eine Ebene in $RR^3$, die durch $arrow(0)$ geht.
  - Eine Menge an Basisvektoren $M = (v_1, ..., v_n)$ können einen Unterraum aufspannen. Man sagt $U = "span"(M)$.
- _Matrixmultiplikation_ $A dot B$
  - Spalten von $A$ muss gleich Zeilen von $B$ sein
  - $A$ nach rechts, $B$ nach unten
- _Lineares Gleichungssystem_
  - Heißt konsistent, wenn $exists$ Lösung
  - #table(columns: 2)[Lineares Gleichungssystem][Erweiterte Koeffizientenmatrix][
      $
        a_(1 1) x_1 + a_(1 2) x_2 = b_1 \
        a_(2 1) x_1 + a_(2 2) x_2 = b_2
      $
    ][
      $
        mat(
          augment: #(-1),
          a_(1 1), a_(1 2), b_1;
          a_(2 1), a_(2 2), b_2;
        )
      $
    ]
  - _Zeilenumformungen_: Ersetzen, Vertauschen, Skalieren
  - #table(columns: 2)[Zeilenstufenform][Reduzierte Zeilenstufenform][
      $
        mat(2, -4, 3, 1; 0, 0, 5, -2; 0, 0, 0, -3; 0, 0, 0, 0)
      $
    ][
      $
        mat(1, 4, 0, -7; 0, 0, 1, 3; 0, 0, 0, 0; 0, 0, 0, 0)
      $
    ]


*Analysis (MA2)*
- _Stetige Funktion_: Funktion, die nicht "springt"
- _Differenzierbare Funktion_: Funktion, die keinen Knick hat

== Höhenmessgenauigkeit

=== Eingabe- und Ausgabefehler

Nach $x=2 "s"$ ist der absolute Messfehler der Stoppuhr $Delta_x = 0.01 "s"$. Gesucht ist der absolute Ausgabefehler $Delta_y$.

$
  Delta_y & =^dot kappa_"abs" (x) dot Delta_x \
          & = abs(g dot x) dot Delta_x \
          & = abs(10 dot 2) dot 0.01 \
          & = 0.2
$

#box(fill: green.transparentize(50%), inset: 4pt)[
  Wir müssen mit einem Ausgabefehler von $0.2 "m"$ rechnen.
]

#alternative[
  Wenn wir von einem Messwert $tilde(x) = 2.01$ ausgehen.
  $
    Delta_y & = abs(f(tilde(x))-f(x)) \
            & = abs(h(2.01) - h(2)) \
            & = abs((1/2 dot 10 dot 2.01^2) - (1/2 dot 10 dot 2^2)) \
            & = abs(20.2005-20) \
            & = 0.2005
  $
  Der Ausgabefehler ist exakt $0.2005 "m"$.
]

=== Gegeben Ausgabefehler Zeit maximieren

#table(
  columns: 2,
  [Allgemein], [Dieses Problem],
  $y = f(x)$, $y = h(t)$,
)

Wir gehen wieder davon aus, dass $forall t : Delta_t = 0.01$.

Gesucht sind alle Eingabewerte $t$, für die der Ausgabefehler kleiner als $1 "m"$ ist.

$
                      Delta_y & < 1 \
  kappa_"abs" (t) dot Delta_t & < 1 \
            abs(g t) dot 0.01 & < 1 \
                     abs(g t) & < 100 \
                          g t & < 100 \
                            t & < 100 / g \
                            t & < 100 / 10 \
                            t & < 10
$

#box(fill: green.transparentize(50%), inset: 4pt)[
  Unter $t=10 "s"$ bleibt der Ausgabefehler $h < 1 "m"$.
]

#alternative[
  Wenn wir davon ausgehen, dass der Messfehler $Delta_t$ der Stoppuhr proportional zur Zeit $t$ steigt.

  $
    Delta_t = 0.01 dot t/2
  $

  Gesucht sind alle Eingabewerte $t$, für die der Ausgabefehler kleiner als $1 "m"$ ist.

  $
                        Delta_y & < 1 \
    kappa_"abs" (h) dot Delta_t & < 1 \
    abs(g t) dot (0.01 dot t/2) & < 1 #text(gray)[$space g t$ ist nie negativ] \
                    0.005 g t^2 & < 1 \
                              t & < sqrt(200/g) \
                              t & < sqrt(200/10) \
                              t & < sqrt(20) "s"
  $
]

=== Gegeben Ausgabefehler Messfehler maximieren

- Gegeben: $delta_y <= 5%$ und Problem $h(t)$
- Gesucht: $delta_t$

$
      delta_y & =^dot kappa_"rel" (t) dot delta_t \
  <=> delta_t & = delta_y/(kappa_"rel" (t)) \
              & = (5%)/2 \
              & = 2.5%
$

#box(fill: green.transparentize(50%), inset: 4pt)[
  Der Eingabefehler darf maximal $2.5%$ sein, sodass der Ausgabefehler $5%$ ist.
]

== Schlecht konditionierte Abbildungen

Siehe Skript-Aufgabe 1.4

#task(title: [Zusatzaufgabe])[
  $
    f(x) = cases(
      -1 "für" x <= 1,
      1 "für" x > 1
    )
  $

  Beweise, dass $k_"abs" (1) = infinity$.
]

#alternative[
  Ideen
  #table(
    columns: 4,
    table.header($ f(x) $, $ x $, $ kappa_"abs" (x) $, $ kappa_"rel" (x) $),
    table.hline(stroke: black),
    $ cases(0 "für" x <= 0, 1 "sonst") $, $ 0 $, $ infinity $, [nicht def.],
    $ sqrt(x) $, $ 0 $, [nicht def.], [nicht def.],
    $ sqrt(abs(x)) $, $ 0 $, [nicht def.], [nicht def.],
    $ 0 $, $ 0 $, $ 0 $, [nicht def.],
    $ x $, $ 0 $, $ 1 $, $ 1 $,
    $ 1/x $, $ 0 $, [nicht def.], [nicht def. oder 1?],
    $ x - 1 $, $ 1 $, $ 1 $, [nicht def. ($arrow infinity$)],
  )
]


== Kondition differenzierbarer Funktionen

Siehe Skript-Aufgabe 1.7

#align(end)[2026-04-14 TT02]

= Zahlendarstellung

== Fehleranalyse

Gegeben ist

$
  V(r) & = 4/3 pi r^3 quad quad
         delta_V <= 3%
$

Wir berechnen die relative Kondition

$
  kappa_V (r) & = (r 12/3 pi r^2) / (4/3 pi r^3) \
              & = 12/4 = 3
$

und setzen sie ein

$
  delta_V & <= kappa_V (r) dot delta_r \
     0.03 & <= 3 dot delta_r \
     0.01 & <= delta_r
$

#box(fill: green.transparentize(50%), inset: 4pt)[
  Der Radius darf um höchstens $delta_r = 1%$ abweichen, sodass das Volumen um höchstens $delta_V = 3%$ abweicht.
]

== b-adische Darstellung

#table(
  columns: 4,
  table.header($n$, $b=2$, $b=8$, $b=16$),
  `123`, `1111011`, `173`, `7B`,
  `97`, `1100001`, `141`, `61`,
)

== 2er Komplement

#table(
  columns: 3,
  table.header($n$, [8 Bit], [16 Bit]),
  `-123`, `10000101`, `1111111110000101`,
  `-97`, `10011111`, `1111111110011111`,
)

#align(end)[2026-04-22 TT03]

= Gleitkommazahlen

== IEEE 754

=== x1

$
  x_1 & = 135 \
      & = 10000111_2 \
      & = 1.underbrace(0000111, "Mantissa" f) space_2 dot 2^mark(7, tag: #<7>)
        annot(#<7>, "Exponent" e, dy: #{ -30pt })
$

$
  c_1 = b + e_1 = 127 + 7 = 134 = 10000110_2 \
  s_1 = 0 \
$

#ieee754.single("0100001100000111")

=== x2

#grid(columns: 2, column-gutter: 16pt)[
  #table(
    columns: 2,
    $0.4375$, [],
    $0.875$, $0$,
    $1.75$, $1$,
    $1.5$, $1$,
    $1$, $1$,
  )
][
  $
    x_2 & = 0.4375 \
        & = 0.0111_2 \
        & = 1.11_2 dot 2^(-2) \
    c_1 & = 127 + (-2) = 125 = 1111101_2 \
    s_1 & = 0
  $
]

#ieee754.single("00111110111")

=== x3

$
  x_3 & = -5 + 2^(-24) \
      & = -(5 - 2^(-24)) \
      & = -(4 + (1 - 2^(-24))) \
      & = -(4 + sum_(i=2)^23 2^(-i)) \
      & = 10.11111111111111111111111_2 \
      & = 1.011111111111111111111111_2 dot 2^1 \
  e_3 & = 127 + 1 = 128 = 10000000_2 \
  s_3 & = 1
$

#ieee754.single("11000000011111111111111111111111")

=== x4

$
  x_4 & = 10.375 \
      & = 1010.011_2 \
      & = 1.010011_2 dot 2^3 \
  s_4 & = 0 \
  c_4 & = 127 + 3 = 130 = 10000010_2
$

#ieee754.single("010000010010011")

== Rundung
