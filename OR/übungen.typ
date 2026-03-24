#import "/template.typ": template

#show: template
#set heading(numbering: "1.1")

#title[Operations Research]

Übungen

#outline(depth: 2)

#align(end)[2026-03-23 TT01]

= Grundlegende Modellierung

== Produktionsplanung

Siehe #link("https://github.com/noahjutz-2026-sose/or-ue01")[or-ue01/excel_solver.xlsx]

== Automobilproduktion

*Produkte*
$
P_1 = L space.quad ; space.quad
P_2 = K
$

*Koeffizienten:* Gewinn
$
c_1=2000 euro space.quad ; space.quad
c_2=3000 euro
$

*Variablen*
$
x_1 := "Anzahl" P_1 space.quad ; space.quad
x_2 := "Anzahl" P_2 space.quad ; space.quad
x_3, x_4 := "Schlupfvariablen"
$

*Zielfunktion*

$
F(x_1, x_2) = sum_(i=0)^p c_i x_i = 2000 x_1 + 3000 x_2
$

*Nebenbedingungen:* Kapazität PT
$
3 x_1 + 5 x_2 + x_3 &= 180 "(Vormontage)" \
3 x_1 + 3 x_2 + x_4 &= 135 "(Endmontage)"
$

=== Matrixform

$
c = vec(2000, 3000) space.quad ; space.quad
x = vec(x_1, x_2, x_3, x_4) space.quad ; space.quad
A = mat(
    3, 5, 1, 0;
    3, 3, 0, 1
) space.quad ; space.quad
b = vec(180, 135) space.quad ; space.quad
F(x) = c^T x
$

== Python

- Google OR-Tools: #link("https://github.com/noahjutz-2026-sose/or-ue01")[or-ue01/ue1-3a]
- Scipy: #link("https://github.com/noahjutz-2026-sose/or-ue01")[or-ue01/ue1-3b]
