#import "/template.typ": template_document, template_document_part

#show: template_document.with(doc_title: [DW #sym.dot SS'26])

#title[Data Warehousing]

#outline()

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
  include "uebungen.typ"
}

#pagebreak()

= Challenges

#{
  show: template_document_part
  include "challenges.typ"
}
