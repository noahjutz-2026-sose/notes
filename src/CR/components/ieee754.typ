#let single = n => {
  assert(type(n) == str)
  let zeros = 32 - n.len()
  table(
    columns: (1fr,) * 32,
    align: center,
    table.cell(colspan: 32)[32],
    [1],
    table.cell(colspan: 8)[8],
    table.cell(colspan: 23)[23],
    ..n.clusters(),
    ..(text(fill: gray)[0],) * zeros,
    $s$,
    table.cell(colspan: 8)[$c$],
    table.cell(colspan: 23)[$m$],
  )
}
