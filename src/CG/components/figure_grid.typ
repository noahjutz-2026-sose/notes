#let figure_grid(..contents, columns: 5, chunksize: 2) = {
  grid(
    align: center + bottom,
    column-gutter: 16pt,
    row-gutter: 16pt,
    columns: columns,
    ..contents
      .pos()
      .chunks(chunksize)
      .map(c => {
        stack(spacing: 6pt, ..c)
      })
  )
}
