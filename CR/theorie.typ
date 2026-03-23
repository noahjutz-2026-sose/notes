#import "/template.typ": template
#import "/components.typ": *

#show: template

#set heading(numbering: "1.1")

#title[Numerische Mathematik]

Theorie-Übungen #sym.dot 2026 SoSe #sym.dot Noah Jutz

#outline(depth: 2)

= Fehler und Kondition

== Wiederholung

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
Delta_y &=^dot kappa_"abs" (x) dot Delta_x \
&= abs(g dot x) dot Delta_x \
&= abs(10 dot 2) dot 0.01 \
&= 0.2
$

Wir müssen mit einem Ausgabefehler von $0.2 "m"$ rechnen.

#alternative[
  Wenn wir von einem Messwert $tilde(x) = 2.01$ ausgehen.
  $
  Delta_y &= abs(f(tilde(x))-f(x)) \
  &= abs(h(2.01) - h(2)) \
  &= abs((1/2 dot 10 dot 2.01^2) - (1/2 dot 10 dot 2^2)) \
  &= abs(20.2005-20) \
  &= 0.2005
  $
  Der Ausgabefehler ist exakt $0.2005 "m"$.
]

=== Gegeben Ausgabefehler Zeit maximieren

#table(columns: 2,
  [Allgemein], [Dieses Problem],
  $y = f(x)$, $y = h(t)$,
)

Wir gehen wieder davon aus, dass $forall t : Delta_t = 0.01$.

Gesucht sind alle Eingabewerte $t$, für die der Ausgabefehler kleiner als $1 "m"$ ist.

$
Delta_y &< 1 \
kappa_"abs" (t) dot Delta_t &< 1 \
abs(g t) dot 0.01 &< 1 \
abs(g t) &< 100 \
g t &< 100 \
t &< 100 / g \
t &< 100 / 10 \
t &< 10
$

Unter $t=10 "s"$ bleibt der Ausgabefehler $h < 1 "m"$.

#alternative[
  Wenn wir davon ausgehen, dass der Messfehler $Delta_t$ der Stoppuhr proportional zur Zeit $t$ steigt.

  $
  Delta_t = 0.01 dot t/2
  $

  Gesucht sind alle Eingabewerte $t$, für die der Ausgabefehler kleiner als $1 "m"$ ist.

  $
  Delta_y &< 1 \
  kappa_"abs" (h) dot Delta_t &< 1 \
  abs(g t) dot (0.01 dot t/2) &< 1 #text(gray)[$space g t$ ist nie negativ] \
  0.005 g t^2 &< 1 \
  t &< sqrt(200/g) \
  t &< sqrt(200/10) \
  t &< sqrt(20) "s"
  $
]

=== Gegeben Ausgabefehler Messfehler maximieren

- Gegeben: $delta_y <= 5%$ und Problem $h(t)$
- Gesucht: $delta_t$

$
delta_y &=^dot kappa_"rel" (t) dot delta_t \
<=> delta_t &= delta_y/(kappa_"rel" (t)) \
&= (5%)/2 \
&= 2.5%
$

Der Eingabefehler darf maximal $2.5%$ sein, sodass der Ausgabefehler $5%$ ist.

== Schlecht konditionierte Abbildungen

Siehe Skript-Aufgabe 1.4

== Kondition differenzierbarer Funktionen

Siehe Skript-Aufgabe 1.7
