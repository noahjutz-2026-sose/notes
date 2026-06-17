#let top_bottom_box(content, title: []) = {
  table(
    columns: (1fr,),
    table.header(table.cell(align: center, strong(title))),
    content,
    table.footer(table.cell(align: center, strong(title))),
  )
}
