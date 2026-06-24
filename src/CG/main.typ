#import "/template.typ": template_document, template_document_part
#show: template_document.with(doc_title: [CG #sym.dot SS'26])

#title[Computergrafik]

#outline()

#pagebreak()

= Notizen

#{
  show: template_document_part
  include "notizen.typ"
}

#pagebreak()

= Zusammenfassung

#{
  show: template_document_part
  include "summary.typ"
}

#pagebreak()

= Übungen

#{
  show: template_document_part
  include "uebungen.typ"
}
