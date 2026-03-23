#import "/template.typ": template

#import "@preview/cetz:0.4.2"

#show: template

#title[Data Warehousing]
Notizen

#outline()

#align(end)[2026-03-16 VL01]

= Organisatorisches

- Prüfung
  #table(columns: 5,
      [], [Challenge], [Punkte], [Deadline], [Informationen],
      [0], [Escape Room], [5], [], [
          - Laptop + DBeaver + Fortinet VPN
          - 90min
          - Slot wählen in KW13
      ],
      [1], [Szenario], [], [], [],
      [2], [Peer-Review], [], [], [],
      [3], [], [], [], [Workbook],
      [4], [], [], [], [
          - Workbook
          - Power BI Dashboard
      ]
  )
- Übungen
  - 7 Blätter

= Einführung in Data Warehousing

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

- _Faktentabelle_:
- _Dimensionstabelle_: W-Fragen
- _ETL_: #strong[E]xtract, #strong[T]ransform, #strong[L]oad

#align(end)[2026-03-23 VL02]
== Eigenschaften von Data Warehouses

- _subject-oriented_: Kunden, Produkte, Aktivitäten
- _integrated_: Aus mehreren Quellen
- _non-volatile_: Daten sind statisch
- _time-variant_: Mehrere Snapshots mit Timestamps


== Architektur
- _Data Mart_: View oder Kopie eines Data Warehouses
