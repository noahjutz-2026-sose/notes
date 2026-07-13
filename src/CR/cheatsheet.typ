#import "/deps.typ": cetz
// - ableitungsregeln
// - logarithmus/exp regeln
// - lin. Ausgleichsproblem und rank

= Fehler und Kondition

Wie viel darf der Fehler $delta_x$ eines Messwerts bezüglich der Norm $kappa(x)$ sein, damit die Ausgabe eine relative Genauigkeit von $delta_y$ hat?

$
  delta_x = kappa^(-1) delta_y
$

== IEEE 754

#table(columns: 3,
    [], $m=0$, $m!=0$,
    $c=0$, $plus.minus 0$, $plus.minus (bold(0)+m) dot 2^(-126)$,
    $c=255$, $plus.minus infinity$, [NaN],
    $0<c<255$, $plus.minus 1 dot 2^e$, $plus.minus (1+m) dot 2^e$
)

= Mehrdimensionale Ableitung

#grid(
  columns: 2,
  column-gutter: 12pt,
  table(
    columns: 2,
    table.header(table.cell(colspan: 2)[Ableitungsregeln]),
    $ (f + g)' $, $ f' + g' $,
    $ (f g)' $, $ f' g + f g' $,
    $ (f / g)' $, $ (f' g - f g')/g^2 $,
    $ (f compose g)' $, $ g'(f) f $,
  ),

  table(
      columns: 2,
      table.header(table.cell(colspan: 2)[Ableitungen]),
      $ sin $, $ cos $,
      $ cos $, $ -sin $,
      $ tan $, $ 1/cos^2 $,
      $ a^x $, $ a^x ln a $,
      $ ln x $, $ 1/x $
  )
)

= Interpolation

== Newton-Schema

#include "figures/newton_schema.typ"

== Newton-Basis-Polynome

#table(
  columns: 2,
  $i$, $omega_(i,n)$,
  $0$, $1$,
  $1$, $x-x_0$,
  $2$, $(x-x_0)(x-x_1)$,
  $3$, $(x-x_0)(x-x_1)(x-x_2)$,
)
