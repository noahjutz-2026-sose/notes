#import "/deps.typ": cetz, cetz-plot, gentle-clues, mannot, meander, codly
#import gentle-clues: *
#import mannot: *
#import codly: codly
#import "/components.typ": *

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

#table(columns: 3,
  [Symbol], [Definition], [Name],
  $ Delta_y $, $ abs(f(tilde(x))-f(x)) $, [Absoluter Ausgabefehler],
  $ delta_y $, $ Delta_y / abs(f(x)) $, [Relativer Ausgabefehler]
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
    \u{f05c3} #sym.space Floating Point Arithmetic
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
  delta_y / delta_x &= ((f(tilde(x))-f(x))/f(x)) / ((tilde(x)-x)/x) \
  &=(f(tilde(x))-f(x))/mark(f(x), tag: #<fx>) dot x/mark((tilde(x)-x), tag: #<x>) \
  &=markhl((f(tilde(x))-f(x))/(tilde(x)-x), tag: #<sekante>, color: #green)

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
            label: $"Tangente" f'(x)$
          )
          plot.add(
            domain: (4.8, 5.3),
            x => calc.pow(x, 2),
            style: (stroke: blue),
            label: $f(x) = x^2$
          )
          plot.add(
            ((5, calc.pow(5, 2)), (5.1, calc.pow(5.1, 2))),
            mark: "o",
            label: "Sekante"
          )
        })
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
        stroke: 1pt + gray
      )
      line("fx", "x")
    }
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
  => f'(x_0) &= lim_(x->0) (f(x_0+x)-f(x_0))/x \
  &= lim_(x -> 0) ((x_0+x)^(1/3) - x_0^(1/3))/x \
  &= lim_(x -> 0) x^(1/3)/x
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
  => kappa_"rel" (x_0) &= lim_(x -> x_0) abs(x/(x-1)) \
  &= lim_(x -> 1) abs(x/(x-1)) = infinity
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
    kappa_"rel" (x) &= delta_y/delta_x \
    &=^dot markhl(abs((x dot f'(x))/f(x)), color: #blue)
    $,
    $
    kappa_"abs" (x) &= Delta_y/Delta_x \
    &=^dot markhl(abs(f'(x)), color: #blue)
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
      width: 150pt
    )
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
  kappa_"abs" (x) &= lim_(tilde(x) -> x) Delta_y/Delta_x \
  &= lim_(tilde(x) -> x) abs((markhl(f(tilde(x)))-f(x))/(tilde(x)-x)) \
  &=^dot lim_(tilde(x) -> x) abs((markhl(f(x)+f'(x)(tilde(x)-x)) - f(x))/(tilde(x)-x)) \
  &= lim_(tilde(x) -> x) abs(f'(x)) \
  &= abs(f'(x)) space square.filled
  $
]

#proof(title: [Herleitung Relative Kondition])[
  $
  kappa_"rel" (x) &= lim_(tilde(x) -> x) delta_y/delta_x \
  &= lim_(tilde(x) -> x) abs(((f(tilde(x))-f(x))/f(x))/((tilde(x)-x)/x)) \
  &= lim_(tilde(x) -> x) abs((markhl(f(tilde(x)))-f(x))/(f(x)) dot x/(tilde(x)-x)) \
  &=^dot lim_(tilde(x) -> x) abs((markhl(f(x)+f'(x)(tilde(x)-x))-f(x))/f(x) dot x/(tilde(x)-x)) \
  &= abs((x f'(x))/f(x)) space square.filled
  $
]

#task(title: [Skript-Aufgabe 1.7])[
  Siehe herleitungen oben. Man kann die relative Kondition  aus der Absoluten ableiten, wenn man die beiden Nenner vertauscht.

  $
  lim_(tilde(x) -> x) abs(
    (f(tilde(x))-f(x))/mark(f(x), tag: #<aufgabe_1_7_swap1>) dot
    x/mark(tilde(x)-x, tag: #<aufgabe_1_7_swap2>)
  )

  &= lim_(tilde(x) -> x) abs(markhl(
    (f(tilde(x))-f(x))/(tilde(x)-x),
    tag: #<aufgabe_1_7_kabs>
  ) dot x/f(x))

  #annot(<aufgabe_1_7_kabs>)[$kappa_"abs"$]
  $

  #annot-cetz(
    (<aufgabe_1_7_swap1>, <aufgabe_1_7_swap2>),
    cetz,
    {
      import cetz.draw: *
      set-style(mark: (start: "straight", end: "straight"), stroke: gray)
      line("aufgabe_1_7_swap1", "aufgabe_1_7_swap2")
    }
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
        kappa_"rel" (x) &= abs((x f'(x))/f(x)) = 2
    $

    Lösung:

    $
        delta_y &<= kappa_"rel" (x) delta_x \
        &<= 2 dot 0.03 \
        &<= underline(0.06)
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
        Delta_f(2.5) &<= kappa_"abs" (2.5) dot Delta_x \
        &<= 1/2 dot 1/20 \
        &<= underline(0.025 "h")
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
        Delta_phi(t) &<= kappa_"abs" (1) dot Delta_t \
        0 &<= kappa_"abs" (1) dot abs(1.1 - 1) \
    $

    TODO damit demonstrieren dass wir nur kleine Fehler abschätzen wollen
]

== Landau-Notation

Die Kondition ist nur für "kleine" Fehler aussagekräftig, weil wir approximieren:

$
    Delta_y <= k_"abs" (x) dot Delta_x + markhl(g(tilde(x), x))
$

#clue(title: [Definition])[
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

#clue(title: [Definition])[
    _Näherung erster Ordnung:_ Glieder höherer Ordnung sind lokal um $x_0$ unwichtig.
]

== Alternative Herleitung Kondition

#proof(title: [Herleitung Absolute Kondition mittels Taylorentwicklung])[
    $
        f(tilde(x)) &=^dot f(x) + f'(x) (tilde(x)-x) \
        f(tilde(x))-f(x) &=^dot f'(x) dot (tilde(x)-x) \
        underbrace(
            abs(f(tilde(x))-f(x)),
            Delta_y
        )
        &=^dot abs(f'(x)) dot underbrace(
            tilde(x)-x,
            Delta_x
        ) \
        => kappa_"abs" = abs(f'(x))
    $
]

#proof(title: [Herleitung Relative Kondition mittels Taylorentwicklung])[
    $
        delta_y &<=^dot kappa_"rel" (x) delta_x \
        delta_y/delta_x &<=^dot kappa_"rel" (x) \
        &<=^dot ... space mark("Einsetzen und umformen", color: #gray) \
        &<=^dot kappa_"abs" (x) abs(x/f(x)) \
        &<=^dot abs((x f'(x))/f(x))
    $
]

#align(end)[2026-03-31 VL03]

Ab jetzt $kappa := kappa_"rel"$.

== Kondition der Grundrechenarten

#table(columns: 3,
    table.header(
        [Operation], $ f(x) $, $ kappa $,
    ),
    table.hline(stroke: black),
    [Multiplikation], $ c dot x $, $ 1 $,
    [Division], $ c/x $, $ 1 $,
    [Addition], $ c+x $, $ abs(x/(c+x)) $
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
        f(x) &= 1/(1+2x) - (1-x)/(1+x) \
        &= ((1+x)-(1-x)(1+2x))/((1+2x)(1+x)) \
        &= underbrace(
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
