#import "/components/admonitions.typ": *

= Anforderungen an Themen

Eine gute Hypothese ist
- Spezifisch
- Präzise definiert
- Falsifizierbar

Man sollte 3 Fragen beantworten können:
- Welchen Forschungsbeitrag leistet die Arbeit?
- Wie gehe ich vor, um die These zu belegen/wiederlegen?
- Was ist das Problem, das ich lösen möchte?

== Beispiele

#clue[
  Als Hauptspeicher Datenstruktur für große Datenmengen sind Q-Listen schneller und kompakter als P-Listen.

  Annahme: Die Zugriffe sind nicht gleichverteilt: Die Mehrzahl der Zugriffe erfolgt auf einen kleinen Teil der Daten.
]

#clue(title: [KI])[
  Der Einsatz von Transfer Learning reduziert den Trainingsaufwand für medizinische Bildklassifikation auf kleinen Datensätzen (< 500 Bilder) um mindestens 40% im Vergleich zu Training von Grund auf.
]

#clue(title: [SE])[
  GraphQL-APIs führen bei komplexen, verschachtelten Datenanfragen in React-Single-Page-Anwendungen zu einer messbaren Reduktion der Netzwerklast gegenüber REST-APIs im selben Anwendungsfall
]

#clue(title: [DB])[
  Vektordatenbanken (z. B. Pinecone, Weaviate) liefern bei semantischen Suchanfragen über Produktkataloge mit mehr als 500.000 Einträgen niedrigere Antwortzeiten als PostgreSQL mit pg_vector-Erweiterung
]

#clue(title: [VS])[
  Edge-Computing-Ansätze reduzieren die Verarbeitungslatenz von Sensordaten in einem Smart-Home-Szenario mit 20 Geräten gegenüber einer Cloud-only-Architektur um mehr als 70%
]

= Ideen

== CyberRunner

- Remote control and automation
  - Realtime Introspection of RL (foxglove?)
  - Defensive programming: reliable CV, watchdogs, etc.
  - Remote RL control: (re)start train/eval, dump training data, manage standardized datasets
  - Remote HW control: motors, camera
  - Regular Healthchecks: test hardware functionality
- Multiple Labyrinths
  - Kubernetes cluster
  - Node Architecture: GPU Compute, CV, motor control, reload mechanism
  - CI Pipeline for automated runs on release
  - Optimize I/O streams and parallel processing
  - Optimize GPU Computations and determine limitations
  - High Availability: replace nodes quickly
  - (optional) NixOS Anywhere for remote install
- Modularization
  - Bindings for various RL implementations
  - Complete Rewrite: reproducible, expandable, optimized
  - Statistical Analysis of various RL implementations
- Simulation
  - Read masters thesis about CyberRunner in unity
  - Create interface for simulated training to be used IRL
- Multiple balls
  - Complete Rewrite to expand upon
  - CV track multiple objects
  - RL optimization techniques

= Themen

#further[
  #link("https://www.perplexity.ai/search/df560232-2c44-407b-be1b-c23fcd6278b5")[Perplexity Thread]
]

== Cluster

#clue[
  Eine Kubernetes-basierte Multi-Node-Architektur für CyberRunner, die GPU-Compute, Computer Vision und Motorsteuerung in getrennten Pods betreibt, erhöht den effektiven RL-Trainingsdurchsatz (Samples/Stunde) bei gleichzeitigem Betrieb von N $>=$ 3 Labyrinthen linear mit N, ohne dass die I/O-Latenz zwischen CV- und RL-Knoten die kritische Schwelle von 50 ms überschreitet.

  Annahme: Der Flaschenhals im aktuellen System liegt nicht im RL-Algorithmus, sondern in der sequenziellen Verarbeitung von Kameraframes und Motorsteuerung auf einem einzelnen Knoten.
]

== Modularisierung & RL-Algorithmus-Vergleich

#clue[
  Ein einheitliches Interface für RL-Algorithmen im CyberRunner-System, das eine lose Kopplung von Hardware-Abstraktionsschicht, CV-Pipeline und RL-Backends ermöglicht, zeigt, dass verschiedene RL-Implementierungen (z. B. DreamerV3, TD-MPC2, PPO) unter identischen Bedingungen systematisch verglichen werden können und dabei signifikante Unterschiede in Sample-Effizienz, Trainingszeit und End-Performance aufweisen
]

== g
