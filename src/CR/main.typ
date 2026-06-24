#import "/template.typ": template_document, template_document_part

#show: template_document.with(doc_title: [SS'26 #sym.dot CR/NMA])

#title[Numerische Mathematik]

#outline(depth: 2)

#pagebreak()

= Notizen

#{
  show: template_document_part
  include "notizen.typ"
}

#pagebreak()

= Übungen

#{
  show: template_document_part
  include "theorie.typ"
}

= Cheatsheet

#{
  show: template_document_part
  include "cheatsheet.typ"
}
