#import "/components/admonitions.typ": *
#import "/deps.typ": cetz, mannot
#import "/style.typ": *
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
  delta_y & = abs(phi_s) dot delta_s + abs(phi_t) dot delta_t \
       3% & = 1 dot 1% + 2 dot delta_t \
       1% & = delta_t
$

= Matrixkondition

== Matrixnorm

#note(title: [Relevante Definitionen])[
  p-Vektornorm:
  $
    norm(v)_p = (sum_(i=1)^n abs(v_i)^p)^(1/p)
  $

  Induzierte Matrixnorm:

  $
    norm(A)_p = max_(x in RR^n , norm(x)_p = 1) norm(A x)
  $

  Frobeniusnorm:

  $
    norm(I)_FF & = sqrt(sum a_(i j)^2)
  $
]

=== Beweis Einheitsmatrix

Zu zeigen: $norm(I)=1$.

Die Einheitsmatrix ist das neutrale Element der Multiplikation. Daher verändert sich der Vektor $x$ nicht.

$
  norm(I)_* & = max_(x in RR^n, norm(x)_*=1) norm(I x) \
            & = max norm(x) \
            & = 1 space square
$

Gilt nicht für Frobeniusnorm. Gegenbeispiel:

$
  norm(mat(1, 0; 0, 1))_FF = sqrt(2) != 1 space square
$

=== Beweis Permutationsmatrix

Zu zeigen: $norm(P)_p=1$.

Bei einem Vektor entspricht eine Multiplikation mit Permutationsmatrix der Vertauschung von Komponenten. Die p-Vektornorm erfolgt über komponentenweise Addition. Addition ist Kommutativ. Daher gilt

$
  max norm(P x) = norm(x) = 1 space square.filled
$

=== Beweis Diagonalmatrix

Zu zeigen: $norm(D A)_infinity = 1$ für alle invertierbaren quadratischen $A$ und eine Diagonalmatrix $D$.

#note(title: [Zeilensummennorm])[
  $
    norm(A)_infinity = max_(i=1,...,m) sum_(j=1)^n abs(a_(i j))
  $
]

Weil $A$ quadratisch ist und vollen Rang hat, gibt es keine 0-Zeile. Jede (absolute) Zeilensumme $sigma_i > 0$ kann mit einem $abs(d_i) > 0$ multipliziert werden, um einen beliebigen Wert zu erhalten. Man kann also ein $D$ konstruieren als

$
  d_(i i) = 1/sigma_i
$

Sodass $sigma_i dot d_(i i) = 1$ und damit $norm(D A)_infinity = 1$. $square.filled$

== Matrixkondition

=== Berechnen

$
  kappa_"rel"^1 (A) & = norm(A)_1 dot norm(A^(-1))_1 \
                    & = (max mat(4, 7, 11, 4)) dot (max mat(19, 14, 14, 3)) \
                    & = 11 dot 19 \
                    & = 209
$

$
  kappa_"rel"^infinity (A) & = norm(A)_infinity dot norm(A^(-1))_infinity \
                           & = (max mat(5, 4, 4, 13)) dot (max mat(22, 15, 3, 10)) \
                           & = 13 dot 22 \
                           & = 286
$

=== Beweis

#note(title: [Relevante Definitionen])[
  Relative Matrixkondition:

  $
    kappa(A) = norm(A) dot norm(A^(-1))
  $

  Matrixnorm:

  $
    norm(A) = max_(norm(x)=1) norm(A x)
  $
]

Zu zeigen: $kappa(A) >= 1$.

Induzierte Normen sind Submultiplikativ. Norm der Einheitsmatrix oben bewiesen.

$
       norm(A dot B) & <= norm(A) dot norm(B) \
  norm(A^(-1) dot A) & <= norm(A) dot norm(A^(-1)) \
             norm(I) & <= norm(A) dot norm(A^(-1)) \
                   1 & <= kappa(A) space square.filled
$

=== Kondition Diagonalmatrix

$
  kappa_1(D) & = norm(D) dot norm(D^(-1)) \
             & = norm(
                 mat(
                   d_1;
                   , dots.down;
                   , , d_n
                 )
               ) dot norm(
                 mat(
                   1/d_1;
                   , dots.down;
                   , , 1/d_n
                 )
               ) \
             & = (max_i abs(d_i)) dot (min_i 1/abs(d_i)) \
             & = (max abs(d_i))/(min abs(d_i)) \
             & = kappa_infinity (D)
$

== LR-Zerlegung

$
  A = mat(
    1, 0, -1;
    -2, 2, 3;
    3, 2, -6
  )
$

1. Zerlegung

$
  R & = L^((2)) L^((1)) A \
    & = mat(
        1, 0, 0;
        0, 1, 0;
        0, -1, 1
      ) dot mat(
        1, 0, 0;
        2, 1, 0;
        -3, 0, 1;
      ) dot A \
    & = mat(
        1, 0, -1;
        0, 2, 1;
        0, 0, -4
      )
$

$
  L & = (L^((1)))^(-1) (L^((2)))^(-1) \
    & = mat(
        1, 0, 0;
        -2, 1, 0;
        3, 1, 1;
      )
$

2. Lösen

$
           L z & = b \
           z_1 & = b_1 = 3 \
   -2z_1 + z_2 & = b_2     && <==> z_2 = b_2+2z_1 = -1+6=5 \
  3z_1+z_2+z_3 & = b_3     && <==> z_3 = b_3-z_2-3z_1 = 2-5-9 = -12
$

$
  z = vec(3, 5, -12)
$

$
       R x & = z \
     -4x_3 & = z_3 && <==> x_3 = -1/4 z_3 = 3 \
  2x_2+x_3 & = z_2 && <==> x_2 = 1/2 (z_2-x_3) = 1 \
   x_1-x_3 & = z_1 && <==> x_1 = z_1+x_3 = 6
$

#box(inset: 4pt, fill: green.transparentize(50%))[
  $
    x = vec(6, 1, 3)
  $
]

== Normweise relative Kondition

Wir starten mit der allgemeinen Definition der Matrixkondition.

// $
//                                                                   delta_b & <= kappa(A) delta_x \
//                                                  norm(tilde(b)-b)/norm(b) & <= kappa(A) norm(tilde(x)-x)/norm(x) \
//                                          norm(A tilde(x) - A x)/norm(A x) & <= kappa(A) norm(tilde(x)-x)/norm(x) \
//             norm(A tilde(x) - A x)/norm(A x) dot norm(x)/norm(tilde(x)-x) & <= kappa(A) \
//             norm(A tilde(x) - A x)/norm(tilde(x)-x) dot norm(x)/norm(A x) & <= kappa(A) \
//             norm(A (tilde(x) - x))/norm(tilde(x)-x) dot norm(x)/norm(A x) & <= kappa(A) \
//   (norm(A) dot norm(tilde(x) - x))/norm(tilde(x)-x) dot norm(x)/norm(A x) & <= kappa(A) \
//                                             norm(A) dot norm(x)/norm(A x) & <= kappa(A) space square.filled
// $

$
                    norm(x) & = norm(A^(-1) A x) \
                    norm(x) & <= norm(A^(-1)) dot norm(A x) \
          norm(x)/norm(A x) & <= norm(A^(-1)) \
  norm(A) norm(x)/norm(A x) & <= underbrace(norm(A^(-1)) dot norm(A), =kappa(A)) space square.filled
$

= LR-Zerlegung

== Frobeniusmatrizen

=== Beweis Erste Frobeniusmatrix

Zu zeigen: $L^((r,s))(lambda) dot A$ addiert das $lambda$-fache der $s$-ten Zeile auf die $r$-te Zeile von $A$.

Die Identität $I A = A$ verändert nichts. Fügt man eine Komponente $l_(r s) != 0$ mit $r>s$ hinzu, erhält man per Definition $L^((r,s))$.

Matrixmultiplikation ist Zeile mal Spalte summiert. $l_(r s)$ ist in Zeile $r$, also wird mit $L((r,s)) A = A^((1))$ die $r$-te Zeile beeinflusst:

#box(inset: 1cm)[
  $
      & #[
          #show regex("\w"): text.with(colors.on_surface.lighter)
          $ mat(
            mark(a_(1 1), tag: #<a11>), mark(a_(1 2), tag: #<a12>), mark(a_(1 3), tag: #<a13>), mark(a_(1 4), tag: #<a14>);
            mark(a_(2 1), tag: #<a21>), mark(a_(2 2), tag: #<a22>), mark(a_(2 3), tag: #<a23>), mark(a_(2 4), tag: #<a24>);
            mark(a_(3 1), tag: #<a31>), mark(a_(3 2), tag: #<a32>), mark(a_(3 3), tag: #<a33>), mark(a_(3 4), tag: #<a34>);
            mark(a_(4 1), tag: #<a41>), mark(a_(4 2), tag: #<a42>), mark(a_(4 3), tag: #<a43>), mark(a_(4 4), tag: #<a44>);
          ) $] \
    #box(inset: (top: 1cm))[
      #show "0": text.with(colors.on_surface.lighter)
      #show "1": text.with(colors.on_surface.light)
      #show math.lambda: text.with(colors.primary.normal)
      $ mat(
        1, 0, 0, 0;
        0, 1, 0, 0;
        0, 0, 1, 0;
        mark(bold(lambda), tag: #<lambda>), 0, 0, mark(1, tag: #<1>)
      ) $
    ] & #box[
          $ mat(

            ; ; ;
            a^((1))_(r 1), a^((1))_(r 2), a^((1))_(r 3), a^((1))_(r 4);
          ) $
        ]
        #annot-cetz((<lambda>, <a11>, <a12>, <a13>, <a14>, <1>, <a41>, <a42>, <a43>, <a44>), cetz, {
          import cetz.draw: *
          let l = (rel: (-1, 0), to: "lambda")
          let lt = ("lambda", "|-", "a11")
          let ltp = (rel: (0, 1), to: lt)
          let t_a11 = (rel: (0, 1), to: "a11")
          let t_a12 = (rel: (0, 1), to: "a12")
          let t_a13 = (rel: (0, 1), to: "a13")
          let t_a14 = (rel: (0, 1), to: "a14")

          set-style(mark: (end: "straight"))

          line("lambda", ltp, t_a11, "a11.north")
          line(t_a11, t_a12, "a12.north")
          line(t_a11, t_a13, "a13.north")
          line(t_a11, t_a14, "a14.north")

          let lt_4 = ("1", "|-", "a41")
          let ltp_4 = (rel: (0, -1), to: lt_4)
          let b_a41 = (rel: (0, -1), to: "a41")
          let b_a42 = (rel: (0, -1), to: "a42")
          let b_a43 = (rel: (0, -1), to: "a43")
          let b_a44 = (rel: (0, -1), to: "a44")

          line("1", ltp_4, b_a41, "a41")
          line(b_a41, b_a42, "a42")
          line(b_a41, b_a43, "a43")
          line(b_a41, b_a44, "a44")

          line((rel: (-1, 0), to: "lambda"), (rel: (-.5, 0), to: "lambda"), name: "r")
          content("r.start", anchor: "east", padding: 2pt)[$r$]
          line((rel: (0, -1), to: "lambda"), (rel: (0, -.5), to: "lambda"), name: "s")
          content("s.start", anchor: "north", padding: 2pt)[$s$]
        })
  $
]

Wobei $a^((1))_(r i) = lambda dot a_(s i) + 1 dot a_(r i) space square.filled$

=== Beweis Konkatenation Ersetzmatrizen

Das Produkt zwei erster Frobeniusmatrizen $L$ und $L'$ ist:

$
  mat(
    1;
    lambda_2, 1;
    lambda_3, , 1;
    dots.v, , , dots.down;
    lambda_n, , , , 1
  ) dot mat(
    1;
    lambda^'_2, 1;
    lambda^'_3, , 1;
    dots.v, , , dots.down;
    lambda^'_n, , , , 1
  ) = mat(
    1;
    lambda_2 + lambda^'_2, 1;
    lambda_3 + lambda^'_3, , 1;
    dots.v, , , dots.down;
    lambda_n + lambda^'_n, , , , 1
  )
$

Weil $lambda_i -> 1 dot lambda_i + lambda^'_i dot 1$. Das genügt für Matrizen $L^((r,s))$ mit $lambda=0$ für alle außer $lambda_r$.

Eine Matrix $A$ nach oben um $I$ erweitert bleibt unter Multiplikation gleich, daher gilt das nicht nur für die erste Frobeniusmatrix.

$
  mat(
    1;
    , dots.down;
    , , 1;
    , , , A
  ) dot mat(
    1;
    , dots.down;
    , , 1;
    , , , B
  ) = mat(
    1;
    , dots.down;
    , , 1;
    , , , A B
  ) space square.filled
$

=== Beweis Inverse Frobeniusmatrix

Per Definition gilt für die Inverse einer Matrix $L dot L^(-1) = I$. Aus obigem Beweis folgt, dass für die Inverse von $L$ für jedes $lambda$ das additive Inverse $-lambda$ gebildet werden muss, sodass $lambda+lambda'=0$. $square.filled$

=== Beweis Konkatenation Frobeniusmatrizen

Das Produkt $L^((1)) L^((2))$ ist

$
  mat(
    1;
    lambda_(2 1), 1;
    lambda_(3 1), , 1;
    dots.v, , , dots.down;
    lambda_(n 1), , , , 1;
  ) dot mat(
    1;
    , 1;
    , lambda_(3 2), 1;
    , dots.v, , , dots.down;
    , lambda_(n 2), , , , 1
  ) = mat(
    1;
    lambda_(2 1), 1;
    lambda_(3 1), lambda_(3 2), 1;
    dots.v, dots.v, , dots.down;
    lambda_(n 1), lambda_(n 2), , , 1;
  )
$

$lambda_(2 1), ..., lambda_(n 1)$ kommen zustande, weil

$
  mat(1; lambda_(2 1); ...; lambda_(n 1)) dot mat(1, 0, ..., 0) = mat(1; lambda_(2 1); ...; lambda_(n 1))
$

$lambda_(3 2), ..., lambda_(n 2)$ kommen zustande, weil

$
  mat(lambda_(r 1), arrow(0)^T, 1) dot mat(0; 1; arrow(lambda)_(2)) = lambda_(i 2)
$

für jedes $lambda_(i 2)$. $square$

// *Allgemeiner Fall:*
//
// Das Produkt $L^((n)) (L^((n-1)) dot ... dot L^((1)))$ ist
//
// $
//   mat(
//     1;
//     lambda, I
//   ) dot mat(
//     1;
//     0, 1;
//     0, lambda, 1;
//     0, dots.v, dots.down, 1;
//     0, lambda, ..., lambda, 1
//   ) =
//   mat(
//     1, 0;
//     lambda, caron(L)^((n-1))
//   )
// $
//
// weil
//
// $
//   mat(lambda_(r n), arrow(0)^T, 1, arrow(0)^T) dot mat(arrow(0); 1; arrow(lambda)_s) = lambda_(r, s)
// $
//
// Für jede Spalte $n$ und $s<n$.
//
// Gehe induktiv vor, indem die quadratische Teilmatrix ohne erste Spalte und Zeile betrachtet wird. $square.filled$

== LR-Zerlegung mit Pivotisierung

=== Permutationsmatrix

Multiplikation mit $P_(i j)$ vertauscht
- von links Zeilen $i$ und $j$
- von rechts Spalten $i$ und $j$

Konsolidierte Permutationsmatrix $P_pi$ vertauscht von links Zeilen. Um Spalten zu vertauschen, verwende

$
  (P_pi A^T)^T = A P_pi^T
$

=== Beweis L Hut <cr_ue7.2.2>

Aneinandergereihte Permutationen können auch rückgängig gemacht werden:

$
  P_k I P_k^(-1) = I
$

Weil die Spaltenvertauschungen stets mit Spalten $s>k$ arbeiten, können wir das auf $L$ anwenden:
$
  P_k L^((k)) P_k^(-1) "ist eine Frobeniusmatrix" square.filled
$

=== LR-Zerlegung mit Pivotstrategie

Siehe Papier.

$
  L = mat(
    1;
    0, 1;
    -1/2, -1, 1;
    -1/2, 1/2, -1/2, 1
  ) quad quad
  R = mat(
    -2, 2, 0, 0;
    0, 2, -2, 1;
    0, 0, -4, 1;
    0, 0, 0, -2
  )
$

=== Vorwärtselimination und Rücksubstitution

Siehe Papier.

$
  x = vec(2, -1, 0, 5)
$

=== Determinante

Die Determinante einer oberen/unteren Dreiecksmatrix ist das Produkt der Hauptdiagonale.

$
  det(A) & = det(L R) \
         & = det(L) dot det(R) \
         & = det(R) \
         & = -2 dot 2 dot (-4) dot (-2) \
         & = -32
$

#align(end)[2026-06-13]

= Lineare Regression

== Ausgleichsgerade

Modell aufstellen:

$
              A theta & = y \
  mat(x, 1) vec(m, b) & = y \
      mat(
        -1, 1;
        0, 1;
        1, 1;
        2, 1
      ) dot vec(m, b) & = vec(2, 1, 2, 3)
$

Parameter optimieren:

$
      A^T A theta & = A^T y \
  mat(
    -1, 0, 1, 2;
    1, 1, 1, 1
  ) dot mat(
    -1, 1;
    0, 1;
    1, 1;
    2, 1
  ) dot vec(m, b) & = mat(
                      -1, 0, 1, 2;
                      1, 1, 1, 1
                    ) dot vec(2, 1, 2, 3) \
  mat(
    6, 2;
    2, 4
  ) dot vec(m, b) & = vec(6, 8)
$

LGS lösen:

$
  mat(
    augment: #{ -1 },
    6, 2, 6;
    2, 4, 8
  ) --> mat(
    augment: #{ -1 },
    6, 2, 6;
    0, 3 1/3, 6
  ) --> mat(
    augment: #{ -1 },
    6, 0, -4;
    0, 3 1/3, 6
  ) --> mat(
    augment: #{ -1 },
    1, 0, -2/3;
    0, 1, 1 4/5
  )
$

Lösung:

$
      && vec(m, b) & = vec(-2/3, 1 4/5) \
  ==> &&      f(x) & = m x + b \
      &&           & = -2/3 x + 1 4/5
$

== Nichtlineare Problemstellungen

=== Konstante Parameter

$
  f(x) = A sin(omega x + phi_0) + b
$

- Variabel: $A, b$
- Konstant: $omega, phi_0$

=== Modell transformieren

$
  f(x) = 1/(a x + b)
$

Kehrwert bilden.

== Polynomräume

#note(title: [Vektorraum])[
  Ein Vektorraum $V$ erfüllt für alle $v, w, u in V$ folgende Eigenschaften:

  - Addition
    - Abgeschlossenheit (Additiv) $v + w in V$
    - Assoziativ
    - Kommutativ
    - Neutrales Element
    - Inverses Element
  - Multiplikation
    - Abgeschlossenheit (Homogen) $lambda v in V$
    - Distributivgesetz I
    - Distributivgesetz II
    - Assoziativität der Skalare
    - neutrales Element
]

#further[
  #link("https://www.youtube.com/watch?v=TgKwz5Ikpc8")[Vector Space]
]

=== Beweis

$
  PP_n = {a_0 x^0, a_0 x^0 + a_1 x^1, ...}
$

- Addition
  - Additivität: $f, g in PP_n ==> f+g in PP_n$
  - Assoziativität: $(f + g) + h = f + (g + h)$
  - Kommutativität: $f + g = g + f$
  - Neutrales Element: $0 in PP_n$
  - Inverses Element: $f in PP_n ==> exists -f : f + (-f) = 0$
- Multiplikation:
  - Homogenität: $f in PP_n ==> lambda f in PP_n$
  - Assoziativität der Skalare: $lambda (mu f) = (lambda mu) f$
  - Distributiv I: $f dot (lambda + mu) = lambda f + mu f$
  - Distributiv II: $lambda + (f dot g) = (lambda f) + (lambda g)$
  - Neutrales Element: $1 dot f = f, 1 in RR$

  === Beweis Basis

  Jedes Polynom $a_0 x^0 + a_1 x^1 + ... + x_n x^n$ kann durch den Basisvektor dargestellt werden:

  $
    vec(1, x, x^2, dots.v) dot vec(a_0, a_1, dots.v, a_n)
  $

=== Isomorphismus (Bijektive lineare Abbildung)

$
  f : &&                          PP_n & -> RR^n \
      && a_0 + a_1 x^1 + ... + a_n x^n & |-> vec(a_0, a_1, dots.v, a_n)
$

== Lineares Modell

$
  F(x, theta) = d + a x + b x + c x
$

Mit Parametern

$
  a & hat(=)"Apfel" \
  b & hat(=) "Birne" \
  c & hat(=) "Kiwi" \
  d & hat(=) "Europapalette" + "Box"
$

Und Funktionen
$
            f_1 & : x |-> 1 \
  f_2, f_3, f_4 & : x |-> x
$

Masse vom Obst nur bekannt, wenn Masse der leeren Plastikboxen bekannt ist.

#align(end)[2026-06-18]

= Interpolation

== Lagrange-Interpolation

=== Kronecker Delta

1. Fall: $i = j$
$
  ==> && L_(j,n) (x_j) & = product_(k=0,...,n \ k!=j) (x_j-x_k)/(x_j-x_k) \
      &&               & = 1 space square
$

2. Fall: $i != j$

$
  ==> && L_(j, n) (x_i) & = product_(k=0,...,n \ k != j) (x_i - x_k) / (x_j - x_k) quad mark(color: #gray, "beobachte" i in (0, ..., n) ==> exists k = i) \
  && &= ... dot (x_k - x_k)/(x_j - x_k) dot ... \
  && &= 0 space square space square.filled
$

=== Eindeutige Lösung

$
  P(x_i) & = sum_(j=0)^n y_j delta_(i j) = y_i
$

$P(x)$ geht durch alle Stützpunkte, weil $delta_(i j)$ genau dann 1 ist, wenn $i=j$, ansonsten 0. $square$

$deg P <= n$, weil das Produkt des Lagrange-Fundamentalpolynoms höchstens $n$ Glieder hat. $square$

Eindeutigkeit: Annahme: $P != Q$.

$
      &&   D(x) & = P(x) - Q(x) \
  ==> && D(x_i) & = 0 quad forall "Stützpunkte" x_i \
$
$
  ==> &&                  D "hat" n "Nullstellen" \
  ==> && D(x) =0 arrow.zigzag space square.filled
$

== Newton-Basis

// $
//   omega_(j, n) & = product_(0<=i<j) (x-x_i) quad quad 0<=j<=n \
//              e & = vec(
//                    omega_(0, n) & = 1,
//                    omega_(1, n) & = x-x_0,
//                    omega_(2, n) & =
//                  )
// $

Die Newton-Polynome $omega_(j,n)$ bilden genau dann eine Basis des $PP_n$, wenn jedes Polynom als Linearkombination $sum_j lambda_j omega_(j, n)$ dargestellt werden kann.

*Beweis.* Induktion über Grad $m$: $m=0$:

$
  omega_(0, n) = 1
$

Eine Funktion mit Grad 0 ist eine Konstante. Jede Konstante kann als Linearkombination $lambda dot 1$ dargestellt werden. $square$

Induktionsanfang $m=1$:

$
  omega_(1,n) = x-x_0
$

Eine Funktion vom Grad 1 $f(x) = a_0 + a_1 x$ hat einen konstanten Summanden $a_0$, der durch $omega_(0,n)$ dargestellt werden kann (oben gezeigt). Der lineare Teil $a_1 x$ kann wie folgt dargestellt werden:

$
  f(x) & = a_0 + a_1 x \
       & = sum_(j=0)^2 lambda_j omega_(j, n) \
       & = lambda_0 dot 1 + lambda_1 dot (x - x_0) \
       & = lambda_0 + lambda_1 x - lambda_1 x_0 \
       & = underbrace(mark(lambda_1, tag: #<1>), =a_1) x + mark((lambda_0 - lambda_1 x_0), tag: #<0>) \
       & #annot(<0>, pos: right, dx: 24pt)[
           #rect[
             $ lambda_0 - lambda_1 x_0 & = a_0 \
                  lambda_0 - a_1 x_0 & = a_0 \
                            lambda_0 & = a_0 + a_1 x_0 $
           ]
         ]
$

Induktionsvoraussetzung:

$
  sum_(j=0)^(m-1) a_j x^j = sum_(j=0)^(m-1) lambda_j omega_(j, n)
$

Induktionsschritt $m-1 --> m$:

$
  omega_(m, n) & = (x-x_0) dot (x-x_1) dot ... dot (x-x_(m-1)) \
               & =^#footnote[$q(x)$ ist höchstens vom Grad $m-1$.] x^m + q(x)
$

Sei $f(x)$ ein Polynom vom Grad $m$. Wir können zeigen, dass es ein Polynom $h(x)$ gibt, das eine Linearkombination aus Newton-Polynomen ist.

$
  h(x) & = f(x) - a_m dot omega_(m, n) \
       & = (sum_(j=0)^(m) a_j x^j) - a_m dot (x^m + q(x)) \
       & = underbrace((sum_(j=0)^(m-1) a_j x^j), "(IV)") + underbrace(a_m x^m - a_m x^m, =0) + a_m q(x) \
       & = (sum_(j=0) lambda_j omega_(j,n)) + a_m q(x)
$

Zurückschließen auf $f$:

$
  f(x) & = h(x) + a_m dot omega_(m, n) space square.filled
$

== Polynominterpolation

Siehe #link("https://github.com/noahjutz-2026-sose/practice/blob/adf62718c29c2d6b842d26b16b9c3706420bff5b/CR/theorie_09/ue03.m")[CR/theorie_09/ue03.m].

== Grad des Interpolationspolynoms

*Zu zeigen.* $deg P_n <= deg P_(n+1)$

*Beweis.* Das gegenteil würde bedeuten, dass eine Fkt. mit weniger Freiheitsgraden komplexer zu modellieren ist.

*Zu zeigen.* $deg P_(n+1) <= deg P_(n) + 1$

*Beweis.* Wir haben in obiger Induktion gezeigt, dass eine Funktion $f$ durch ein weiteres Newtonpolynom um höchstens einen Grad höher wird.

*Zu zeigen.* $deg P_n = deg P_(n+1) ==> P_n (x_(n+1)) = y_(n+1)$

*Beweis.* Wenn $x_(n+1)$ nicht bereits auf dem Polynom liegt, dann muss der Grad um 1 steigen, weil das Polynom für die Stützpunkte $x_0,...,x_n$ eindeutig ist.
