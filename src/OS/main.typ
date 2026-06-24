#import "/template.typ": template_document, template_document_part

#show: template_document.with(doc_title: [SS'26 #sym.dot OS])

#title[Betriebssysteme]

#outline()

#pagebreak()

= Notizen

#{
  show: template_document_part
  include "notizen.typ"
}
