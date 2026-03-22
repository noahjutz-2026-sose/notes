#import "@preview/codly:1.3.0"

#set heading(numbering: "1.1")

#show math.equation: set text(font: "Fira Math")

#show: codly.codly-init

#codly.codly(number-format: none)

#title[Numerische Mathematik]

Praktikum

#outline()

= 

== Kommutativ

$
a + b + d + e + c &= -10 \
a + b + c + d + e &= 0 \
a + e + b + c + d &= 137 space checkmark \
e + c + a + b + d &= 147 \
$

== Matrizen und Vektoren

#columns(4)[
  ```
  A * A FAIL
  A * B FAIL
  A * C
  A * e_1 FAIL
  A * e_2 FAIL
  A * v FAIL
  A * w
  B * A FAIL
  B * B FAIL
  B * C
  B * e_1 FAIL
  B * e_2 FAIL
  B * v FAIL
  B * w
  C * A FAIL
  C * B FAIL
  C * C
  C * e_1 FAIL
  C * e_2 FAIL
  C * v FAIL
  C * w
  e_1 * A FAIL
  e_1 * B FAIL
  e_1 * C FAIL
  e_1 * e_1 FAIL
  e_1 * e_2 FAIL
  e_1 * v
  e_1 * w FAIL
  e_2 * A FAIL
  e_2 * B FAIL
  e_2 * C FAIL
  e_2 * e_1 FAIL
  e_2 * e_2 FAIL
  e_2 * v
  e_2 * w FAIL
  v * A FAIL
  v * B FAIL
  v * C
  v * e_1 FAIL
  v * e_2 FAIL
  v * v FAIL
  v * w
  w * A FAIL
  w * B FAIL
  w * C FAIL
  w * e_1 FAIL
  w * e_2 FAIL
  w * v
  w * w FAIL
  A + A
  A + B
  A + C FAIL
  A + e_1
  A + e_2
  A + v
  A + w FAIL
  B + A
  B + B
  B + C FAIL
  B + e_1
  B + e_2
  B + v
  B + w FAIL
  C + A FAIL
  C + B FAIL
  C + C
  C + e_1 FAIL
  C + e_2 FAIL
  C + v
  C + w
  e_1 + A
  e_1 + B
  e_1 + C FAIL
  e_1 + e_1
  e_1 + e_2
  e_1 + v
  e_1 + w FAIL
  e_2 + A
  e_2 + B
  e_2 + C FAIL
  e_2 + e_1
  e_2 + e_2
  e_2 + v
  e_2 + w FAIL
  v + A
  v + B
  v + C
  v + e_1
  v + e_2
  v + v
  v + w
  w + A FAIL
  w + B FAIL
  w + C
  w + e_1 FAIL
  w + e_2 FAIL
  w + v
  w + w
  ```
]

== Lineare Gleichungssysteme

```matlab
A = [3 2 -6
     1 -1 2
     4 -1 -3];

b = [1; 8; 3];

x=A\b % [5; 4; 4]
```

== Plotten