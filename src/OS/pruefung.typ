#import "/components/admonitions.typ": *

= Bankiersalgorithmus

#further[
  - #link("https://www.geeksforgeeks.org/operating-systems/bankers-algorithm-in-operating-system-2/")[GeeksForGeeks]
  - #link("https://en.wikipedia.org/wiki/Banker's_algorithm")[Wikipedia]
]

Datenstrukturen:

- Max: $m times n$ Matrix \
  Prozess $i$ braucht bis zu $a_(i j)$ Instanzen der Ressource $j$
- Allocation: $m times n$ Matrix \
  Prozess $i$ hält $a_(i j)$ Instanzen der Ressource $j$
- Need: $m times n$ Matrix \
  $="Max" .- "Allocation"$
- Available: $n$ Array \
  Es gibt noch $a_i$ Instanzen der Ressource $i$
- Finish: $m$ Array \
  Prozess $i$ ist Fertig $<==> a_i = "True"$
- Work: $n$ Array \
  Von Ressource $i$ wurden $a_i$ Instanzen zurückgegeben

Algorithmen:

- Safety Algorithm
- Resource Request Algorithm

== Safety Algorithm

```py
# Given
m = 2 # Number of processes
n = 2 # Number of resources
pr_max = [[p1r1, p1r2],
          [p2r1, p2r2]]
pr_allocation = [[p1r1, p1r2],
                 [p2r1, p2r2]]
pr_available = [r1, r2]

# Initialize
need = pr_max - pr_allocation
work = pr_available
finish = [False for p in range(m)]

# Safety Algorithm
for _ in range(m):
    # Find a process that is not finished and doesnt need too much
    p = next((i for i in range(m) if not finish[i] and need[i, :] <= work), None)
    if p is None:
        return False
    # Simulate running this process
    finish[p] = True
    work += pr_allocation[p]
return True
```

== Resource Request Algorithm

```py
# Given
request = [[p1r1, p1r2],
           [p2r1, p2r2]]
p = 0 # Process request to process
pr_max = ...
pr_allocation = ...
pr_available = ...

# Initialize
need = ...

# Resource Request
if request[p] > need[p]:
    return False

if request[p] > pr_available:
    wait()

# Prepare for safety algorithm
pr_available -= request[p]
pr_allocation[p] += request[p]
need[p] -= request[p]

# Run safety algorithm
return safety_algorithm()
```

= Memory Management

== Kernel Memory

- #link("https://en.wikipedia.org/wiki/Buddy_memory_allocation")[_Buddy System_]. Rekursiv den kleinsten Block in zwei Buddies Splitten, bis ein passender Block entsteht. Wenn zwei Buddies frei sind mischen sie sich wieder.
- #link("https://www.youtube.com/watch?v=DRAHRJEAEso")[_Slab Allocator_]. Fixed size slabs

== Seitentabelle

Mapping physical RAM to virtual memory.

- _Translation Lookaside Buffer_. Cache Teilmenge der Seitentabelle
- _Inverted Page Table._ Mapping von Frames zu Seiten

== Weitere Begriffe

- _Working Set Model_. Ein Prozess kann nur in RAM sein, wenn alle benötigten Seiten in RAM passen. Implementierung durch sliding Window, timestamp of last reference.
- _Reference Bit_. 1 wenn recently accessed, wird regelmäßig auf 0 gesetzt. Wird von Page Replacement Algorithms gelesen.

= Prozess Synchronisation

- _Priority Inversion._ H wartet auf L, um R zu erlangen. M braucht nicht R und ersetzt L. $=>$ H wartet auf L, L wartet auf M.
- #link("https://www.youtube.com/watch?v=VDzdb27Gxvo")[_Bakery Algorithm_]. Entscheidung welcher Prozess zuerst R erlangt. Ticketnr ziehen, falls diese gleich ist wird auf basis von PID entschieden.
- #link("https://www.youtube.com/watch?v=ukM_zzrIeXs")[_Semaphor_]. Atomic Int mit increment und decrement-wait.


= Weitere Begriffe

- #link("https://www.geeksforgeeks.org/operating-systems/convoy-effect-operating-systems/")[_Convoy Effect_]. Ein Prozess mit hoher CPU Burst Time blockiert alle anderen bei FCFS Scheduling.
- _Zombie Prozess._ Kindprozess stirbt aber Parent ruft kein wait. PID bleibt in Tabelle. Nur durch killen des Parents kann der Zombie durch init waited werden.
- _Helgrind_. Multithreading Race Condition Debugger
- _Valgrind_. Memory debugger
