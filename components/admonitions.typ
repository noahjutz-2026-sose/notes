#import "/deps.typ": gentle-clues.clue
#import "/components/utils.typ": i

#let _common_args = (
  header-color: white,
  content-inset: 8pt,
  header-inset: 8pt,
  border-width: 0pt,
)

#let example(
  title: "Beispiel",
  icon: i("eye"),
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
  icon: i("check"),
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
  icon: i("pencil"),
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
  icon: i("link"),
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
  icon: i("variable"),
  ..args,
) = clue(
  title: title,
  icon: icon,
  .._common_args,
  ..args,
)

#let alternative(
  title: "Alternative",
  icon: i("arrow-turn-down-right"),
  ..args,
) = clue(
  title: title,
  icon: icon,
  .._common_args,
  ..args,
)

#let code(
  title: "Code",
  icon: i("code-bracket"),
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
  icon: i("book-open"),
  ..args,
) = clue(
  title: title,
  icon: icon,
  .._common_args,
  ..args,
)

#let info(
  title: [Info],
  icon: i("information-circle"),
  ..args,
) = clue(
  title: title,
  icon: icon,
  accent-color: color.teal,
  .._common_args,
  ..args,
)
