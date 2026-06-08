#import "/template.typ": template, template_exercises

#show: template.with(doc_title: [SS'26 #sym.dot BA])

#title[Bachelorarbeit]

#outline()

#pagebreak()

#include "topics.typ"

#show: template_exercises.with(prefix: "T")

#include "topics/sim_to_real.typ"
