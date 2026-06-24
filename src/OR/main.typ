#import "/template.typ": template_document, template_document_part

#show: template_document.with(doc_title: [SS'26 #sym.dot OR])

#title[Operations Research]

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
