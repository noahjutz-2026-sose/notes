#let top-level-label = state("top-level-label", "")

#set heading(numbering: (..n) => {
  let nums = n.pos()
  let top = top-level-label.get()
  if nums.len() == 1 {
    top
  } else {
    top + "." + nums.slice(1).map(str).join(".")
  }
})

#let h1(label, title) = {
  top-level-label.update(label)
  heading(level: 1, title)
}

#h1("SS22")[]
