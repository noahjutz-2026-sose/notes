#import "/components/admonitions.typ": *

= Sim-to-Real transfer

#clue(title: [Hypothese])[
  Ein an einem digitalen Zwilling trainiertes Modell kann an einen physischen Labyrinth-Roboter übergeben werden und innerhalb von weniger als 60 Minuten fine-tuning das Spiel lösen. Dabei erreicht es eine Durchlaufzeit, die maximal 15% schlechter ist als ein vollständig auf der Hardware trainiertes Modell.

  Annahme: Die Leistungsdifferenz eines Modells zwischen der virtuellen Simulation und der echten Welt ist auf physikalische Parametervarianz zurückzuführen, nicht auf fundamentale Modelllimitierungen.
]

== Warum ist das Phänomen interessant?
- #[
    Reinforcement Learning in der Robotik ist ein aktuelles Forschungsthema, das Probleme in Transport, Logistik, usw. lösen kann.
  ]
- #[
    KI-Demonstratoren kommunizieren Wissenschaftliche Tätigkeiten an die Allgemeinheit. Vereinfachungen und Verbesserungen können nicht-Wissenschaftlern eine eigene Inbetriebnahme ermöglichen und das Thema greifbarer machen.
  ]

== Problem, Ziel und Kohärenz

*Problem.* In RL, das auf physischen Systemen basiert, ist das physische System normalerweise der Bottleneck. Aufbau, Wartung und Inbetriebnahme brauchen Zeit. Physikalische Begrenzungen wie die Beschleunigung der Kugel führen zu deutlich längeren Episoden im Vergleich zu digitalem RL. Parallelisierung erfordert mehrere physische Systeme, das kostet Zeit und Geld.

*Ziel.* Beschleunigung des Trainings durch übertragung eines Simulationsmodells auf das physische System. Wenn ein Sim-Modell mit unter 60 min fine-tuning an einem physischen System funktioniert und höchstens 15% langsamer als ein rein physisches Modell ist, ist das Ziel erreicht.

*Kohärenz.* Die Disziplinen der Arbeit sind RL, Simulation, Robotik und Software Engineering. Sie hängen durch die Problemstellung zusammen.

== Forschungsbeitrag und Auswirkungen der Hypothese

*Zentrale Quellen.*
- CyberRunner. https://doi.org/10.48550/arXiv.2312.09906
- DreamerV3. https://doi.org/10.1038/s41586-025-08744-2
- Labyrinth Unity-Simulation (Master-Arbeit OTH Regensburg)

*Ähnliche Arbeiten.* Sim-to-Real transfer bei RL wurde häufig und ausführlich erforscht.
- Sim-to-Real tranfer anhand Marble maze game. https://doi.org/10.1109/ICRA.2019.8793561
- Sim-to-Real transfer mit Dreamer. https://doi.org/10.3389/frobt.2025.1655171

*Alleinstellungsmerkmal.* Sim-to-Real transfer wurde noch nicht an einem Labyrinth-Kugelspiel erforscht, welches Löcher hat, durch die die Kugel fallen kann.

== Hinterfragung der Hypothese

- #[
    Es wird keine Kamera simuliert. Die mangelnde Latenz der Kamera und CV pipeline wird das Modell unbrauchbar machen. Dazu kommt die Ungenauigkeit der Positionserkennung im physischen System.

    *Gegenargument.* Latenz und Varianz können simuliert werden.
  ]
- #[
    Physikalische Eigenschaften wie Reibung und reale Verhältnisse wie eine unebene Spielfläche können nicht realistisch in der Simulation abgebildet werden.

    *Gegenargument.* Diese Probleme werden in bestehenden Papers über Sim-to-Real transfer gelöst.
  ]
- #[
    Die Observation enthält in der CyberRunner-Implementierung ein Kamerabild. Wie soll Dreamer ein World Model ohne dieses trainieren?

    *Gegenargument.* Kamerabild ist nicht zwingend notwendig, um das Labyrinth zu lösen, weil Reward auf festem Zielpfad basiert.

    Dann kann das simulierte Modell aber nicht auf andere Labyrinth-Layouts angewandt werden.

    *Gegenargument.* Das ist außerhalb des Rahmens der Arbeit.
  ]

== Annahmen

- #[
    Die Unity-Simulation liefert ein Modell, das im Cyberrunner-Projekt verwendet werden kann

    oder

    Die Unity-Simulation kann entsprechend verändert werden

    oder

    Das Cyberrunner-Projekt kann entsprechend verändert werden
  ]
- Die Simulation verwendet für das Reinforcement Learning ähnliche Observations (Ball-Position, Brettwinkel)
- Das Kamerabild ist in der Observation nicht notwendig
- Das Modell kann fine-tuned werden

== Methodik

*Kontrollgruppe.*
- Evaluation CyberRunner ohne Simulation
- Evaluation reine Simulation

*Entwicklung.*
- Entwicklung einer Kompatibilitätsschicht oder Adaption des CyberRunners
- ggf. Evaluation des adaptierten CyberRunners
- Evaluation des simulierten Modells auf physischer Hardware

*Optimierung.*
- Fine-tuning des Modells
- Domain-Randomisierung der Simulation
- Optimierung Hyperparameter

== Hinterfragung der Methodik

- #[
    Training der Kontrollgruppe ist zu aufwendig.

    *Gegenargument.* Durch Optimierungen in der Mechanik und paralleles Training von mehreren physische Systeme kann es bewältigt werden.
  ]
- #[
    Vergleichbarkeit: Wenn unterschiedliche Algorithmen verwendet werden, ist unklar, ob Sim-to-Real-Erfolg am Wissenstransfer oder am Algorithmus liegt.

    *Gegenargument.* In dem Fall muss das physische System mit dem gleichen RL-Algorithmus wie das der Sim trainiert werden, um zu vergleichen.
  ]
