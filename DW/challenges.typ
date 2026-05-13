#import "/components.typ": *

= Escape Room

--

= Presentation

Siehe #link("https://github.com/noahjutz-2026-sose/notes/blob/03435341582ceda5cbd873d8f98df0fd855df142/DW/challenge1_cyberrunner/main.typ")[challenge1_cyberrunner].

= Peer-Review

--

= Datenmodellierung

#note(title: [Quellen])[
  - Bundestagswahlen 1949-2021: https://github.com/ZeitOnline/bundestagswahl-historische-wahlkreis-daten
  - Sitzverteilung 1949-2017: https://germanhistorydocs.org/de/ein-neues-deutschland-1990-2023/distribution-of-seats-in-the-bundestag-1949-2017
  - Abstimmungen 2017-2021: https://dataverse.harvard.edu/file.xhtml?fileId=7666482&version=1.0
    - ```py
      df, meta = pyreadstat.read_dta('~/Downloads/EveryBundestagVote_PartyLevel.dta', encoding='latin1')
      df.to_csv("~/Downloads/df.tsv", sep='\t', index=False, encoding='utf-8')
      ```
  - Politbarometer 1977-2024: https://search.gesis.org/research_data/ZA2391
]

== ME/R Diagramm

#scale(20%, reflow: true)[
  #include "challenge3_schema/mer_diagram.typ"
]

== Measures

#[
  #show table.cell.where(y: 0): strong

  #table(
    columns: 4,
    table.header([Measure], [Data Type], [Range], [Aggregation Type]),
    [wahlbereitschaft], `int`, $1,...,4$, [VPU],
    [skalometer_partei], `int`, $-5,...,5$, [VPU],
    [skalometer_regierung], `int`, $-5,...,5$, [VPU],
    [skalometer_opposition], `int`, $-5,...,5$, [VPU],
    [demokratiezufriedenheit], `int`, $1,...,4$, [VPU],
    [politikinteresse], `int`, $1,...,3$, [VPU],
    [wie_links_rechts], `int`, $1,...,11$, [VPU],
    [wie_links], `int`, $1,...,5$, [VPU],
    [wie_rechts], `int`, $1,...,5$, [VPU],
    [wirtschaft], `int`, $1,...,5$, [VPU],
    [asylrecht], `boolean`, $0, 1$, [FLOW],
    [kernkraft], `boolean`, $0, 1$, [FLOW],
    [kriminalität], `boolean`, $0, 1$, [FLOW],
    [eu_mitgliedschaft], `int`, $1,...,3$, [VPU],
    [milit_bedroht], `boolean`, $0, 1$, [FLOW],
    [jahresrückblick], `boolean`, $0, 1$, [FLOW],
    [jahresausblick], `int`, $1, ..., 3$, [VPU],
    table.hline(stroke: black),
    [sitze], `int`, $1,...,736$, [STOCK],
    table.hline(stroke: black),
    [wahlberechtigte], `int`, $1,...,10^8$, [STOCK],
    [gueltige], `int`, $1,...,10^8$, [FLOW],
    [ungueltige], `int`, $1,...,10^8$, [FLOW],
    [waehlende], `int`, $1,...,10^8$, [FLOW],
    [stimmen], `int`, $1,...,10^8$, [FLOW],
    [anteil], `fraction`, $[0; 1]$, [STOCK],
  )
]
