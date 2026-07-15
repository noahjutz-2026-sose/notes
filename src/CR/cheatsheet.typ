#import "/deps.typ": cetz
#import "/components/admonitions.typ": *
#import "/style.typ": *

#show table.cell.where(y: 0): strong

#let qa(..content) = grid(
  columns: 2,
  task(title: none, content.pos().at(0)), proof(title: none, content.pos().at(1)),
)

#let ieee_last_digits(mth) = {
  let entries = mth.codepoints()
  entries = entries.map(c => if c.match(regex("\d")) != none { c } else { sym.dot })
  return $
    mono(
      #entries.slice(0, -2).join()
      text(#colors.primary.normal, #entries.remove(-2))
      text(#colors.on_surface.light, #entries.remove(-1))
    )
  $
  return repr(mth)
}

#grid(
  columns: 3,
  column-gutter: 12pt,
  table(
    columns: 2,
    table.header(table.cell(colspan: 2)[Ableitungsregeln]),
    $ (f + g)' $, $ f' + g' $,
    $ (f g)' $, $ f' g + f g' $,
    $ (f / g)' $, $ (f' g - f g')/g^2 $,
    $ (f compose g)' $, $ g'(f) f' $,
  ),

  table(
    columns: 2,
    table.header(table.cell(colspan: 2)[Ableitungen]),
    $ sin $, $ cos $,
    $ cos $, $ -sin $,
    $ tan $, $ 1/cos^2 $,
    $ a^x $, $ a^x ln a $,
    $ ln x $, $ 1/x $,
  ),
  table(
    columns: 2,
    table.header(table.cell(colspan: 2)[Logarithmusregeln]),
    $ log(x y) $, $ log(x) + log(y) $,
    $ log(1/x) $, $ -log(x) $,
    $ log(x^r) $, $ r log(x) $,
  ),
)


= Fehler und Kondition

#qa[
  Wie viel darf der Fehler $delta_x$ eines Messwerts bezüglich der Norm $kappa(x)$ sein, damit die Ausgabe eine relative Genauigkeit von $delta_y$ hat?
][
  $
    delta_x = kappa^(-1) delta_y
  $
]

== IEEE 754

#grid(
  columns: 2,
  column-gutter: 12pt,
  table(
    columns: 3,
    table.header(table.cell(colspan: 3)[Reservierte Zahlen]),
    [], $m=0$, $m!=0$,
    $c=0$, $plus.minus 0$, $plus.minus (bold(0)+m) dot 2^(-126)$,
    $c=255$, $plus.minus infinity$, [NaN],
    $0<c<255$, $plus.minus 1 dot 2^e$, $plus.minus (1+m) dot 2^e$,
  ),

  {
    let ieee = ieee_last_digits
    let ceil = $ceil(dot)$
    let floor = $floor(dot)$

    table(
      columns: 3,
      fill: (x, y) => if y == 4 { colors.secondary.lighter } else {},
      table.header(table.cell(colspan: 3)[Round to even]),
      $
        d_(m-1)
        text(#colors.primary.normal, d_m)
        text(#colors.on_surface.light, d_(m+1))
      $,
      ieee("1xx"),
      ieee("0xx"),
      ieee("x00"), floor, floor,
      ieee("x01"), floor, floor,
      ..(ieee("x10"), ceil, floor),
      ieee("x11"), ceil, ceil,
    )
  },
)


#table(
    columns: 5,
    table.header(table.cell(colspan: 5)[Rechenregeln]),
    [Operation], $s$, $c$, $m$, $N$,

    [Allg.],
    [],
    $c + N$,
    $(1+m_x) ast.op.o (1+m_y) dot 2^(-N)$,
    [],

    $x dot 2^n$,
    $=$,
    $c + n$,
    $=$,
    sym.slash,

    $x slash 2^n$,
    $=$,
    $c-n$,
    $=$,
    sym.slash,

    $x dot y$,
    $s_x xor s_y$,
    $c_x + c_y - 127 + N$,
    [],
    $ =cases(1 "falls" m<-10.dots.c, 0 "falls" m<-1.dots.c) $,

    $x slash y$,
    $s_x xor s_y$,
    $c_x - c_y + 127 - N$,
    [],
    $ =cases(0 "falls" m<-1.dots.c, 1 "falls" m<-0.dots.c) $,

    $x + y$,
    $s_max$,
    $c_max + N$,
    $((1+m_max) plus.minus (1+m_min) dot 2^(-abs(c_x-c_y))) dot 2^(-N)$,
    $ =cases(-x "falls" m<-0.dots.c, 1 "falls" m<-10.dots.c, 0 "falls" m<-1.dots.c) $,
)


= Regression

#qa[
  Wie viele Messungen werden mindestens benötigt, damit alle Parameter des Modells eindeutig bestimmt werden können?
][
  Anzahl Parameter $abs(theta)$ (Messungen müssen linear unabhängig sein).
]

= Interpolation

== Newton-Schema

#include "figures/newton_schema.typ"

== Basispolynome

#grid(
  columns: 1,
  gutter: 12pt,
  table(
    columns: 2,
    table.header(table.cell(colspan: 2)[Newton-Basis-Polynome]),
    $j$, $omega_(j,n)$,
    $0$, $1$,
    $1$, $x-x_0$,
    $2$, $(x-x_0)(x-x_1)$,
    $3$, $(x-x_0)(x-x_1)(x-x_2)$,
  ),
  table(
    columns: 8,
    column-gutter: (0pt, 12pt, 0pt, 12pt, 0pt, 12pt, 0pt),
    table.header(table.cell(colspan: 8)[Lagrange-Fundamentalpolynome]),
    $L_(0,0)$, $ 1 $,
    $L_(0,1)$, $ (x-x_1)/(x_0-x_1) $, $L_(0,2)$, $ (x-x_1)/(x_0-x_1) dot (x-x_2)/(x_0-x_2) $,
    $L_(0,3)$, $ (x - x_1)/(x_0 - x_1) dot (x - x_2)/(x_0 - x_2) dot (x - x_3)/(x_0 - x_3) $,

    table.cell(colspan: 2, stroke: none)[],
    $L_(1,1)$, $ (x-x_0)/(x_1-x_0) $, $L_(1,2)$, $ (x-x_0)/(x_1-x_0) dot (x-x_2)/(x_1-x_2) $,
    $L_(1,3)$, $ (x - x_0)/(x_1 - x_0) dot (x - x_2)/(x_1 - x_2) dot (x - x_3)/(x_1 - x_3) $,

    table.cell(colspan: 2, stroke: none)[],
    table.cell(colspan: 2, stroke: none)[],
    $L_(2, 2)$, $ (x-x_0)/(x_2-x_0) dot (x-x_1)/(x_2-x_1) $,
    $L_(2,3)$, $ (x - x_0)/(x_2 - x_0) dot (x - x_1)/(x_2 - x_1) dot (x - x_3)/(x_2 - x_3) $,

    table.cell(colspan: 2, stroke: none)[],
    table.cell(colspan: 2, stroke: none)[],
    table.cell(colspan: 2, stroke: none)[],
    $L_(3,3)$, $ (x - x_0)/(x_3 - x_0) dot (x - x_1)/(x_3 - x_1) dot (x - x_2)/(x_3 - x_2) $,
  ),
)

== Kubische Splines

Ableitungen

$
    s(x) & = a_0 & + & a_1 x & + & a_2 x^2 & + & a_3 x^3 \
   s'(x) & =     &   & a_1   & + & 2 a_2 x & + & 3 a_3 x^2 \
  s''(x) & =     &   &       &   & 2 a_2   & + & 6 a_3 x
$

Bedingungen

$
   s_L^' (x_i) & = s_R^' (x_i)  & <==> && a_1 + 2a_2 x_i + 3a_3 x_i^2 & = b_1 + 2 b_2 x_i + 3 b_3 x_i^2 \
  s_L^'' (x_i) & = s_R^'' (x_i) & <==> &&             2a_2 + 6a_3 x_i & = 2b_2 + 6b_3 x_i \
        s''(x) & = 0            & <==> &&               2a_2 + 6a_3 x & = 0
$
