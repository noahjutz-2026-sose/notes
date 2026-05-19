#import "@preview/gentle-clues:1.3.1": clue

#let _common_args = (
  header-color: white,
  content-inset: 8pt,
  header-inset: 8pt,
  border-width: 0pt,
)

#let example(
  title: "Beispiel",
  icon: [\u{f0208}],
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
  icon: [\u{f0132}],
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
  icon: [\u{f03eb}],
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
  icon: [\u{f0337}],
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
  icon: [\u{f0764}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  .._common_args,
  ..args,
)

#let alternative(
  title: "Alternative",
  icon: [\u{f09bb}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  .._common_args,
  ..args,
)

#let code(
  title: "Code",
  icon: [\u{f0169}],
  ..args,
) = clue(
  title: title,
  icon: icon,
  accent-color: blue.darken(10%),
  .._common_args,
  ..args,
)
