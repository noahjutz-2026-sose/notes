#import "/deps.typ": cetz
// - ableitungsregeln
// - logarithmus/exp regeln
//

= Kondition

Wie viel darf der Fehler $delta_x$ eines Messwerts bezüglich der Norm $kappa(x)$ sein, damit die Ausgabe eine relative Genauigkeit von $delta_y$ hat?

$
    delta_x = kappa^(-1) delta_y
$

= Interpolation

== Newton-Schema

#include "figures/newton_schema.typ"

== Newton-Basis-Polynome

#table(columns: 2,
    $i$, $omega_(i,n)$,
    $0$, $1$,
    $1$, $x-x_0$,
    $2$, $(x-x_0)(x-x_1)$,
    $3$, $(x-x_0)(x-x_1)(x-x_2)$
)
