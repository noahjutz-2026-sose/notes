#import "@preview/gentle-clues:1.3.1": clue

#let example(
  title: "Beispiel",
  icon: [\u{f0208}],
  ..args
) = clue(
  title: title,
  icon: icon,
  accent-color: yellow,
  ..args
)

#let task(
  title: "Aufgabe",
  icon: [\u{f0132}],
  ..args
) = clue(
  title: title,
  icon: icon,
  accent-color: purple,
  ..args
)

#let note(
    title: "Notiz",
    icon: [\u{f03eb}],
    ..args
) = clue(
    title: title,
    icon: icon,
    accent-color: blue,
    ..args
)

#let further(
  title: "Links",
  icon: [\u{f0337}],
  ..args
) = clue(
  title: title,
  icon: icon,
  accent-color: blue,
  ..args
)

#let proof(
  title: "Beweis",
  icon: [\u{f0764}],
  ..args
) = clue(
  title: title,
  icon: icon,
  ..args
)

#let alternative(
  title: "Alternative",
  icon: [\u{f09bb}],
  ..args
) = clue(
  title: title,
  icon: icon,
  ..args
)
