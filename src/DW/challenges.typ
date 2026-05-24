#import "/components/admonitions.typ": *
#import "/deps.typ": codly

= Escape Room

--

= Presentation

Siehe #link("https://github.com/noahjutz-2026-sose/notes/blob/03435341582ceda5cbd873d8f98df0fd855df142/DW/challenge1_cyberrunner/main.typ")[challenge1_cyberrunner].

= Peer-Review

--

= Schema Integration & Import

== Schema Integration

#stack(dir: ltr)[=== ][=== Data Schema ]

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

=== Exasol

Siehe #link("https://github.com/noahjutz-2026-sose/practice/blob/5afa6df1741d2c004f5998ba7f6f2d0e346a06de/DW/challenges/ch3_import.sql#L6-L98")[DW/ch3_import.sql].

=== Heterogeneity

#table(
  columns: 2,
  table.header([*Type*], [*Example*]),
  [Technical Heterogeneity],
  [
    - Politbarometer: DTA
    - Bundestag: CSV
    (After Conversion DTA #sym.arrow CSV no heterogeneity)
  ],

  [Syntactic Heterogeneity],
  [
    - Politbarometer: Party represented as number (e.g. 1=CDU)
    - Bundestags: Party represented by shortname (e.g. linke=Die Linke/PDS)
  ],

  [Semantic Heterogeneity],
  [
    - Politbarometer: CDU/CSU treated separately
    - Bundestagswahl: Union=CDU+CSU
  ],

  [Schematic Heterogeneity],
  [
    - Politbarometer: One Column per party (e.g. rating_linke)
    - Bundestag: One Row per party (e.g. party=linke)
  ],
)

=== Schema Matching

#table(
  columns: 3,
  table.header([*Bundestag_Election*], [*Politbarometer (Rating)*], [*Politbarometer (Intended Vote)*]),
  [union], [v9_rating_cdu + v10_rating_csu], [1],
  [afd], [v13_rating_afd], [322],
  [spd], [v8_rating_spd], [4],
  [gruene], [v12_rating_gruene], [6],
  [linke], [v14_rating_linke], [7],
  [fdp], [v11_rating_fdp], [5],
  [...],
)

== Import

#stack(dir: ltr)[=== ][=== Import]

#further(title: [Docs])[
  https://docs.exasol.com/db/latest/sql/import.htm
]

Siehe DW/challenges/ch3_import.sql.

=== Import

#further(title: [Docs])[
  https://docs.exasol.com/db/latest/sql_references/system_tables/metadata/exa_all_object_sizes.htm
]
