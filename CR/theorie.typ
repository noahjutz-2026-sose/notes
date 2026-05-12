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
      & = -(4 + sum_(i=1)^23 2^(-i)) \
      & = -100.11111111111111111111111_2 \
      & = -1.0011111111111111111111111_2 dot 2^2 \
      & approx - 1.01_2 dot 2^2 \
  e_3 & = 127 + 2 = 129 = 10000001_2 \
  s_3 & = 1
$

#ieee754.single("11000000101")

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

Siehe Skript-Aufgabe 1.31

== Maschinengenauigkeit Epsilon

Der Algorithmums liefert $e=-23$, also $epsilon = 2^(-23)$. Matlabs eingebaute `eps` liefert den gleichen Wert:

```matlab
log2(eps("single"))

ans =
  single
   -23
```

Die Maschinengenauigkeit ist definiert als $2^(-m)$, also verwendet Matlab eine Mantissenlänge von $m=23$.

Warum ist der Abstand zwischen $1$ und dem nächsten Wert $2^(-23)$, aber zwischen $1+2^(-23)$ und dem nächsten Wert $2^(-24)$?

Weil letzterer Wert ungerade ist, und der kleinere Wert mit Aufrundung reicht. Betrachten wir die letzten 3 Bits der Mantisse:

#table(
  columns: 5,
  align: center,
  stroke: none,
  $...$, $0$, $0$, $0$, $mark(color: #gray, 0)$,
  $$, $2^(-21)$, $2^(-22)$, $2^(-23)$, $mark(color: #gray, 2^(-24))$,
)

#table(
  columns: 2,
  table.header([Round down], [Round up]),
  $
           && ...000mark(color: #gray, 0) & \
         + &&                           1 & \
         = &&    000mark(color: #gray, 1) & mark(color: #gray, 000) \
    approx &&   000 mark(color: #gray, 0) &
  $,
  $
           && ...001mark(color: #gray, 0) & \
         + &&                           1 & \
         = &&    001mark(color: #gray, 1) & mark(color: #gray, 000) \
    approx &&   010 mark(color: #gray, 0) &
  $,
)

== Maschinengenauigkeit für Basis verallgemeinern

Siehe Skript-Aufgabe 1.36.

== Auslöschung

Siehe Skript-Aufgabe 1.38.

== Stabilität

$f_1$: Zwei fast gleiche Terme werden subtrahiert $=>$ Auslöschung

$
  f_1(x) & = sqrt(1+x^2) - sqrt(1-x^2) \
         & = a-b \
         & = (a-b) dot (a+b)/(a+b) \
         & = (a^2 - b^2)/(a+b) \
         & = (1+x^2-(1-x^2))/(sqrt(1+x^2)+sqrt(1-x^2)) \
         & = markhl(color: #green, (2x^2)/(sqrt(1+x^2)+sqrt(1-x^2)))
$

$f_2$: $cos x -> 1$  für kleine $x$. Daher Auslöschung mit 1.

$
  f_2(x) & = (1-cos x)/x \
         & = (1-cos x)/x dot (1+cos x)/(1+cos x) \
         & = (1-cos^2 x)/(x + x cos x) \
         & = (sin^2 x)/(x + x cos x)
$

#align(end)[2026-05-02 TT04]

= IEEE 754

== Kleinste und größte Maschinenzahl

IEEE Single:

#grid(
  columns: (1fr,) * 2,
  $
    c_min & = 1 \
    e_min & = -126 "(def.)" \
    m_min & = 2^(-23) \
    x_min & = 2^(-23) dot 2^(-126) = 2^(-149) \
          & "(Denormalisierte Zahl)"
  $,
  $
    c_max & = 2^8-2 \
    e_max & = 2^8-2-127 = 2^8-129 \
    m_max & = bold(1+)(2^23-1) dot 2^(-23) = 2 - 2^(-23) \
    x_max & = (2-2^(-23)) dot 2^(2^8-129) \
          & = (2-2^(-23)) dot 2^(127) \
          & = 2^128-2^104 \
  $,
)

Allgemein für $MM(b, m, L, U)$:

#grid(
  columns: (1fr,) * 2,
  $
    e_min & = L \
    m_min & = 2^(-m) \
    x_min & = e_min dot m_min = b^L dot 2^(-m) \
  $,
  $
    e_max & = U \
    m_max & = 2 - 2^(-m) \
    x_max & = e_max dot m_max = b^U dot (2 - 2^(2-m))
  $,
)

== IEEE Rechenoperationen

=== Bitmuster

#further(width: 50%)[
  #link("https://www.youtube.com/watch?v=PjmWG_8b3os")[Binary Multiplication]
]

#table(
  columns: 2,
  $
    y_1 & = x_1 / 8 \
  $,
  $
    c_y_1 & = c_x_1 - 3 \
          & = 01010110 -3 \
          & = 01010011 \
    m_y_1 & = m_x_1 \
    s_y_1 & = s_x_1
  $,

  $
    y_2 & = 6.3_10 \
  $,
  $
    6.3_10 & = 110.0overline(100) \
           & = 1.100overline(100) dot 2^2 \
     c_y_2 & = 127 + 2 = 10000001 \
     m_y_2 & = 100100100100100 text(#gray, | 10010010...) \
           & approx 100100100100100 + 1 \
           & = 100100100100101 \
     s_y_2 & = 0
  $,

  $
    y_3 & = x_2^2
  $,
  $
    m_y_3 & = m^2_x_2 \
          & = 0110000 00000000^2 \
          & = 1001000000000000000000000000 \
          & = 2^13 dot 100100000000000 \
    c_y_3 & = c_x_2 + 13 = 11111110 \
    s_y_3 & = 0
  $,
)

=== IEEE zu Dezimal

$
          x_3 & = 01000000 10110000 00000000 \
              & = + (1 + 0.011000000000000_2) dot 2^(10000001_2-127) \
              & = 1.011_2 dot 2^(257-127) \
              & = 1.375 dot 2^130 \
  log_10(x_3) & =log_10(1.375) + 130 dot log_10(2) \
              & = 39.272202134483834 \
          x_3 & = 10^0.272202134483834 dot 10^39 \
              & approx 1.87 dot 10^39
$

=== Ordnen

+ $z_2$ (negativ)
+ $z_4$ (kleinster exponent)
+ $z_3$ (kleinere Mantisse)
+ $z_1$

== Endliche Darstellbarkeit in Dezimal- und Binärform

=== Endlicher Dezimalbruch zu Binärbruch

Falsch, gegenbeispiel: $6.3_10 = 110.overline(1001)_2$

=== Binärbruch zu Endlicher Dezimalbruch

Wahr, weil:

Endliche Dezimalbrüche bleiben sind unter Addition abgeschlossen.

$=>$ auch unter Multiplikation, weil das eine wiederholte Addition ist.

$=>$ auch unter Potenzierung, weil das eine wiederholte Multiplikation ist.

$=>$ $forall e in ZZ : 2^(e)$ ist endlicher Dezimalbruch.

Weil das auch unter Addition und Multiplikation abgeschlossen ist, ist die Summation der Mantissebits und Multiplikation um Exponenten sowie Sign-Bit endlich darstellbar.

$
  => s dot 2^e dot (1 + sum_(i=0)^m d_i 2^(-i)) "kann als endlicher Dezimalbruch dargestellt werden." square.filled
$

== Vektornormen

=== Dreiecksungleichung

#table(
  columns: 2,
  [1-Norm],
  $
    abs(a + b) <= abs(a) + abs(b)
  $,

  [$infinity$-Norm],
  $
    max a + b <= max a + max b
  $,
)

=== Beweis

TODO

== Partielle Ableitungen

#grid(
  columns: (1fr,) * 2,
  $
    (partial f_1)/(partial x) & = 2x \
    (partial f_1)/(partial y) & = 3y^2
  $,
  $
    (partial f_2)/(partial x) & = sin y \
    (partial f_2)/(partial y) & = x cos y
  $,
)

#align(end)[2026-05-12]

= Matrixnormen

== Beweis Induzierte Norm einschränken

Die induzierte Norm einer Matrix $A$ beschreibt den maximale Streckungsfaktor eines Vektors $x$ unter Linearer Transformation mit $A$.

$
  "Streckungsfaktor" = (norm(A x)_*)/norm(x)_*
$

Um zu beweisen, dass das Maximum aller Vektoren $x in RR^n$ gleich ist mit dem der Einheitsvektoren $norm(x)_* = 1$, beweise ich noch genereller, dass der Streckungsfaktor gleich bleibt, egal wie lang $x$ ist.

$
  norm(A x)/norm(x) & = 1/norm(x) norm(A x) \
                    & = norm(1/norm(x) A x) \
                    & = norm(A x/norm(x)) space square.filled
$

== Beweis Induzierte Norm

Für eine Norm muss gelten:

+ Positivität: $norm(v) >= 0$
+ Definitheit: $norm(v) = 0 <=> v = 0$
+ Homogenität: $norm(lambda v) = abs(lambda) dot norm(v)$
+ Dreiecksungleichung: $norm(v+w) <= norm(v) + norm(w)$

Wir setzen voraus, dass das für Vektornormen gilt und führen induzierte Normen darauf zurück. Wir müssen nur den Term $norm(A x)$ betrachten.

1. *Positivität:* Ein linear transformierter Vektor bleibt ein Vektor. $square$
2. *Definitheit:* Ausschließlich Nullmatrix kann alle Vektoren zu 0 komprimieren. $square$
3. *Homogenität:* Ziehe Streckung aus Matrix. $(abs(lambda) A) v = A dot (abs(lambda) v) space square$
4. *Dreiecksungleichung:* $norm((A+B)x)=norm(A x + B x) <=^(1) norm(A x) + norm(B x)$. (1): $A x$ und $B x$ sind vektoren. $square$

$square.filled$

== Mehrdimensionale Kondition

#note[
  $
    phi_i (x) = (partial f)/(partial x_i) dot x_i/f(x) \
    kappa_"rel"^infinity = norm(phi)_infinity = max_i abs((partial f)/(partial x_i) (x) dot x_i/f(x))
  $
]

===

$
  f(x_1, x_2) = x_1^2 x_2
$

$
  phi_1 & = (partial f)/(partial x_1) dot (x_1)/f(x) \
        & = 2x_1 x_2 dot x_1/(x_1^2x_2) \
        & = 2 \
  phi_2 & = (partial f)/(partial x_2) dot x_2/f(x) \
        & = x_1^2 dot x_2/(x_1^2x_2) \
        & = 1
$

$
  kappa_"rel"^infinity = max_i abs(phi_i) = phi_1 = 2
$

===

$
  a(s, t) = s/t^2
$

$
  phi_s & = 1/t^2 dot s/(s/t^2) \
        & = 1 \
  phi_t & = s dot (-2) t^(-3) dot t/(s/t^2) \
        & = -2 dot s dot t^(-3) dot t dot t^2 dot 1/s \
        & = -2
$

$
  kappa_"rel"^infinity = max abs(Phi) = abs(-2) = 2
$

TODO max Zeitmessung-Fehler
