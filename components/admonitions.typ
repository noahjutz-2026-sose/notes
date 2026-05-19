#import "@preview/gentle-clues:1.3.1": clue

#let _ico(body) = text(font: "JetBrainsMono NF", body)

#let _common_args = (
  header-color: white,
  content-inset: 8pt,
  header-inset: 8pt,
  border-width: 0pt,
)

#let example(
  title: "Beispiel",
  icon: _ico[\u{f0208}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  accent-color: yellow,
  .._common_args,
  ..args,
)

#let task(
  title: "Aufgabe",
  icon: _ico[\u{f012c}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  accent-color: purple,
  .._common_args,
  ..args,
)

#let note(
  title: "Notiz",
  icon: _ico[\u{f03eb}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  accent-color: blue,
  .._common_args,
  ..args,
)

#let further(
  title: "Links",
  icon: _ico[\u{f0337}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  accent-color: blue,
  .._common_args,
  ..args,
)

#let proof(
  title: "Beweis",
  icon: _ico[\u{f0764}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  .._common_args,
  ..args,
)

#let alternative(
  title: "Alternative",
  icon: _ico[\u{f09bb}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  .._common_args,
  ..args,
)

#let code(
  title: "Code",
  icon: _ico[\u{f0169}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  accent-color: blue.darken(10%),
  .._common_args,
  ..args,
)

#let definition(
  title: "Definition",
  icon: _ico[\u{f405}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  .._common_args,
  ..args,
)
