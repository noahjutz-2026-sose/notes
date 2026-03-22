#set heading(numbering: "1.1")
#set page(numbering: "1")

#title[Data Warehousing]

#outline()

#align(end)[2026-03-16 VL01]

= Organisatorisches

- Prüfung
  #[
    #set enum(start: 0)
    + Escape Room
    + Idee Szenario + Präsentation April
    + Peer-Review Szenario
      - Präsentation zuhören und 1-2 Wochen später: Schwächen am Ansatz, was ist gut, ...
    + Workbook
    + Workbook, Power BI Dashboard
  ]
- Übungen
  - 7 Blätter

= Exasol

== OLTP vs OLAP

- OLTP: Online Transaction Processing
  - Viele schnelle queries
- OLAP: Online Analytical Processing
  - Dauert länger
  - Läuft nicht auf der gleichen DB, weil:
    - Stört OLTP queries
    - DW-Schema optimiert für OLAP queries (häufige reads, seltene writes)
    - DW enthält quellübergreifende + historische Daten
    - Spaltenbasiert statt Zeilenbasiert

== Fakten und Dimensionen

- Faktentabelle: 
- Dimensionstabelle: W-Fragen
- ETL: Extract, Transform, Load