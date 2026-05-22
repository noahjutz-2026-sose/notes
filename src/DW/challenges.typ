#import "/components/admonitions.typ": *
#import "/deps.typ": codly

= Escape Room

--

= Presentation

Siehe #link("https://github.com/noahjutz-2026-sose/notes/blob/03435341582ceda5cbd873d8f98df0fd855df142/DW/challenge1_cyberrunner/main.typ")[challenge1_cyberrunner].

= Peer-Review

--

= Schema Integration

#stack(dir: ltr)[== ][== Data Schema ]

#table(
  columns: 2,
  table.header([Quelle], link("search.gesis.org/research_data/ZA2391")[Politbarometer]),
  [Lizenz], [Educational Use Only],
  [Originalformat], [DTA],
  [Format], [CSV, charset=us-ascii, delim=`\t`, LF],
)

#table(
  columns: 2,
  table.header(
    [Quelle],
    link(
      "https://github.com/ZeitOnline/bundestagswahl-historische-wahlkreis-daten",
    )[bundestagswahl-historische-wahlkreis-daten],
  ),
  [Lizenz], [CC-BY-SA-4.0],
  [Originalformat], [CSV, charset=utf-8, delim=`,`, LF],
)

#table(
  columns: 2,
  table.header(
    [Quelle],
    link(
      "https://commons.wikimedia.org/wiki/Data:Germany_federal_elections/Seat_distribution_in_the_Bundestag.tab",
    )[Wikimedia Seat distribution in the Bundestag],
  ),
  [Lizenz], [CC0],
  [Originalformat], [CSV, charset=utf-8, delim=`,`, LF],
)

#table(
  columns: 2,
  table.header([Quelle], link("https://www.bundestag.de/services/opendata/")[Stammdaten Abgeordnete]),
  [Lizenz], ["Open Data"],
  [Originalformat], [XML, charset=utf-8],
)

== Exasol

Siehe #link("https://github.com/noahjutz-2026-sose/practice/blob/5afa6df1741d2c004f5998ba7f6f2d0e346a06de/DW/challenges/ch3_import.sql#L6-L98")[DW/ch3_import.sql].

== Heterogeneity
