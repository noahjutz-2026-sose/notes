#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3"
#import "@preview/gentle-clues:1.3.1": *
#import "@preview/mannot:0.3.2": *
#import "@preview/meander:0.4.1"

#import "/template.typ": template
#import "/components.typ": *


#show: template

#title[Numerische Mathematik]

Notizen #sym.dot 2026 SoSe #sym.dot Noah Jutz

#outline()

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
  &= lim_(tilde(x) -> x) abs((markhl(f(x)+f'(x)(tilde(x)-x))-f(x))/f(x) dot x/(tilde(x)-x)) \
  &= lim_(tilde(x) -> x) abs((x f'(x))/f(x)) space square.filled
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

=
