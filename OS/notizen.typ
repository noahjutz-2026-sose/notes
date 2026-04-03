#import "@preview/codly:1.3.0": codly
#import "/components.typ": *

#align(end)[2026-03-19]

= Organisatorisches

Siehe `2025_sose/notizen.xopp` für
- Historischer Abriss
- Kernel
- Interrupts und Traps
- Bash
- Build & Debug Tools
- IPC Mit Shared Memory
- IPC Mit Pipes

// #counter(heading).update(9)

#align(end)[2026-03-19 VL9 (2025-11-03)]

= IPC mit Shared Memory

#codly(header: [Writer])
#raw(
    block: true,
    lang: "c",
    read("assets/writer.c")
)

#codly(header: [Reader])
#raw(
    block: true,
    lang: "c",
    read("assets/reader.c")
)

```sh
$ ./writer
$ ./reader
0 2 4 6 8 10 12 14 16 18
```

#align(end)[2026-03-26 VL10 (2025-11-04)]

= IPC mit Pipes

#codly(header: [Pipes])
#raw(
    block: true,
    lang: "c",
    read("assets/pipe.c")
)

```sh
$ ./pipe
Child received: pong

Parent received: ping
```

= Scheduling

- Ready Queue: FIFO
- _Daemon Process_
- _Zombie Process:_ Beendeter Prozess, der noch in der Prozesstabelle ist.
    - Lösung: Elternprozess terminieren
- _Niceness:_ Priorität
    - $(20-(-20))/(20-0)=2 =>$ Prozess mit niceness -20 erhält doppelt so viel CPU-Zeit.
- _Starvation:_ Prozess kommt nie zum Zug

#align(end)[2026-03-30 VL11 (2025-11-10)]

== Preemtives Scheduling

$
    "Turnaround Time" = "Waiting Time" + "Burst Time"
$

- _Waiting Time:_
    - Ziel: minimieren
    - Lösung: _Shortest Job First (SJF)_
        - _Exponentielle Glättung:_ Schätzung von Bursts anhand Vergangenheit
            $
                tau_(n+1) = alpha t_n + (1 - alpha) tau_n
            $
    - Lösung: _Round Robin:_ Jeder Prozess darf maximal $q$ Schritte rechnen

= Threads

== POSIX Thread

#codly(header: [Runner])
```c
void *runner(void *args) { return args; }
```

#codly(header: [PThread])
```c
pthread_t t;
pthread_create(&t, NULL, runner, arg)
pthread_join(t, NULL)
```

#align(end)[2026-03-31 VL12 (2025-11-11)]

== Software Patterns

- Compute Farm
    #example[

    ]
- Workcrew
- Pipeline

== Synchronisation

#align(end)[2026-04-03 VL13 (2025-11-17)]

- In Java:
    - Monitor-Objekt
    - synchronized
    - notify
    - wait
    - Ohne synchronized: IllegalMonitorStateException
- In C:
    - pthread_mutex_t
        - init
        - lock
        - unlock
        - destroy
    - pthread_cond_t
        - init
        - wait
        - signal
        - destroy
    - pthread_attr_t
        - getprio
        - setprio
        - PTHREAD_PROCESS_PRIVATE / PTHREAD_PROCESS_SHARED
