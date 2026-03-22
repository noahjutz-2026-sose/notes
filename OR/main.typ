#import "@preview/gentle-clues:1.3.1": *

#set heading(numbering: "1.1")
#set page(numbering: "1")
#set text(lang: "de")

#show math.equation: set text(font: "Fira Math")

#title[Operations Research]

#outline()

#align(end)[2026-03-19 VL01]

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
x &:= "Menge" \
g &:= "Gewinn"
$

#grid(columns: 2 * (1fr,),
  $
  P_1 &:= "Sneaker" \
  x_1 &= space ? \
  g_1 &= 10 euro \
  $,
  $
  P_2 &:= "Stiefel" \
  x_2 &= space ? \
  g_2 &= 20 euro \ \
  $
)

Zielfunktion

$
F(x_1, x_2) &:= 10 x_1 + 20 x_2
$

Nebenbedingungen

$
x_1 + x_2   &<= 100 \
6x_1 + 9x_2 &<= 720 \
x_1, x_2    &>= 0
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


#info(title: [Symbole])[
  - Entscheidungsvektor $x$ (beinhaltet Schlupfvariablen)
  - Zielfunktionsvektor $c$ (z.B. Gewinn, Zeit)
]

#align(end)[2026-03-25 VL02]