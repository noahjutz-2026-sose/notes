#import "/components/admonitions.typ": *
#import "/template.typ": template_base, template_document

#show: template_document
#set par(justify: true)

#title[Sim-to-Real Transfer]

= Hintergrund

#link("https://doi.org/10.48550/arXiv.2312.09906")[CyberRunner] ist ein Roboter, der durch Reinforcement Learning ein Kugellabyrinthspiel löst. Der Lernprozess findet auf einem physischen System statt. Zwei Motoren steuern die Rotation der Spielebene, um die Kugel zu bewegen. Eine Kamera erfasst den Zustand des Spiels (Ballposition, Ebenenwinkel). Der Reinforcement-Learning Algorithmus #link("https://doi.org/10.1038/s41586-025-08744-2")[DreamerV3] entscheidet sich für die Aktionen mit dem höchsten erwarteten Reward (Motorgeschwindigkeit).

#link("https://github.com/suesas/marble-maze")[Marble Maze] war ein Masterprojekt an der OTH Regensburg, das einen digitalen Zwilling des gleichen Kugelspiels durch Reinforcement Learning löst. Hier wurde statt DreamerV3 PPO verwendet.

= Problem

Das physische Setup des CyberRunners hat physische Bottlenecks (Parallelisierung) und Fehleranfälligkeiten, die im digitalen Zwilling nicht existieren.

Durch Training eines Modells am digitalen Zwilling und anschließendem Übertragen auf das physische System zur Evaluation könnte der Lernprozess vereinfacht und beschleunigt werden.

Sim-to-Real transfer wurde noch nicht an einem Labyrinth-Kugelspiel erforscht, welches Löcher hat, durch die die Kugel fallen kann.

= Vorgehen

*Phase 1: Kontrollgruppe.* Performance-Evaluation eines modifizierten physischen Setups (Baseline-Messung). Parallel dazu Inbetriebnahme des Marble Maze Unity Projekts und Messung der Performance.

*Phase 2: Prototyp.* Diskrepanzen in der Problemmodellierung erkennen und lösen. Entwicklung einer Kompatibilitätsschicht. Migration von PPO nach DreamerV3 auf Marble Maze. Übertragung eines simulierten Modells auf physisches System und Performance-Evaluation.

*Phase 3: Optimierung.* Fine-Tuning, Domain-Randomisierung, Hyperparameter-Optimierung. Performance-Evaluation.

= Hypothese

Ein an einem digitalen Zwilling trainiertes Modell kann an einen physischen Labyrinth-Roboter übergeben werden und innerhalb von weniger als 60 Minuten fine-tuning das Spiel lösen. Dabei erreicht es eine Durchlaufzeit, die maximal 15% schlechter ist als ein vollständig auf der Hardware trainiertes Modell.

Annahme: Die Leistungsdifferenz eines Modells zwischen der virtuellen Simulation und der echten Welt ist auf physikalische Parametervarianz zurückzuführen, nicht auf fundamentale Modelllimitierungen.

= Mögliche Probleme bei der Durchführung

- Unity-Modell zu unterschiedlich: Es wird keine Kamera Simuliert, anderes RL verwendet, physikalische Unregelmäßigkeiten

= Literatur

- CyberRunner. https://doi.org/10.48550/arXiv.2312.09906
- DreamerV3. https://doi.org/10.1038/s41586-025-08744-2
- Marble Maze. https://github.com/suesas/marble-maze
- Sim-to-Real tranfer mit marble maze game. https://doi.org/10.1109/ICRA.2019.8793561
- Sim-to-Real transfer mit Dreamer. https://doi.org/10.3389/frobt.2025.1655171
