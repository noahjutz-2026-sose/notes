#import "/template.typ": template_document, template_document_part

#show: template_document.with(doc_title: [SS'26 #sym.dot BA])

#title[Bachelorarbeit]

#outline()

#pagebreak()

= Grobe Themen

#{
  show: template_document_part
  include "topics.typ"
}

= Ausformulierungen

#{
  show: template_document_part
  include "topics/sim_to_real.typ"
}
