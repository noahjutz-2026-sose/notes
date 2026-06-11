#import "/deps.typ": cetz, cetz-plot, codly, fletcher, gentle-clues, lq, mannot, meander, tiptoe
#import "/style.typ": *
#import gentle-clues: *
#import mannot: *
#import codly: codly
#import "/components/admonitions.typ": *
#import "components/sets.typ": math_set
#import "/components/utils.typ": bv, bva, dp, hl

#align(end)[2026-03-17 VL01]

= Organisatorisches

- Hausaufgaben: Freiwillige Abgabe Dienstag 11 Uhr ELO
- Übungen: Matlab

= Fehler und Kondition

== Eingabefehler

Wir messen einen Wert $x$, aber Aufgrund von Messfehlern erhalten wir einen ungenauen Wert $tilde(x)$.

#table(
  columns: 3,
  align: horizon,
  [Symbol], [Definition], [Name],
  $ Delta_x $, $ abs(tilde(x)-x) $, [Absoluter Fehler],
  $ delta_x $, $ Delta_x / abs(x) $, [Relativer Fehler],
)

#example[
  - Ein Elefant wiegt $w = 5 "T"$.
  - Unsere Waage liest $tilde(w) = 5.1 "T"$
  $
    => Delta_w = 0.1 "T" \
    => delta_w = 0.02 space mark((=2%), color: #gray)
  $
]

== Ausgabefehler

Wir wollen die gemessenen Rohdaten $tilde(x)$ mit einer Funktion $f : X -> Y$ auswerten (das _Problem_). Der Fehler kann nach der Auswertung größer oder kleiner sein.

#table(
  columns: 3,
  [Symbol], [Definition], [Name],
  $ Delta_y $, $ abs(f(tilde(x))-f(x)) $, [Absoluter Ausgabefehler],
  $ delta_y $, $ Delta_y / abs(f(x)) $, [Relativer Ausgabefehler],
)

#example[
  - Wir wollen wissen, was das Quadrat des Gewichts des Elefanten ist. $f(x) = x^2$
  - Tatsächlicher Wert: $ y = 5^2 = 25 "T" $
  - Fehlerhafter Wert: $ tilde(y) = 5.1^2 = 26.01 "T" $
  $
    => "Absoluter Ausgabefehler" Delta_y = 1.01 "T" \
    => "Relativer Ausgabefehler" delta_y = 0.0404
  $
]

== Relative Kondition <krel>

#further(width: 50%)[
  - #link("https://www.youtube.com/watch?v=a5oQktSURoE")[
      Floating Point Arithmetic
    ]
  - #link("https://gemini.google.com/share/9b4963171b5c")[Gemini]
]

Wie verändert sich der relative Fehler durch eine Auswertungsfunktion $f$? Das ist das Verhältnis des Ausgabefehlers zum Eingabefehler.

$
  "Relative Kondition" = delta_y / delta_x
$

Durch einsetzen und algebraisches Umstellen erhalten wir

#[
  $
    delta_y / delta_x & = ((f(tilde(x))-f(x))/f(x)) / ((tilde(x)-x)/x) \
                      & =(f(tilde(x))-f(x))/mark(f(x), tag: #<fx>) dot x/mark((tilde(x)-x), tag: #<x>) \
                      & =markhl((f(tilde(x))-f(x))/(tilde(x)-x), tag: #<sekante>, color: #green)
                        dot x/f(x)
                        #annot(<sekante>, dy: -90pt, dx: 200pt, leader-connect: "elbow")[
                          #set text(fill: black)
                          #cetz.canvas({
                            import cetz-plot: *
                            plot.plot(
                              size: (3, 3),
                              y-label: $f(x)$,
                              x-tick-step: none,
                              y-tick-step: none,
                              x-ticks: (5, 5.1),
                              y-ticks: (calc.pow(5, 2), calc.pow(5.1, 2)),
                              {
                                plot.add(
                                  domain: (4.8, 5.3),
                                  style: (stroke: (dash: "dashed", paint: gray, thickness: 3pt)),
                                  x => -25 + 10 * x,
                                  label: $"Tangente" f'(x)$,
                                )
                                plot.add(domain: (4.8, 5.3), x => calc.pow(x, 2), style: (stroke: blue), label: $f(x) = x^2$)
                                plot.add(((5, calc.pow(5, 2)), (5.1, calc.pow(5.1, 2))), mark: "o", label: "Sekante")
                              },
                            )
                          })
                        ]
  $

  #annot-cetz(
    (<fx>, <x>),
    cetz,
    {
      import cetz.draw: *
      set-style(
        mark: (start: "straight", end: "straight"),
        stroke: 1pt + gray,
      )
      line("fx", "x")
    },
  )
]

Der Verlauf von $f$ ist zwischen $tilde(x)$ und $x$ (Sekante) ist fast gleich der Tangente $f'(x)$. Das gilt für viele Funktionen bei kleinen Fehlern. Wir vereinfachen, indem wir den Fehler nach 0 konvergieren lassen:

$
  underbrace(
    lim_(tilde(x) -> x) (f(tilde(x))-f(x))/(tilde(x)-x),
    = f'(x)
  ) dot x/f(x)
$

Es entsteht ein Approximationsfehler, weil wir $f'(tilde(x))$ berechnen und nicht $f(tilde(x))$. Wir definieren ihn als

$
  g(tilde(x), x) in o(abs(tilde(x) - x))
$

Der Faktor, um den sich der relative Fehler also bei einer Funktion $f$ verschlimmert oder verbessert, ist also (ungefähr):

$
  kappa_"rel" (x) = abs((x dot f'(x))/f(x)) mark(+ space g(tilde(x), x), color: #gray)
$

Wir nennen diese Größe _Relative Kondition_ oder $kappa_"rel"$.

#example[
  Bei $f(x) = x^2$ ist die relative Kondition

  $
    kappa_"rel" (x) = abs((x dot 2x)/x^2) = 2
  $

  Der relative Fehler verdoppelt sich also.
]

#task(title: [Skript-Aufgabe 1.4])[
  *Absolute Kondition:*
  Um eine beliebig schlechte Kondition $kappa_"abs" (x_0) = infinity$ herbeizuführen, müssen wir eine Funktion finden, dessen Steigung an einem $x_0$ unendlich ist. Lösung:

  $
    f(x) = root(3, x) space , space x_0=0
  $

  $
    => f'(x_0) & = lim_(x->0) (f(x_0+x)-f(x_0))/x \
               & = lim_(x -> 0) ((x_0+x)^(1/3) - x_0^(1/3))/x \
               & = lim_(x -> 0) x^(1/3)/x
                 = lim_(x -> 0) x^(-2/3)
                 = lim_(x -> 0) 1/root(3, x^2) = infinity
  $

  $
    => kappa_"abs" (x_0) =^dot infinity
  $

  *Relative Kondition:* Wenn der Nenner von $kappa_"rel"$ gegen 0 geht

  $ lim_(x -> x_0) f(x)= 0 $

  aber der Zähler nicht, dann ist $kappa_"rel" (x_0) = infinity$. Lösung:

  $
    f(x) = x-1, x_0 = 1 \
  $

  $
    => kappa_"rel" (x_0) & = lim_(x -> x_0) abs(x/(x-1)) \
                         & = lim_(x -> 1) abs(x/(x-1)) = infinity
  $
]

== Absolute Kondition <kabs>

Herleitung analog zur relativen Kondition (@krel).

#[
  #show table.cell.where(x: 0): strong
  #show table.cell.where(y: 0): strong
  #table(
    columns: 3,
    [], [Relative Kondition], [Absolute Kondition],

    [Fragestellung],
    [Um wie viel % verstärkt sich der relative Fehler durch $f$?],
    [Um wie viel % verstärkt sich der absolute Fehler durch $f$?],

    [Definition],
    $
      kappa_"rel" (x) & = delta_y/delta_x \
                      & =^dot markhl(abs((x dot f'(x))/f(x)), color: #blue)
    $,
    $
      kappa_"abs" (x) & = Delta_y/Delta_x \
                      & =^dot markhl(abs(f'(x)), color: #blue)
    $,

    [Beispiel],
    [
      - Davor: $delta_x = 2%$
      - Danach: $delta_y = 50%$

      $ => kappa_"rel" (x) =^dot delta_y/delta_x = 25 mark(space.hair = 2500%, color: #gray) $
    ],
    [
      - Davor: $Delta_x = 1$
      - Danach: $Delta_y = 12$

      $ => kappa_"abs" =^dot Delta_y/Delta_x = 12 mark(space.hair = 1200%, color: #gray) $
    ],

    [Beispiel $f$],
    [
      - $f(x) = x^25$
      $ => kappa_"rel" (x) =^dot abs((x dot f'(x))/f(x)) = abs((25x^25)/x^25) = 25 $
    ],
    [
      - $f(x) = x^25$
      $ => kappa_"abs" (x) = abs(25x^24) $
    ],
  )
]

== Taylorentwicklung

#meander.reflow({
  import meander: *

  placed(
    top + right,
    box(
      figure(
        image("assets/nth_taylor.svg"),
        caption: [Taylorentwicklungen von $exp$ zunehmender Ordnung],
      ),
      width: 150pt,
    ),
  )

  container()

  content[
    *Erinnerung:* Das n-te Taylorpolynom am Entwicklungspunkt $x_0$ ist definiert als

    $
      T_n (f, x_0, x) = sum_(k=0)^n (f^((k))(x_0))/k! (x-x_0)^k
    $

    Jede differenzierbare Funktion kann als Polynom approximiert werden (_Taylorentwicklung_).

    $
      f(x) = T_n (f, x_0, x) + R_(n + 1)
    $

    Mit Restglied $R_(n+1)$.

    Die Taylorentwicklung 1. Ordnung ($n=1$) ist demnach

    $
      f(x) = underbrace(
        f(x_0) + f'(x_0) (x-x_0),
        = T_1
      ) + R_2
    $
  ]
})

*Bezug zur Fehlerbestimmung:* Man kann relative und absolute Kondition alternativ zu @krel und @kabs auch mittels Taylorentwicklung herleiten.

#proof(title: [Herleitung Absolute Kondition])[
  $
    kappa_"abs" (x) & = lim_(tilde(x) -> x) Delta_y/Delta_x \
                    & = lim_(tilde(x) -> x) abs((markhl(f(tilde(x)))-f(x))/(tilde(x)-x)) \
                    & =^dot lim_(tilde(x) -> x) abs((markhl(f(x)+f'(x)(tilde(x)-x)) - f(x))/(tilde(x)-x)) \
                    & = lim_(tilde(x) -> x) abs(f'(x)) \
                    & = abs(f'(x)) space square.filled
  $
]

#proof(title: [Herleitung Relative Kondition])[
  $
    kappa_"rel" (x) & = lim_(tilde(x) -> x) delta_y/delta_x \
                    & = lim_(tilde(x) -> x) abs(((f(tilde(x))-f(x))/f(x))/((tilde(x)-x)/x)) \
                    & = lim_(tilde(x) -> x) abs((markhl(f(tilde(x)))-f(x))/(f(x)) dot x/(tilde(x)-x)) \
                    & =^dot lim_(tilde(x) -> x) abs((markhl(f(x)+f'(x)(tilde(x)-x))-f(x))/f(x) dot x/(tilde(x)-x)) \
                    & = abs((x f'(x))/f(x)) space square.filled
  $
]

#task(title: [Skript-Aufgabe 1.7])[
  Siehe herleitungen oben. Man kann die relative Kondition  aus der Absoluten ableiten, wenn man die beiden Nenner vertauscht.

  $
    lim_(tilde(x) -> x) abs(
      (f(tilde(x))-f(x))/mark(f(x), tag: #<aufgabe_1_7_swap1>) dot
      x/mark(tilde(x)-x, tag: #<aufgabe_1_7_swap2>)
    ) & = lim_(tilde(x) -> x) abs(
          markhl(
            (f(tilde(x))-f(x))/(tilde(x)-x),
            tag: #<aufgabe_1_7_kabs>
          ) dot x/f(x)
        )
        #annot(<aufgabe_1_7_kabs>)[$kappa_"abs"$]
  $

  #annot-cetz(
    (<aufgabe_1_7_swap1>, <aufgabe_1_7_swap2>),
    cetz,
    {
      import cetz.draw: *
      set-style(mark: (start: "straight", end: "straight"), stroke: gray)
      line("aufgabe_1_7_swap1", "aufgabe_1_7_swap2")
    },
  )
]

#align(end)[2026-03-24 VL02]

= Mehr zu Kondition

== Beispiele für Fehlerberechnung

#note[
  - Absolute Fehler sind nur für $x != 0$ definiert.
  - Relative Fehler sind nur für $f(x) != 0$ definiert.
  - $kappa$ ist die *kleinste Zahl* mit
    $
      Delta_y <=^dot kappa_"abs" (x) dot Delta_x \
      delta_y <=^dot kappa_"abs" (x) dot delta_x \
    $
  - $exists.not kappa => f$ ist _schlecht konditioniert_, $kappa = infinity$
  - Kryptographische Hashfunktionen sind gewollt schlecht konditioniert.
]

#example(title: [Brot backen: Relative Kondition])[
  Brot muss bei $T=200 degree "C"$ für $t=1 "h"$ gebacken werden.

  $
    t = (200/T)^2
  $

  Vereinfacht $x := T/100 quad ; quad f(x) := t$:

  $
    f(x) = (2/x)^2
  $

  Der Ofen misst die Temperatur $x$ auf $delta_x = 3%$ genau, wie exakt ist $f(x)$?

  $
    kappa_"rel" (x) & = abs((x f'(x))/f(x)) = 2
  $

  Lösung:

  $
    delta_y & <= kappa_"rel" (x) delta_x \
            & <= 2 dot 0.03 \
            & <= underline(0.06)
  $

  #box(fill: green.transparentize(50%), inset: 4pt)[
    Wir müssen mit 6% Abweichung in der Backzeit rechnen.
  ]
]

#example(title: [Brot backen: Relativ $->$ Absolut])[
  Man kann aus dem relativen Fehler den absoluten berechnen: Beispiel mit $250 degree "C"$:

  $
    f(2.5) approx 0.64 quad delta_y = 0.06 \
    => Delta_y = 0.64 dot 0.06 approx underline(0.04 "h")
  $

  #box(fill: green.transparentize(50%), inset: 4pt)[
    Die Backzeit bei $250 degree "C"$ ist $0.64 "h"$ mit bis zu $0.04 "h"$ Abweichung.
  ]
]

#example(title: [Brot backen: Absolute Kondition])[
  Ofen 2 misst die Temperatur auf $5 degree"C"$ genau.

  $
    Delta_x = 0.05 quad ; quad
    kappa_"abs" (x) = abs(8/x^3)
  $

  Was ist die absolute Abweichung in der Backzeit?

  $
    kappa_"abs" (2.5) = abs(8/2.5^3) approx 1/2
  $

  Die Fehlerverstärkung bei der Berechnung der Backzeit ist $50%$.

  $
    Delta_f(2.5) & <= kappa_"abs" (2.5) dot Delta_x \
                 & <= 1/2 dot 1/20 \
                 & <= underline(0.025 "h")
  $

  #box(fill: green.transparentize(50%), inset: 4pt)[
    Wir müssen bei $250 degree"C"$ mit $1.5 "min"$ Abweichung rechnen.
  ]
]

#example(title: [Pendel])[
  Der Winkel lässt sich aus der gemessenen Zeit ableiten durch

  $
    phi(t) = sin(20 pi t)
  $

  Gegeben sind

  $
    t = 1 quad ; Delta_t = 0.1 ; tilde(t) = 1.1
  $

  Was ist die Fehlerverstärkung $kappa_"abs"$?

  $
    Delta_phi(t) & <= kappa_"abs" (1) dot Delta_t \
               0 & <= kappa_"abs" (1) dot abs(1.1 - 1) \
  $

  TODO damit demonstrieren dass wir nur kleine Fehler abschätzen wollen
]

== Landau-Notation

Die Kondition ist nur für "kleine" Fehler aussagekräftig, weil wir approximieren:

$
  Delta_y <= k_"abs" (x) dot Delta_x + markhl(g(tilde(x), x))
$

#definition[
  Wir definieren $g(tilde(x), x)$ mit
  $
    lim_abs(tilde(x)-x) abs(g(tilde(x), x))/abs(tilde(x)-x) = 0
  $

  Die Funktion wächst also langsamer als $Delta_x$ und ist deshalb vernachlässigbar.
]

Analog für relative Kondition:

$
  delta_y <= k_"rel" (x) dot delta_x + g(tilde(x), x)
$

_Näherung erster Ordnung:_ Wir vernachlässigen $g$.

#definition[
  _Näherung erster Ordnung:_ Glieder höherer Ordnung sind lokal um $x_0$ unwichtig.
]

== Alternative Herleitung Kondition

#proof(title: [Herleitung Absolute Kondition mittels Taylorentwicklung])[
  $
                    f(tilde(x)) & =^dot f(x) + f'(x) (tilde(x)-x) \
               f(tilde(x))-f(x) & =^dot f'(x) dot (tilde(x)-x) \
       underbrace(
         abs(f(tilde(x))-f(x)),
         Delta_y
       )                        & =^dot abs(f'(x)) dot underbrace(
                                    tilde(x)-x,
                                    Delta_x
                                  ) \
    => kappa_"abs" = abs(f'(x))
  $
]

#proof(title: [Herleitung Relative Kondition mittels Taylorentwicklung])[
  $
            delta_y & <=^dot kappa_"rel" (x) delta_x \
    delta_y/delta_x & <=^dot kappa_"rel" (x) \
                    & <=^dot ... space mark("Einsetzen und umformen", color: #gray) \
                    & <=^dot kappa_"abs" (x) abs(x/f(x)) \
                    & <=^dot abs((x f'(x))/f(x))
  $
]

#align(end)[2026-03-31 VL03]

Ab jetzt $kappa := kappa_"rel"$.

== Kondition der Grundrechenarten

#table(
  columns: 3,
  table.header([Operation], $ f(x) $, $ kappa $),
  table.hline(stroke: black),
  [Multiplikation], $ c dot x $, $ 1 $,
  [Division], $ c/x $, $ 1 $,
  [Addition], $ c+x $, $ abs(x/(c+x)) $,
)

- _Auslöschung:_ Bei Addition, wenn $c approx -x$ wird $kappa$ groß

= Stabilität

Sei $tilde(f)$ eine Implementierung von $f$, dann heißt $tilde(f)$ _stabil_, wenn die Fehlerverstärkung  von $tilde(f)$ in der Größenordnung von $kappa$ liegt.

#example(title: [Auslöschung])[
  $
    f(x) = 1/(1+2x) - (1-x)/(1+x)
  $

  Für sehr kleine $x$ ist das eine Subtraktion von fast gleich großen Zahlen. Aber die Kondition nahe 0 ist gut.

  $
    kappa(x) stretch(=)^(x->0) 2
  $

  Wie erklären wir das?

  $
    f(x) & = 1/(1+2x) - (1-x)/(1+x) \
         & = ((1+x)-(1-x)(1+2x))/((1+2x)(1+x)) \
         & = underbrace(
             (2x^2)/((1+2x)(1-x)),
             "Besserer Algorithmus"
           )
  $

  Durch Umformen können wir einen schlechten Ausgangsfehler vermeiden. Der Algorithmus ist stabil.
]

= Zahlendarstellung

- _Stellenwertsystem:_ Siehe AD
- _b-adische Darstellung:_ Darstellung einer Zahl zur Basis $b$
  $
    (d_N, d_(N-1), ..., d_0)_b \
    sum_(j=0)^N d_j dot b^j quad quad d_j in {0, 1, ..., b-1}
  $

#codly(header: [b-adische Darstellung einer Zahl])
```py
while n > b:
    r = n % b
    n //= b
    yield r
```

#align(end)[2026-04-14 VL04]

#note(title: [Division mit Rest])[
  Sei $x in ZZ, b in NN$ dann gibt es $m in ZZ$ und $r in {0, 1, ..., b-1}$ mit $x=m b + r$.
]

#code(title: [Implementierung])[
  In C/Matlab rundet Integer division zum 0 hin, das Lemma rundet immer ab.

  ```c
  -5 / 3                // = -1
  ```

  ```matlab
  idivide(int32(-5), 3)  % = -1
  ```

  ```python
  -5 // 3                # = -2
  ```

  $
    m = floor(x/b) = floor(-5/3) = -2
  $
]

== Multiplikation mit b-adischen Zahlen

#codly(header: [Multiplikation])
```
42 * 23
-------
84      <- 2 * 42
126     <- 3 * 42
-------
966
```

Man kann die Multiplikation auf eine Addition zurückführen.

$
  x_3x_2x_1x_0 dot y_3y_2y_1y_0 = "TODO"
$

== Integer Overflow und Modulo

Wenn ein zu großer Wert abgespeichert wird, werden die $n$ least significant bits gespeichert.

```
011111111 -> 11111111
100000000 -> 00000000
100000001 -> 00000001
100000010 -> 00000010
```

$
  2^n-1 & -> 2^n-1 \
    2^n & -> 0 \
  2^n+1 & -> 1 \
  2^n+2 & -> 2
$

Das entspricht der Modulorechnung

$
  p = 2^n => n dot p + k equiv k (mod p)
$

Ein Term $x=a+b-c$ kann trotz Overflow den exakten Wert liefern, solange $x<2^n$

#task[
  Modulorechnung ist mit Addition, Subtraktion und Multiplikation kompatibel. Beweise.
]

#task[
  Division ist möglich, wenn $p$ eine Primzahl ist. Berechne $3/4 (mod 7)$
]

== Negative Zahlen

Um das Zweierkomplement zu erhalten, invertieren und inkrementieren. Warum eigentlich?

*Invertieren:* Das ist das gleiche wie $111...1111 - n$, also $2^n-1-x$.

*Inkrementieren:*

$
     &&     not x & = 2^n-1-x \
  => && not x + 1 & = 2^n - x \
  => && not x + 1 & = -x (mod 2^n)
$

#code(title: [Implementierung])[
  - C/C++: unsigned int: Overflow wie beschrieben
  - C/C++: signed int: undefined
  - Matlab: kappt an den Grenzen
]

== Reelle Zahlen

Jede reelle Zahl $x in RR$ lässt sich wie folgt darstellen

$
  x = sigma dot
  b^mark(e, tag: #<N>) dot
  underbrace(
    sum_(i=1)^infinity d_i b^(-i),
    "Mantisse" m
  )
  #annot(<N>, pos: bottom, dy: 35pt, $"Exponent"$)
$

Mit

$
  sigma in {-1, 1} quad quad
  N in ZZ quad quad
  d_i in {0, 1, ..., b-1}
$

($N$ ist hier nicht die Bitlänge)

#example(title: [Umrechnung dec $->$ bin])[
  $
    0.45 dot 2 & = 0 + 0.9 \
     0.9 dot 2 & = 1 + 0.8 \
     0.8 dot 2 & = 1 + 0.6 \
     0.6 dot 2 & = 1 + 0.2 \
     0.2 dot 2 & = 0 + 0.4 \
     0.4 dot 2 & = 0 + 0.8 \
     0.8 dot 2 & = 1 + 0.6 \
  $

  $
    => 0.45_(10) = 0.01overline(1100)_2
  $
]

#alternative[
  Testen, ob $1/2^N$ "in der Zahl vorkommt".

  $
     1/2 & lt.eq.not 0.45 && => 0 \
     1/4 & <= 0.45        && => 1 && quad quad 0.45-1/4=0.2 \
     1/8 & <= 0.2         && => 1 && quad quad 0.2-1/8=0.075 \
    1/16 & <= 0.075       && => 1 && quad quad ...
  $
]

== Maschinenzahlen

Mit Basis $b$, Mantissenlänge $m$, $e$-Lower-Bound $L$ und $e$-Upper-Bound $U$ sind die Maschinenzahlen definiert als

$
  MM(b, m, L, U) = {
    x = sigma b^e sum_(i=1)^m d_i b^(-i) mid(|)
    #block[$ sigma in {plus.minus 1} \
    L <= e <= U \
    d_i in {0, 1, ..., b-1} \
    d_1 != 0 $]
  } union {0}
$

#task[
  Bestimme die Formel für kleinste/größte Zahl in $MM$.
]

== IEEE 754 Gleitkommazahlen

=== Vorzeichen

VZ: 0 ist nichtnegativ, 1 ist negativ

=== Charakteristik

Die Charakteristik $c$ ist definiert als

$
  c = e + B
$

mit Exponent $e$ und Bias $B in ZZ$

Die Charakteristik `0` und `1111...` sind reserviert.

=== Mantisse

Die Mantisse $m$ ist

$
  m = 1 + sum_(i=1)^n 1/2^i d_i
$

=== Single Precision

Bias $B=127$

#table(
  columns: (1fr,) * 32,
  align: center,
  table.cell(colspan: 32)[32],
  [1],
  table.cell(colspan: 8)[8],
  table.cell(colspan: 23)[23],
  ..([],) * 32,
  [VZ],
  table.cell(colspan: 8)[Charakteristik],
  table.cell(colspan: 23)[Mantisse],
)

#example[
  $x_1 = 1$

  - VZ = 0
  - $c = 0 + B = 127$
  - $m = 0$
]

#align(end)[2026-04-21 VL05]

== Rundung

#task(title: [Skript-Aufgabe 1.31: Round to even])[
  #table(
    columns: 4,
    table.header($n$, [Sci], [Critical digits], [Rounded to even]),
    $12501_10$, $1.2markhl(5)01 dot 10^4$, $5.01 > 5 => "up"$, $1.3 dot 10^4$,
    $12500_10$, $1.markhl(2, color: #blue)markhl(5)0_10 dot 10^4$, $5 = 5 => 2 "even" => "down"$, $1.2 dot 10^4$,
    $0.3748_10$, $3.7markhl(4)8 dot 10^-1$, $4 < 5 => "down"$, $3.7 dot 10^-1$,
    $0.3750_10$, $3.markhl(7, color: #blue)markhl(5) dot 10^(-1)$, $5=5 => 7 "odd" => "up"$, $3.8 dot 10^(-1)$,
    $11.1_2$, $1.markhl(1, color: #blue)markhl(1)0 dot 2^1$, $1 = 1 => "LSB odd" => "up"$, $10.0 dot 2^1 = 1.0 dot 2^2$,
    $11.01_2$, $1.1markhl(0)1 dot 2^1$, $0 < 1 => "down"$, $1.1 dot 2^1$,
    $0.01010_2$, $1.markhl(0, color: #blue)markhl(1)0 dot 2^(-2)$, $1 = 1 => "LSB even" => "down"$, $1.0 dot 2^(-2)$,
    $0.01011_2$, $1.0markhl(1)1 dot 2^(-2)$, $1.1 > 1 => "up"$, $1.1 dot 2^(-2)$,
  )

  $
    28_10 & = 2.8 dot 10^1 approx 3 dot 10^1 \
          & = 11100_2 = 1.1100 dot 2^4 approx 1 dot 2^4 = 16_10 \
          & => "Höhere Basis hat mehr Information auf gleiche Mantissenlänge"
  $
]

#task(title: [Skript-Aufgabe 1.32: Absoluter Rundungsfehler])[
  Gegeben eine Zahl $x in RR$, die auf eine Mantisse mit länge $m$ gerundet wurde.
  + Bildet man $x$ auf einen Intervall $[1, b[$ ab (scientific notation), hat jeder diskrete Wert einen Abstand zum Nachbarn von $b^(-m)$.
  + Der Abstand einer gerundeten Zahl $"rd"(x)$ zu $x$ ist höchstens die Hälfte von $b^(-m)$. z.B. kann $"rd"(x)=3$ von $2.5$ oder $3.5$ stammen, aber nicht $2.49$ oder $3.51$. ($10^(-1)/2=0.5$)
  + Multipliziert man die normierte Zahl um $b^e$, skaliert sich der Fehler proportional dazu.

  Daher ist der Abstand zur Basis 2

  $
    abs("rd"(x)-x) <= 2^e 2^(-m-1) space square.filled
  $
]

Die Maschinengenauigkeit $epsilon_"mach"$ ist der maximale relative Rundungsfehler.

$
  epsilon_"mach" = 2^(-m) >= abs("rd"(x)-x)/abs(x)
$

Herleitung: Siehe Skript Definition 1.33.

#task(title: [Skript-Aufgabe 1.36: Maschinengenauigkeit])[
  Für $b=10$:

  Eine Mantisse zur Basis 10 der Form

  $
    f_0.f_1f_2...f_m dot 10^e
  $

  Hat einen absoluten Rundungsfehler

  $
    abs("rd"(x)-x) <= 10^e 10^(-m-1)
  $

  Der relative Rundungsfehler ist

  $
    abs("rd"(x)-x)/abs(x) & = (10^e 10^(-m-1))/abs(x) \
                          & <= (10^e 10^(-m-1))/(10^e 10^(-1)) \
                          & = 10^(-m)
  $

  Die Maschinengenauigkeit ist also

  $
    epsilon_"mach" = 10^(-m)
  $

  Verallgemeinert ist die Machinengenauigkeit zur Basis $b$

  $
    epsilon_"mach" = b^(-m)
  $
]

Round to Even in binär bedeutet, die letzte Ziffer auf 0 zu runden.

== Gerundete Operation

$
  abs(((x tilde(*) y) - (x * y))/(x * y)) < epsilon_"mach"
$

#task(title: [Skript-Aufgabe 1.38])[
  #table(
    columns: 4,
    table.header([], $x$, $tilde(x)$, $delta_x$),
    $a$, $0.73563$, $7.36 dot 10^(-1)$, $0.0005...$,
    $b$, $0.73441$, $7.34 dot 10^(-1)$, $0.0005...$,
  )
  $delta_- = 0.6393...$
]

#align(end)[2026-04-28 VL06]

= Vektornorm

- Bis jetzt 1D-Norm: $f : RR -> RR$.
- In diesem Kapitel: $f: RR^n -> RR$

Wir behandeln
- $f: RR^n -> RR$
- $f: RR^n -> RR^n$ für lineare Abbildungen

#definition(title: [Vektornorm])[
  Die Norm auf einen reellen Vektorraum $V$ ist definiert als eine Abbildung

  $
    norm(dot)_* : V -> RR
  $
]

== Eigenschaften

- Positivität: $norm(v) >= 0$
- Definitheit: $norm(v) = 0 <=> v = 0$
- Homogenität: $norm(lambda v) = abs(lambda) dot norm(v)$
- Dreiecksungleichung: $norm(v+w) <= norm(v) + norm(w)$

== Verschiedene Vektornormen

#table(
  columns: 2,
  table.header([*Norm*], [*Definition*]),
  [2-Norm / Euklidische Norm / Mean Squared Error], $ norm(v)_2 = sqrt(sum v_i^2) $,
  [1-Norm / Manhattan-Norm], $ norm(v)_1 = sum |v_i| $,
  [Unendlich-Norm / Max-Norm], $ norm(v)_oo = max |v_i| $,
)

=== Abschätzung

$
     norm(v)_infinity & <= norm(v)_2 && <= sqrt(n) norm(v)_infinity \
  1/sqrt(n) norm(v)_1 & <= norm(v)_2 && <= norm(v)_1 \
     norm(v)_infinity & <= norm(v)_1 && <= n norm(v)_infinity
$

== Allgemeine Definition

Die $p$-Norm mit $1<=p<infinity$ ist definiert als

$
  norm(v)_p = (sum_(i=1)^n abs(v_i)^p)^(1/p)
$

Die Eigenschaften der Vektornorm gelten für alle $p$.

#example(title: [Einheitskreis])[
  $S = {v in RR^2 mid(|) norm(v)_* = 1}$
  #cetz.canvas(length: 1.25cm, {
    import cetz.draw: *

    set-style(mark: (end: "straight"))

    line((-1.5, 0), (1.5, 0))
    line((0, -1.5), (0, 1.5))

    line((0, 0), (-0.5, 0), (-0.5, 0.5), stroke: colors.primary.normal)
    line((0, 0), (-calc.cos(calc.pi / 4), calc.sin(calc.pi / 4)), stroke: colors.secondary.normal)
    line((0, 0), (1, 1), stroke: gray)

    set-style(mark: none)
    line((-1, 0), (0, 1), (1, 0), (0, -1), close: true, stroke: colors.primary.dark)
    circle((0, 0), radius: 1, stroke: colors.secondary.dark)
    rect((-1, -1), (1, 1), stroke: gray)
  })

  Man sieht: Die #text(colors.primary.normal)[1-Norm] ist für einen gegebenen Vektor stets größer gleich der #text(colors.secondary.normal)[2-Norm].
]

#align(end)[2026-05-05 VL07]

= Partielle Ableitungen

#definition(title: [Partielle Ableitung])[
  Die _Partielle Ableitung_ von $f: RR^n -> RR$ an der Stelle $x^* in RR^n$ ist

  $
    (partial f)/(partial x_i) (x^*) = lim_(h=0) (f(x^*+h dot e_i) - f(x^*))/h
  $
]

#info[
  $e_i$ ist der Einheitsvektor in Richtung $i$.
]

Wir lassen fortan $*$ weg.

#grid(
  columns: (1fr,) * 2,
  example[
    $
      f(x_1, x_2) = x_1^2 + x_1 dot x_2
    $

    Nach $x_1$ ableiten:

    $
      (partial f)/(partial x_1)(x_1^*, x_2^*) = 2x_1^* + x_2^*
    $

    Nach $x_2$ ableiten:

    $
      (partial f)/(partial x_2)(x_1^*, x_2^*) = x_1^*
    $

    Gradient:

    $
      gradient f(x_1, x_2) = vec(2x_1+x_2, x_1)
    $
  ],
  example(title: [Kugelvolumen])[
    $
      V(r, h) = 1/3 pi r^2 h \
    $

    Nach $r$ ableiten:

    $
      (partial V)/(partial r) (r, h) & = 2/3 pi r h
    $

    Nach $h$ ableiten:

    $
      (partial V)/(partial h) (r, h) & = 1/3 pi r^2
    $
  ],
)
== Gradient

#definition(title: [Gradient])[
  Der _Gradient_ von $f: RR^n -> RR$ an der Stelle $x^* in RR^n$ ist

  $
    gradient f(x^*) = vec(
      (partial f)/(partial x_1) (x^*),
      (partial f)/(partial x_2) (x^*),
      dots.v,
      (partial f)/(partial x_n) (x^*),
    )
  $
]

== Jakobi-Matrix

#definition(title: [Jakobi-Matrix])[
  Sei $f: RR^n -> RR^m$ ein Funktion mit $m$ Komponentenfunktionen $f_i: RR^n -> RR$, also

  $
    f = vec(f_1, ..., f_m)
  $

  Dann ist

  $
    D_f (x^*) = J_f (x^*) = mat(
      (partial f_1)/(partial x_1) (x^*), ..., (partial f_1)/(partial x_n) (x^*);
      ..., ..., ...;
      (partial f_m)/(partial x_1)(x^*), ..., (partial f_m)/(partial x_n)(x^*)
    )
  $

  Die Jakobi-Matrix von $f$ bei $x^* in RR^n$.
]

#note[
  Im Fall $m=1$ ist die Jakobi-Matrix der Gradient $J_f = gradient f$.
]

== Hesse-Matrix

#definition(title: [Hesse-Matrix])[
  Die _Hesse-Matrix_ $H_f$ einer Funktion $f: RR^n -> R$ ist

  $
    H_f = mat(
      (partial^2 f)/(partial x_1^2), (partial^2 f)/(partial x_1x_2), ..., (partial^2 f)/(partial x_1x_n);
      (partial^2 f)/(partial x_2x_1), (partial^2 f)/(partial x_2^2), ..., (partial^2 f)/(partial x_2x_n);
      dots.v, dots.v, dots.down, dots.v;
      (partial^2 f)/(partial x_n x_1), (partial^2 f)/(partial x_n x_2), ..., (partial^2 f)/(partial x_n^2);
    )
  $
]

#info[
  Es gilt

  $
    H_f = J(gradient f)^T
  $
]

#example(title: [Hesse-Matrix vom Kugelvolumen])[
  $
    gradient V(r, h) = pi/3 vec(2 r h, r^2)
  $

  $
    H_V = pi/3 dot mat(2h, 2r; 2r, 0)
  $
]

#info[
  Die Hesse-Matrix ist symmetrisch, wenn $f$ "glatt genug" ist.

  $
    (partial f)/(partial x_i partial x_j) = (partial f)/(partial x_j partial x_i)
  $
]

= Mehrdimensionale Kondition

== Taylorpolynom

#info(
  title: [Erinnerung: Taylorpolynom in 1D],
)[
  $
    f: RR -> RR
  $


  $
    T_n f(x; a) & = f(a) + f^'(a)/1! (x-a) + (f^('')(a))/2! (x-a)^2 + ... + (f^((n))(a))/n! (x-a)^n \
                & = sum_(k=0)^n (f^((k))(a))/k! (x - a)^k
  $
]
#definition(title: [Taylorpolynom beliebiger Dimension])[
  Sei $alpha = (alpha_1, ..., alpha_d) in NN_0^d$ ein Tupel, welches beschreibt, dass $f: RR^d -> RR$ für jede Variable $x_i$ genau $alpha_i$ mal abgeleitet wird. Oder formal:

  $
    D^alpha = (partial^abs(alpha))/(partial x_1^alpha_1 dots.c partial x_d^alpha_d)
  $

  Dann ist das Taylorpolynom

  $
    T_n f(x; a) & = sum_(abs(alpha)=0)^n (x-a)^alpha/alpha! D^alpha f(a) \
                & = f(a) + gradient f (x)^T (x-a) + ...
  $
]

== Definition

=== Datentypen

Sei $f: RR^n -> RR^m$. Dann

#block(breakable: false)[
  #grid(
    columns: 3,
    column-gutter: 12pt,
    row-gutter: 12pt,
    align: center + horizon,
    math_set(title: $RR^n$)[
      $
              x & = (x_1,...,x_n) \
        Delta_x & = (Delta_x_1, ..., Delta_x_n) \
        delta_x & = (delta_x_1, ..., delta_x_n) \
         Phi(x) & = (Phi_1 (x), ..., Phi_n (x))
      $
    ],
    math_set(title: $RR^m$)[
      $
              y & = (y_1, ..., y_m) \
        Delta_y & = (Delta_y_1, ..., Delta_y_m) \
        delta_y & = (delta_y_1, ..., delta_y_m)
      $
    ],

    math_set(title: $RR$)[
      #set align(center)
      $
        kappa \
        delta_x_i quad quad
        delta_y_i \
        Delta_x_i quad quad
        Delta_y_i \
        Phi_i (x) = (partial f)/(partial x_i) (x) dot x_i/f(x)
      $
      #math_set(title: $RR_0^+$)[
        $
          norm(delta_x) quad quad
          norm(delta_y) \
          norm(Delta_x) quad quad
          norm(Delta_y) \
        $
      ]
    ],
  )
]

=== Zusammenfassung

#table(
  columns: 3,
  table.header($f : x |-> y$, [Absolute Kondition], [Relative Kondition]),
  [Allgemein],
  $
    norm(Delta_y) <= kappa_"abs" (x) dot norm(Delta_x)
  $,
  $
    norm(delta_y) <= kappa_"rel" (x) dot norm(delta_x)
  $,

  $ RR -> RR $,
  $
    abs(f(tilde(x))-f(x)) <= kappa_"abs" (x) dot abs(tilde(x)-x)
  $,
  $
    abs((f(tilde(x))-f(x))/f(x)) <= kappa_"rel" (x) dot abs((tilde(x)-x)/x)
  $,

  $ RR^n -> RR $,
  $
    abs(f(tilde(x))-f(x)) <= kappa_"abs"^* (x) dot norm(tilde(x)-x)_*
  $,
  $
    abs((f(tilde(x))-f(x))/f(x)) <= kappa_"rel"^* (x) dot (norm(tilde(x)-x)_*)/norm(x)_*
  $,

  $ RR^n -> RR^m $,
  $
    norm(f(tilde(x))-f(x))_A <= kappa_"abs"^A (x) dot norm(tilde(x)-x)_B
  $,
  $
    (norm(f(tilde(x))-f(x))_A)/norm(f(x))_A <= kappa_"rel"^A (x) dot (norm(tilde(x)-x)_B)/norm(x)_B
  $,
)
#proof(title: [Herleitung Relative Kondition für $RR^n -> RR$])[
  Das Taylorpolynom erster Ordnung im Entwicklungspunkt $x$ ist

  $
    f(tilde(x)) =^dot T_1 f(tilde(x); x) & = f(x) + gradient f(x)^T (tilde(x) - x) \
                                         & = f(x) + sum_(i=1)^n (partial f)/(partial x_i) (x) dot (tilde(x)_i-x_i) \
  $

  Der Relative Fehler ist

  $
    delta_f(x) & = abs((f(tilde(x))-f(x))/f(x)) \
               & =^dot abs((f(x) + sum_i (partial f)/(partial x_i) (x) (tilde(x)_i-x_i) - f(x)) / f(x)) \
               & = abs(1/f(x) dot (sum_i (partial f)/(partial x_i) (x) (tilde(x)_i-x_i))) \
               & = sum_i abs(1/f(x) dot (partial f)/(partial x_i) (x) dot (tilde(x)_i-x_i)) \
               & = sum_i abs(x_i/x_i dot 1/f(x) dot (partial f)/(partial x_i) (x) dot (tilde(x)_i-x_i)) \
               & = sum_i abs(x_i/f(x) dot (partial f)/(partial x_i) (x) dot (tilde(x)_i-x_i)/x_i) \
               & <= sum_i abs(x_i/f(x) dot (partial f)/(partial x_i) (x)) dot abs((tilde(x)_i-x_i)/x_i) \
               & = sum_i abs(Phi_i (x)) dot abs((tilde(x)_i-x_i)/x_i) \
               & <= max_(i=1,...,n) abs(Phi_i (x)) dot sum_(i=1)^n abs((tilde(x)_i-x_i)/x_i) \
               & = norm(Phi(x))_infinity dot norm(delta_x)_1
  $

  Aus der Definition der relativen Kondition folgt:

  $
    kappa_"rel"^infinity (x) & = norm(Phi(x))_infinity \
                             & = max_(i=1,...,n) abs(x_i/f(x) dot (partial f)/(partial x_i) (x))
  $
]

#example(title: [Relative Kondition Kugelvolumen])[
  $
    Phi_r (r, h) = (partial V)/(partial r) (r, h) dot r/(1/3 pi r^2 h) \
    = pi/3 2 r h r / (1/3 pi r^2 h) \
    = 2
  $

  $
    Phi_h (r, h) = (partial V)/(partial h) (r, h) dot h/(1/3 pi r^2 h) = ... \
    = 1
  $

  $
    kappa_"rel"^infinity (r, h) = max {abs(2), abs(1)} =2
  $
]

= Matrixnormen

== Vektorraum

#note[
  Die Notation $"Mat"_(n, m)(M)$ beschreibt die Menge aller $n times m$ Matrizen $A$, dessen Einträge $a_(i j) in M$ sind.
]

Matrizen erfüllen die Bedingungen, um Einträge eines Vektorraums zu sein.

Statt Vektoraddition haben wir Matrixaddition:

$
  A + B = C quad quad c_(i j) = a_(i j) + b_(i j)
$

Und statt Multiplikation eines Vektors mit einem Skalar, einer Matrix mit einem Skalar:

$
  lambda A = B quad quad b_(i j) = lambda a_(i j)
$

== Induzierte Norm

#definition[
  Definition auf Vektornorm zurückführen:
  $
    norm(A)_* & = max_(x in RR^n, x != 0) (norm(A x)_*)/(norm(x)_*) \
              & = max_(x in RR^n, norm(x)_* = 1) norm(A x)
  $
]

Induzierte Normen sind _Submultiplikativ:_ Dreiecksungleichung gilt.

== Verschiedene Matrixnormen

#{
  show table.cell.where(y: 0): text.with(weight: "bold")
  show table.cell.where(x: 0): text.with(weight: "bold")
  table(
    columns: 4,
    table.header([Norm], [Induziert von], [Formel], [$ norm(mat(a, b; c, d)) $]),
    [Frobenius-], [], $ norm(A)_F = sqrt(sum_(i=1)^n sum_(j=1)^m a_(i j)^2) $, $ sqrt(a^2 + b^2 + c^2 + d^2) $,
    [Spektral-], [2-Norm], $ norm(A)_2 = max_(norm(x)_2 = 1) norm(A x)_2 $, $$,
    [Spaltensummen-],
    [1-Norm],
    $ norm(A)_1 = max_(j=1,...,n) sum_(i=1)^m abs(a_(i j)) $,
    $ max {abs(a)+abs(c), abs(b)+abs(d)} $,

    [Zeilensummen-],
    [$infinity$-Norm],
    $ norm(A)_infinity = max_(i=1,...,m) sum_(j=1)^n abs(a_(i j)) $,
    $ max {abs(a)+abs(b), abs(c)+abs(d)} $,
  )
}

- Spektralnorm ist abhängig von Eigenwerten der Matrix

#align(end)[2026-05-12 VL08]

#proof(title: [Spaltensummennorm])[
  Siehe Skript NMA s23
]

#proof(title: [Zeilensummennorm])[
  Siehe Skript NMA s24
]

= Matrixkondition

#info(title: [Eigenschaften von induzierten Normen])[
  Weil wir den Vektor $x$ als 1-Spaltige Matrix betrachten können, ist $norm(A x)$ submultiplikativ.

  $
    norm(A x) <= norm(A) dot norm(x)
  $
]

#example(title: [Geradenschnitt])[
  $
    y=m_i x+b_i
  $

  Wie wirkt sich ein Fehler in beiden $b$ auf den Schnittpunkt zwischen 2 Geraden aus?

  Als Matrix umschreiben:

  #grid(
    columns: (1fr,) * 2,
    align: horizon,
    $
      a_(1 1) x + a_(1 2) y & = b_1 \
      a_(2 1) x + a_(2 2) y & = b_2 \
    $,

    $
      <=> A dot v = b;
      A=vec(x, y)
    $,
  )

  Desto kleiner der Winkel ist, desto größer ist der Bereich, in dem der Schnittpunkt sein könnte.

  #cetz.canvas(length: 0.1cm, {
    import cetz.draw: *

    line((0, -1), (50, 1), stroke: 10pt + blue.transparentize(70%))
    line((0, -1), (50, 1))
    line((0, 1), (50, -1), stroke: 10pt + red.transparentize(70%))
    line((0, 1), (50, -1))
  })
]

Im folgenden arbeiten wir mit dem linearen Gleichungssystem $b = A x$. Wir betrachten die $n times n$ Matrix $A$ als Funktion:

$
  A: RR^n -> RR^n \
  A: x |-> b
$

Die Kondition $kappa_"rel"^* (A)$ der Matrix $A$ ist die Fehlerverstärkung des Eingabefehlers $delta_x = norm(bv(delta)_x)_*$ zum Ausgabefehler $delta_b = norm(bv(delta)_b)_*$ unter einer Norm.

#definition(title: [Matrixkondition])[
  $
    delta_b_* <= kappa_"rel"^*(A) delta_x
  $
]

== Absolute Matrixkondition

#definition[
  $
    kappa_"abs" (A) = norm(A)
  $
]

#proof[
  $
         && norm(tilde(b)-b) & = norm(A tilde(x)-A x) \
         &&                  & = norm(A (tilde(x)-x)) \
         &&                  & <= norm(A) dot norm(tilde(x)-x) \
    <==> &&          Delta_b & <= norm(A) Delta_x space square.filled
  $
]

== Relative Matrixkondition

#definition[
  $
    kappa_"rel" (A) = norm(A) dot norm(A^(-1))
  $
]

#proof[
  $
         &&   norm(x) & = norm(A^(-1) b) \
         &&           & <= norm(A^(-1)) dot norm(b) \
    <==> && 1/norm(b) & <= norm(A^(-1))/norm(x) \
  $
  Wenn wir um die absolute Matrixkondition multiplizieren, erhalten wir
  $
     ==> && Delta_b dot 1/norm(b) & <= norm(A) Delta_x dot norm(A^(-1))/norm(x) \
    <==> &&       Delta_b/norm(b) & <= norm(A) dot norm(A^(-1)) dot Delta_x/norm(x) \
    <==> &&               delta_b & <= norm(A) dot norm(A^(-1)) dot delta_x space square.filled
  $
]

#note(title: [Norm der Inversen])[
  $
        && kappa(A) & = norm(A) dot norm(A^(-1)) \
    ==> && kappa(A) & = kappa(A^(-1)) \
    ==> &&  delta_x & <= kappa (A) dot delta_b
  $
]

= LR-Zerlegung

Sei $A$ quadratische invertierbare Matrix und $b$ Vektor. Um Gleichungssystem zu lösen:

$
      &&      A x & = b \
  <=> && A^(-1) b & = x
$

Invertieren ist aufwendig und numerisch instabil. Besser: LR-Zerlegung.

== Dreiecksmatrizen lösen
Wenn eine Zerlegung $A=L R$ mit einer unteren Dreiecksmatrix $L$ und einer oberen Dreiecksmatrix $R$ vorliegt, löst man das Gleichungssystem so:

$
       &&                                                    A x & = b \
  <==> &&                                                  L R x & = b \
  <==> &&              L mark(underbrace((R x), =:z), tag: #<1>) & = b \
  <==> &&                             mark(L z & = b, tag: #<2>) \
       &&    #annot(<1>, dx: 3cm, pos: center)[Rücksubstitution] \
       && #annot(<2>, dx: 3cm, pos: center)[Vorwärtselimination]
$

#table(
  columns: 2 * (1fr,),
  table.header([*Vorwärtselimination*], [*Rücksubstitution*]),
  $ L z = b $, $ R x = z $,
  $
    z_k = (b_k - sum_(i=1)^(k-1) l_(k,i) z_i)/l_(k,k)
  $,
  $
    x_k = ( z_k - sum_(i=k+1)^n r_(k,i) x_i) / r_(k,k)
  $,
)

#example[
  $
    L = mat(1, 0, 0; 2, 1, 0; -1, 0, 1) quad quad
    R = mat(1, -1, 0; 0, 3, 1; 0, 0, 2) quad quad
    b = vec(3, 7, -7)
  $

  *Schritt 1: Vorwärtselimination* $L z = b$

  $
           z_1 & = 3  && ==> z_1 && = 3 \
    2z_1 + z_2 & = 7  && ==> z_2 && = 1 \
    -z_1 + z_3 & = -7 && ==> z_3 && = -4
  $

  *Schritt 2: Rücksubstitution* $R x = z$

  $
       2 x_3 & = -4 && ==> x_3 && = -2 \
    3x_2+x_3 & = 1  && ==> x_2 && = 1 \
     x_1-x_2 & = 3  && ==> x_1 && = 4
  $
]

== Dreiecksmatrizen erzeugen (LR-Zerlegung)

#definition(title: [Gauß-Ersetzen-Matrix])[
  Addition des $lambda$-Fachen der $s$-ten Zeile auf die $r$-te Zeile, durch Multiplikation von links:

  $
    L^(r, s)(lambda) = mat(
      1, , , , ;
      , 1, , , ;
      , mark(lambda, tag: #<1>), dots.down, , ;
      , , , , 1;
    ) \ \
    #annot(<1>, dx: 3cm, pos: center)[$r$]
    #annot(<1>, dy: 1cm, pos: center)[$s$]
  $
]

#definition(title: [Frobenius-Matrix])[
  Beachte: $lambda = -a_(r i)/a_(i i)$, sodass $a_(r i) + lambda a_(i i) = a_(r i) - a_(r i)/a_(i i) a_(i i) = 0$.

  #grid(
    columns: 2,
    column-gutter: 16pt,
    align: horizon,
    $
      L^((1)) = mat(
        1;
        -a_(2 1)/a_(1 1), 1;
        -a_(3 1)/a_(1 1), , 1;
        dots.v, , , dots.down;
        -a_(n 1)/a_(1 1), , , , 1
      )
    $,
    $
      L^((i))= mat(
        1;
        , dots.down;
        , , dots.down;
        , , , dots.down;
        , , , , mark(1, tag: #<1>);
        , , , , -a_(i+1,i)/a_(i i), dots.down;
        , , , , -a_(i+2,i)/a_(i i), , dots.down;
        , , , , dots.v, , , dots.down;
        , , , , -a_(n i)/a_(i i), , , , 1
      )
      #annot(<1>, pos: center, dx: 1cm)[$i$]
      #annot(<1>, pos: center, dy: -1cm)[$i$]
    $,
  )

]

#info(title: [Frobenius-Matrizen invertieren])[
  Einfach alle $lambda$s negieren.
  $
    (L^((i)))^(-1) & = mat(
                       dots.down;
                       , 1;
                       , lambda_(i+1), dots.down;
                       , dots.v;
                       , lambda_n
                     )^(-1)
                     = mat(
                       dots.down;
                       , 1;
                       , -lambda_(i+1), dots.down;
                       , dots.v;
                       , -lambda_n
                     )
  $
]

Beachte, dass $L^(r, s)$ und $L^((i))$ *nicht die gesuchte* linke untere Dreiecksmatrix $L$ sind.

=== R erzeugen

Um die obere rechte Dreiecksmatrix zu erhalten, wenden wir jede Frobeniusmatrix an:

$
  R = L^((n-1)) dot dots dot L^((1)) dot A
$

=== L erzeugen

Um die untere linke Dreiecksmatrix zu erhalten, verwenden wir:

$
       &&                                                       R & = L^((n-1)) dot ... dot L^((1)) dot A \
  <==> && underbrace((L^((n-1)) dot ... dot L^((1)))^(-1), = L) R & = A \
$

Weiter:

$
  L & = (L^((n-1)) dot ... dot L^((1)))^(-1) \
    & = (L^((1)))^(-1) dot ... dot (L^((n-1)))^(-1) \
    & = mat(
        1;
        -lambda_2^((1)), 1;
        -lambda_3^((1)), -lambda_3^((2)), 1;
        -lambda_4^((1)), -lambda_4^((2)), -lambda_4^((3)), 1;
        dots.v, dots.v, dots.v, dots.v, dots.down
      )
$



// #example[
//   $
//     A = mat(
//       2, 1, 0;
//       -2, 1, -2;
//       -4, 4, -7
//     )
//   $
//
//   Was sind $L$ und $R$?
//
//   Gauß-Algorithmus mit nur ersetzen liefert $R$.
//
//   $
//     A^1 & = mat(
//             2, 1, 0;
//             0, 2, -2;
//             0, 6, -7
//           ) \
//     A^2 & = mat(
//             2, 1, 0;
//             0, 2, -2;
//             0, 0, -1
//           ) = R
//   $
// ]

#align(end)[2026-05-19 VL09]

#proof(title: [Eindeutigkeit LR-Zerlegung])[
  Eine Zerlegung $A = L dot R$ mit $L$ mit 1en auf Diagonale ist eindeutig, wenn sie existiert.

  $
    L_1 R_1 = A = L_2 R_2 ==> L_1 = L_2, R_1 = R_2
  $

  Beweis durch $L_2^(-1) L_1 = R_2 R_1^(-1) = I$
]

== Pivotisierung

Motivation: Bei folgendem Beispiel kann $a_(2 1)$ nicht zu 0 werden: $mat(0, 1; markhl(1), 0)$

#definition(title: [Permutationsmatrix])[
  Sei $pi : {1, ..., n} -> {1, ..., n}$ eine bijektive Abbildung.

  Das heißt: $pi(i)$ liefert für $i in {1, ..., n}$ einen Wert in ${1, ..., n}$.

  $e_pi(i)$ ist der Einheitsvektor (als Zeile) mit 1 an Stelle $pi(i)$.
  Die _Permutationsmatrix_ $P_pi$ ist
  $
    P_pi = mat(
      e_pi(1);
      e_pi(2);
      dots.v;
      e_pi(n);
    )
  $

  Alternative Veranschaulichung: $P_pi$ entsteht durch Zeilentauschen der Einheitsmatrix $I$.
]

#info(title: [Notation])[
  $P_(i, j)$ vertauscht Zeilen $i$ und $j$.

  $P^((i)) = P_(l,i)$ vertauscht Zeile $i$ mit einer niedrigeren (oder gleichen, dann $P=I$) Zeile $l$, dessen Eintrag $a_(l i) != 0$ ist.
]

#info(title: [Eigenschaften])[
  Das inverse einer Permutation ist die umgekehrte Permutation.

  $
        &&  P^(-1) & = P^T \
    ==> && P dot P & = I
  $

  Eine einzelne Vertauschung ist das gleiche wie die umgekehrte Vertauschung.

  $
    P_(i,j) = P_(i,j)^(-1) = P_(j,i) = P_(j,i)^(-1)
  $

  Von links vertauscht $P dot A$ Zeilen, und von rechts vertauscht $A dot P$ Spalten.
]

Bei der _Pivotisierung_ für die obere Dreiecksmatrix $R$ gehen wir wie folgt vor:

Wenn in Schritt $k$ ein $a_(k, k) = 0$, dann:
+ Finde ein $a_(l, k) != 0$ in Zeile $l$ *unter* $k+1$.
+ Vertausche Zeilen $k$ und $l$

$
      &&             A & = mat(
                           , dots.v;
                           ..., 0, ...;
                           , dots.v;
                           , a_(l k);
                           , dots.v;
                         ) \
  ==> &&       P dot A & = mat(
                           , dots.v;
                           ..., a_(l k), ...;
                           , dots.v;
                           , 0;
                           , dots.v;
                         ) \
  ==> && L dot P dot A & = mat(
                           , dots.v;
                           ..., a_(l k), ...;
                           , arrow(0);
                         )
$

Im nächsten Schritt $k+1$ multiplizieren wir wieder $L^((k+1)) dot P^((k+1))$ an:

#pagebreak() // workaround for mannot bug

#block(inset: (top: 1cm), breakable: false)[
  $
    R = underbrace(... dot L^((k+1)) dot mark(P^((k+1)), tag: #<P2>) dot mark(L^((k)), tag: #<L1>) dot P^((k)) dot ..., =L^(-1)) dot A
    #annot-cetz((<L1>, <P2>), cetz, {
      import cetz.draw: *
      set-style(mark: (end: "straight"))
      bezier("P2.north", "L1.north", (rel: (0, 1), to: ("L1", 50%, "P2")), name: "arrow")
      content("arrow.mid", anchor: "south", padding: 2pt)[Zeilenvertauschung]
    })
  $
]

Man sieht, dass $L^((k))$ jetzt nicht mehr zwangsläufig eine untere Dreiecksmatrix ist. Insbesondere könnten alle Zeilen unter $k$ vertauscht sein.

#block(inset: (top: 1cm, left: 1cm), breakable: false)[
  $
    mat(
      mark(I, tag: #<tl>);
      , mark(1, tag: #<1>);
      , lambda^((k))_(k+1), 1;
      , dots.v, , dots.down;
      , lambda^((k))_(n), , , , mark(1, tag: #<br>);
    )
    #annot-cetz((<1>, <tl>, <br>), cetz, {
      import cetz.draw: *
      set-style(mark: (end: "straight"))
      line((rel: (0, 1), to: "1"), "1", name: "sk")
      content("sk.start", anchor: "south", padding: 2pt)[$k$]
      line((rel: (-1, 0), to: "1"), "1", name: "rk")
      content("rk.start", anchor: "east", padding: 2pt)[$k$]

      let l = ("tl.west", "|-", "1.south")
      let ll = (rel: (-1, 0), to: l)
      let r = ("br.east", "|-", "1.south")
      let rr = (rel: (1, 0), to: r)

      line(rr, (rel: (0, -1)))
      set-style(mark: none, stroke: (dash: "dashed", paint: colors.on_surface.light))
      line(ll, rr)
    })
  $
]

Problematisch sind hier die Einsen auf der Diagonale. Um nach einer Zeilenvertauschung $P_(i j)$ die 1en wieder auf die Diagonale zu bringen, nutzen wir die Symmetrie der Einheitsmatrix:

$
  P I = I P ==> P I P = I
$

#example(title: [Zeilen-Spaltenvertauschung])[
  #box(inset: (bottom: .1cm))[
    $
      mat(
        1;
        , mark(1, tag: #<a1>, color: #colors.primary.normal);
        , , 1;
        , , , mark(1, tag: #<b1>, color: #colors.secondary.normal);
      ) quad arrow.squiggly.long^(P dot) quad mat(
        1;
        , , , mark(1, tag: #<a2>, color: #colors.primary.normal);
        , , 1;
        , mark(1, tag: #<b2>, color: #colors.secondary.normal)
      ) quad arrow.squiggly.long^(dot P) quad mat(
        1;
        , mark(1, tag: #<b3>, color: #colors.secondary.normal);
        , , 1;
        , , , mark(1, tag: #<a3>, color: #colors.primary.normal);
      )
      #annot-cetz((<a1>, <a2>, <a3>, <b1>, <b2>, <b3>), cetz, {
        import cetz.draw: *
        set-style(mark: (start: "straight", end: "straight"), stroke: colors.on_surface.lighter)
        let y1 = (rel: (0, -.5), to: "b1")
        line("a1", ("a1", "|-", y1), y1, "b1")
        let x2 = (rel: (.5, 0), to: "a2")
        line("a2", x2, ("b2", "-|", x2), "b2")
      })
    $
  ]
]

Das funktioniert auch für aneinandergereihte Permutationen mit $(P_2 dot P_1) dot L dot (P_2 dot P_1)^(-1)$. (Beweis: @cr_ue7.2.2)

Wir wollen jetzt also folgende Permutation durchführen, sodass $L$ wieder untere Dreiecksmatrix wird:

$
  R & = mark(L^((n-1)), tag: #<Ln-1>) mark(P^((n-1)), tag: #<Pn-1>) mark(L^((n-2)), tag: #<Ln-2>) mark(P^((n-2)), tag: #<Pn-2>) mark(L^((n-3)), tag: #<Ln-3>) dot ... dot mark(L^((1)), tag: #<L1>) mark(P^((1)), tag: #<P1>) dot mark(A, tag: #<A>) \
  & = underbrace(L^((n-1)), hat(L)^((n-1))) underbrace(P^((n-1)) L^((n-2)) P^((n-1)), hat(L)^((n-2))) underbrace(P^((n-1)) P^((n-2)) L^((n-3)) P^((n-2)) P^((n-1)), hat(L)^((n-3))) dot ... dot P^((n-1)) P^((n-2)) dot ... dot P^((1)) dot A
$

#proof(title: [Pivotisierung funktioniert nur mit vollem Rang])[
  Annahme: Was ist, wenn untere Rechte Teilmatrix $tilde(A)$ aus $A$ keinen vollen Rang hat?

  $==>$ nicht invertierbar

  $==> det tilde(A)^((k)) = 0$

  $==> det A^((k)) = 0$

  Aber $A^((k))$ muss invertierbar sein, weil es ein Produkt aus $P^((l)), L^((l)), A$ ist.

  $==> det A^((k)) != 0 arrow.zigzag space square.filled$
]

Was ist eine gute Wahl für Permutation $P$?

Wähle das betragsmäßig größte Element $a^((k))_(l, k+1)$, #highlight[selbst wenn] $a_(k+1,k+1)^((k)) != 0$. Das ist stabil, außer:

$
  mat(
    1, 0, dots.c, 0, 1;
    -1, 1, dots.down, dots.v, dots.v;
    dots.v, dots.down, 1, 0, dots.v;
    dots.v, , dots.down, 1, dots.v;
    -1, dots.c, dots.c, -1, 1
  )
$

#info(title: [Bessere Verfahren])[
  Stabilere Verfahren als die LR-Zerlegung sind

  - Cholesky-Zerlegung
  - QR-Zerlegung
]

#align(end)[2026-06-02 VL10]

= Lineare Ausgleichsrechnung

Problem: Wir haben Punkte $(x, y)$. Wir möchten eine Funktion $F$, die möglichst nah an allen Punkten ist.

#note(title: [Lineare Abbildungen])[
  Eine Abbildung $phi: RR^n -> RR^m$ ist linear, wenn für alle $v, v' in RR^n, lambda in RR$ gilt:

  - Additivität: $phi(v+v')=phi(v)+phi(v')$
  - Homogenität: $phi(lambda v) = lambda phi(v)$

  Lineare Abbildungen können als Matrixmultiplikation mit $A in "Mat"_(m,n)(RR)$ dargestellt werden.

  $
    phi: v |-> A v
  $
]

#definition(title: [Modell])[
  Ein _Regressionsmodell_ ist eine Funktion $F: RR^n -> RR$ mit _Parametern_ $theta in RR^m$.

  $
    F(x, theta) = f_1 (x) dot theta_1 + f_2 (x) dot theta_2 + ... + f_n (x) dot theta_n = y_i
  $

  Man kann das als Matrixvektormultiplikation darstellen.

  $
         && mat(
              f_1 (x_1), ..., f_m (x_1);
              dots.v, , dots.v;
              f_1 (x_n), ..., f_m (x_n)
            ) & dot vec(theta_1, dots.v, theta_m) && = vec(y_1, dots.v, y_n) \
    <==> && A & dot theta                         && = y
  $
]

Wir können beliebige Funktionen $f_i$ wählen, um ein Modell zu bauen. Die Funktionen $f_i$ müssen nicht linear sein.

#table(
  columns: 2,
  [Lineares Modell], $ theta_1 x + theta_2 $,
  [Polynomiell], $ theta_0 x_0^0 + theta_1 x_1^1 + ... + theta_n x_n^n $,
  [Trigonometrisch], $ theta_1 sin(x) + theta_2 cos(x) $,
  [Exponential], $ theta_1 dot e^(theta_2 x) $,
)

Wir können dann die optimalen Parameter $theta_*$ berechnen, indem wir $A theta = y$ lösen.

#example(title: [Lineares Modell: Stromspannung, Stromstärke und Widerstand])[
  Wir haben folgende Messwerte für $I$ (frei) und $U$ (abhängig).

  $
    I = x = vec(7, 12, 18, 19) quad quad U = y = vec(154, 264, 396, 418)
  $

  Es gilt der Dreisatz: $U = R dot I$.

  $
         &&     I dot R & = U \
    <==> && A dot theta & = y
  $

  In diesem Modell haben wir nur eine Funktion ($I dot R = U$), deshalb ist $A$ ein Vektor. Wir haben nur einen Parameter ($R$), deshalb ist $theta$ ein Skalar.

  Wenn wir dieses lineare Gleichungssystem für $theta = R$ auflösen, erhalten wir das optimale $theta_*$.

  $
    mat(augment: #1, 7, 154; 12, 264; 18, 396; 19, 418) arrow.squiggly.long mat(
      augment: #1,
      1, 22;
      0, 0;
      0, 0;
      0, 0
    ) ==> R = theta_1 = 22
  $
]

== Lineare Modelle Aufstellen

=== Ausgleichsgerade

Gegeben sind
- unabhängige Datenpunkte $x in RR^n$
- abhängige Datenpunkte $y in RR^n$.

Wir wählen die Geradengleichung $m x + b$ als Modellfunktion.

$
  F(x, theta) & = & f_1 (x) & dot theta_1 & + && f_2 (x) & dot theta_2 \
              & = &       x & dot m       & + &&       1 & dot b
$

In Matrixschreibweise:

$
  && A & dot theta && = y \
  <==> && mat(f_1(x_1), f_2(x_1); dots.v, dots.v; f_1(x_n), f_2(x_n)) & dot vec(theta_1, theta_2) && = vec(y_1, dots.v, y_n) \
  <==> && mat(x_1, 1; dots.v, dots.v; x_n, 1) & dot vec(m, b) && = vec(y_1, dots.v, y_n)
$

=== Ausgleichsebene

Gegeben sind
- unabhängige Datenpunkte $x, y in RR^n$
- abhängige Datenpunkte $z in RR^n$.

Wir wählen die Ebenengleichung $alpha x + beta y + gamma = z$

$
  F(x, y, theta) & = f_1 (x, y) dot theta_1 && + f_2 (x, y) dot theta_2 && + f_3(x, y) dot theta_3 \
                 & = x dot alpha            && + y dot beta             && + 1 dot gamma
$

In Matrixschreibweise:

$
       &&                          A dot theta & = z \
  <==> && mat(
            f_1(x_1, y_1), f_2(x_1, y_1), f_3(x_1, y_1);
            dots.v, dots.v, dots.v;
            f_1(x_n, y_n), f_2(x_n, y_n), f_3(x_n, y_n);
          ) dot vec(theta_1, theta_2, theta_3) & = vec(z_1, dots.v., z_n) \
  <==> &&        mat(
                   x_1, y_1, 1;
                   dots.v, dots.v, dots.v;
                   x_n, y_n, 1
                 ) dot vec(alpha, beta, gamma) & = vec(z_1, ..., z_n)
$

=== Quadratisches Modell

Wir wählen ein quadratisches Polynom $y = a_0 x_0^0 + a_1 x_1^1 + a_2 x_2^2$

$
  F(x, theta) & = f_1 (x) dot theta_1 && + f_2 (x) dot theta_2 && + f_3 (x) dot theta_3 \
              & = x^2 dot a_2         && + x^1 dot a_1         && + x^0 dot a_0
$

In Matrixschreibweise:

$
       &&                          A dot theta & = y \
  <==> && mat(
            f_1 (x_1), f_2 (x_1), f_3 (x_1);
            dots.v, dots.v, dots.v;
            f_1 (x_n), f_2 (x_n), f_3 (x_n)
          ) dot vec(theta_1, theta_2, theta_3) & = vec(y_1, dots.v, y_n) \
  <==> &&            mat(
                       x_1^2, x_1^1, x_1^0;
                       dots.v, dots.v, dots.v;
                       x_n^2, x_n^1, x_n^0
                     ) dot vec(a_2, a_1, a_0)  & = vec(y_1, dots.v, y_n)
$

Das kann auf alle Polynome verallgemeinert werden.

=== Exponentialfunktion

Wir wählen die Exponentialfunktion $y = c dot exp(a x)$. Man kann $exp(theta x)$ nicht als Produkt $f(x) dot theta$ darstellen, also ziehen wir den natürlichen Logarithmus.

$
         y & = c dot exp(a x) \
     log y & = log c + a x \
  tilde(y) & = tilde(c) + a x
$

Wir modellieren die umgeformte Gleichung und führen sie danach mit $exp(dot)$ wieder zurück.

$
  F(x, theta) & = f_1(x) dot theta_1 && + f_2(x) dot theta_2 \
              & = 1 dot tilde(c)     && + x dot a
$

In Matrixschreibweise:

$
       &&            A dot theta & = y \
  <==> && mat(
            f_1 (x_1), f_2 (x_1);
            dots.v, dots.v;
            f_1 (x_n), f_2 (x_n)
          ) dot vec(
            theta_1,
            theta_2
          )                      & = vec(y_1, dots.v, y_n) \
  <==> && mat(
            1, x_1;
            dots.v, dots.v;
            1, x_n
          ) dot vec(tilde(c), a) & = vec(y_1, dots.v, y_n)
$

== Lineare Modelle lösen

=== Lösbarkeit von LGS

Für $A theta = y$ gibt es oft keine (eindeutige) Lösung.

$
  "rank" A & = "rank" mat(A, y) & = n & quad ==> quad "Eindeutige Lsg." \
  "rank" A & = "rank" mat(A, y) & < n & quad ==> quad "Unendlich viele Lsg." \
  "rank" A & < "rank" mat(A, y) &     & quad ==> quad "Keine Lsg."
$
Mit dem _Least Squares_ Verfahren können wir das optimale $theta_*$ approximieren. Statt $A theta - y = 0$ exakt zu lösen, approximieren wir $A theta - y approx 0$. //minimieren wir die Vektornorm ($norm(bold(upright(x))) = 0 <==> bold(upright(x)) = 0$):

$
       &&               A theta & approx y \
  <==> &&           A theta - y & approx 0 \
  <==> &&     norm(A theta - y) & approx 0 \
  <==> &&   norm(A theta - y)_2 & approx 0 \
  <==> && norm(A theta - y)_2^2 & approx 0 \
$

Wir verwenden die euklidische Norm, um das Problem später geometrisch zu lösen. Wir nutzen das Quadrat, um keine Wurzeln ziehen zu müssen.

#definition(title: [Least Squares])[
  $
    bv(theta)_* = arg min_(bv(theta) in RR^n) norm(A bv(theta) - bv(y))_2^2
  $
]

#note[
  $
    arg min_(theta in RR^n) norm(A theta - y) = 0 <==> exists "Lsg."
  $
]

#code(title: [Matlab])[
  Bei vollem Rang $"rank" A=n$ kann das in Matlab über `A \ y` gelöst werden.
]

#align(end)[2026-06-09 VL11]

=== Normalengleichung

#info(title: [Bildraum])[
  Der Bildraum einer $m times n$ Matrix $A$ sind alle Vektoren die durch Linksmultiplikation mit $A$ entstehen können.

  $
    "Im" A = {A v mid(|) v in RR^n }
  $

]
#example(title: [Bildräume])[
  $
             "Im" mat(0) & = {bva(0)} \
                  "Im" I & = RR^n \
    "Im" mat(1, 0; 0, 0) & = {vec(x, 0) mid(|) x in RR }
  $
]

#info(title: [Orthogonalität von Unterräumen])[
  Das Skalarprodukt ist definiert als
  $
    dp(bv(v), bv(w)) = bv(v)^T bv(w) = sum_(i=1)^m v_i w_i
  $

  Es kann verwendet werden, um Orthogonalität zu prüfen.

  $
    dp(bv(v), bv(w)) = 0 <==> bv(v) space tack.t space bv(w)
  $

  Ein Unterraum $V$ ist orthogonal zu einem Vektor $w$, wenn alle Vektoren $v in V$ orthogonal zu $w$ stehen.

  $
    V space tack.t space bv(w) <==> bv(v) space tack.t space bv(w) quad forall bv(v) in V
  $
]

Um Least Squares zu lösen, müssen wir ein $bv(theta)$ finden, das den Vektor $A bv(theta) - bv(y)$ minimiert. In anderen Worten: Wir wollen den Vektor $bv(y)_* = A bv(theta)_* in "Im" A$, der den geringsten Abstand zum Vektor $bv(y)$ hat.

Das ist genau dann der Fall, wenn $bv(y)_* - bv(y)$ orthogonal zu $"Im" A$ steht.

#example(title: [Beispiel in 2D])[
  #lq.diagram(
    legend: (position: (100% + .5em, 0%)),
    xlim: (-1, 1),
    ylim: (-1, 1),
    width: 6cm,
    height: 6cm,
    lq.line(
      (1, 1),
      (-1, -1),
      tip: tiptoe.straight,
      toe: tiptoe.straight,
      label: $"Im" A$,
    ),
    ..range(1, 5).map(d => {
      lq.line(
        (d / 5, d / 5),
        (-d / 5, -d / 5),
        tip: tiptoe.straight,
        toe: tiptoe.straight,
      )
    }),
    lq.line(
      (0, 0),
      (-.25, .75),
      tip: tiptoe.straight,
      label: $bv(y)$,
      stroke: colors.primary.normal,
    ),
    lq.line(
      (-.25, .75),
      (.25, .25),
      tip: tiptoe.straight,
      label: $bv(y)_* - bv(y)$,
      stroke: colors.secondary.normal,
    ),
    lq.plot(
      (.25,),
      (.25,),
      label: $A bv(theta)_* = bv(y)_*$,
      mark: "o",
      color: colors.tertiary.normal,
    ),
  )

  $
    A = mat(1, 1; 1, 1)
  $
]

Der Vektor #hl(fill: colors.secondary.light)[$A bv(theta)_* - y$] ist genau dann orthogonal zu $"Im" A$, wenn gilt:

$
  dp(markhl(A bv(theta)_* - y, fill: colors.secondary.light), A bv(theta)) = 0 quad forall A bv(theta) in "Im" A
$

#definition(title: [Normalengleichung])[
  $
         && A^T A Theta_* - A^T y & = 0 \
    <==> &&           A^T A Theta & = A^T y
  $
]

#proof[
  Der Bildraum $"Im"(A) = {A Theta mid(|) Theta in RR^n } subset.eq RR^m$ ist ein Unterraum des $RR^m$. Das ist ein Punkt/Gerade/Ebene/...

  Wir suchen ein $y_*$ welches den kleinsten Abstand zu $y$ hat. Das ist der Fall, wenn $y_*-y$ orthogonal zum Bild ist.

  Der Bildraum ist orthogonal zum Vektor, wenn jeder Vektor im Bildraum orthogonal zum Vektor ist.

  $
    chevron.l v, w chevron.r = v^T w = sum_i^m v_i w_i quad (v, w in RR^m) \
    v tack.t w <==> chevron.l v, w chevron.r = 0 \
    V tack.t w <==> chevron.l v, w chevron.r = 0 quad forall v in V quad "mit" V subset.eq RR^m \
    "Im" A tack.t y_*-y <==> "Im" A tack.t A Theta_* - y
    <==> tilde(y) tack.t (A Theta_* - y) quad forall tilde(y) in "Im" A \ \
    ... tack.t ... <==> lr(chevron.l tilde(y), A Theta_* - y chevron.r) = 0
  $

  Skalarprodukt berechnen.

  $
    lr(chevron.l tilde(y), A Theta_* - y chevron.r) & = tilde(y)^T (A Theta_* - y) \
                                                    & = ... \
                                                    & = Theta^T (A^T A Theta_* - A^T y)
  $

  Wir verwendeten für die Umformung $M x = 0 forall x <==> M = 0$

]

#alternative(title: [Alternativer Beweis])[
  Wir verwenden in der Umformung $norm(x)_2^2 = chevron.l x, x chevron.r$

  $
    f(Theta) & = norm(A Theta - y)_2^2 \
             & = ... \
             & = Theta^T A^T A Theta - 2 y^T A Theta + y^T y
  $

  Minimum von $f$ wird angenommen, wenn:

  $
    0 = gradient f = A^T A Theta - A^T y space square.filled
  $
]

#definition[
  Sei $A in "Mat"_(m,n), v in RR^n$. Dann gilt:

  $
    A v = 0 <==> A^T A v = 0
  $

  Insbesondere ist $A^T A$ invertierbar, wenn $"rank" A = n$.
]

#proof[
  "$==>$"
  $
    A v = 0 => A^T A v = 0
  $

  "$<==$"
  $
    A^T A v = 0 => 0 & = v^T A^T A v \
                     & = ... \
                     & = (A v)^T dot A v \
                     & = chevron.l A v, A v chevron.r \
                     & = norm(A v)_2^2 \
              => A v & = 0 space square.filled
  $
]

#definition(title: [Kern einer Matrix])[
  $
    "ker" A & = {v in RR^n mid(|) A v = 0} \
            & = {v in RR^n mid(|) A^t A v = 0} \
            & = "ker" A^T A
  $

  Satz:

  $
    A^T A "invertierbar" & <==> "ker" A^T A = {0} \
                         & <==> "ker" A = {0} \
                         & <==> "rank" A = n
  $
]

== Anwendung / Herangehensweise

Gegeben: Daten $(x_i, y_i)$

+ Unabhängige Variablen $x$, anhängige Variablen $y$
+ Modell: $F(x, Theta) = f_1 (x) Theta_1 + ... + f_n (x) Theta_n$
+ Parameter $Theta$ aufstellen
+ Matrix aufstellen
  $
    A = mat(
      f_1 (x_1), ..., f_n(x_1);
      dots.v, , dots.v;
      f_1(x_m), ..., f_n(x_m)
    ) \
    A^T A =: M \
    A^T y =: tilde(y)
  $
+ Löse $M Theta = tilde(y)$ für $Theta$. Das ist das optimale $Theta_*$.

= Interpolation und Splines

Sei $Omega in RR, x_i in Omega$. Wir suchen eine Interpolationsfunktion $g: Omega -> RR$

#lq.diagram(
  xaxis: (
    ticks: range(5).zip(range(1, 6).map(i => $x_#i$)),
  ),
  lq.plot(range(5), (1, 3, 2, 5, 4)),
)

Der Vektorraum aller Polynome vom Grad $n$ ist

$
  PP_n = {sum_(j=0)^n a_j x^j mid(|) a_j in RR}
$

Wir definieren für den Moment $G_n = PP_n$

Die Lagrange-Interpolation

#task[
  $PP_n$ ist ein $n+1$ dim. Vektorraum mit Basis $1, x, ..., x^n$.
]
