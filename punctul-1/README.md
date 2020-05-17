# Cerinta
```
Necromancer-ul stie o singura vraja: Anti zombie bolt, care loveste dragonul pentru o valoare aleatoare intre 0 si 1 000 cantitate de viata. Dragonul stie si el un singur atac: Whiptail, care loveste un adversar de-al sau pentru o valoare aleatoare intre 50 si 100 cantitate de viata.

Fiecare din cei doi simuleaza aceste atacuri la infinit.

Simulati lupta dintre cei doi. Afisati la final concluzia:

A castigat necromancer-ul si a ramas cu X cantitate de viata
A castigat dragonul si a ramas cu Y cantitate de viata.
Spoiler alert: deocamdata castiga dragonul.

Pentru implementare se recomanda sa folositi 2 procese suplimentare: NecromancerStrategy si DragonStrategy care simuleaza strategia lor, iar Necromancer si Dragon ca procese vor implementa logica operatiilor.
```
# Rezolvare 1
La punctul 1 nu am reusit sa fac cele 4 procese, am facut 3 dupa cum urmeaza:

- Un proces pentru Server, care porneste alte doua procese (procesul pentru Necromancer si cel pentru Dragon), si care implementeaza o functie recursiva folosind Task.start_link, functie care asteapta 4 tipuri de mesaje, unul pentru lovituri trimise de catre Dragon catre Necromancer, unul pentru loviturile de catre Necromancer catre Dragon, si inca doua mesaje in care verifica daca unul din cei doi a murit. Mesajele primite de la Dragon sunt trimise mai departe Necromancer-ului si vice-versa (pentru a simula lovitorua, si pentru a stii daca procesul respectiv si-a omorat sau nu oponentul).

- Un proces pentru Necromancer care foloseste Task.start_link pentru a porni doua functii recursive, una care astepta la nesfarsit doua tipuri de mesaje, un mesaj pentru momentul in care a fost lovit de catre Dragon, si inca un mesaj in cazul in care Dragonul a murit, astfel sa fie afisat mesajul cu "Necromancer a castigat...", iar a doua functie recursiva este una care trimite la nesfarsit lovituri (mesaje) catre PID-ul proceslui Server  - care sunt mai departe trimise Dragonului

- Un proces pentru Dragon care foloseste Task.start_link pentru a porni doua functii recursive, una care astepta la nesfarsit doua tipuri de mesaje, un mesaj pentru momentul in care a fost lovit de catre Necromancer, si inca un mesaj in cazul in care Necromancer-ul a murit, astfel sa fie afisat mesajul cu "Dragon a castigat...", iar a doua functie recursiva este una care trimite la nesfarsit lovituri (mesaje) catre PID-ul proceslui Server - care sunt mai departe trimise Necromancer-ului

[Aici este codul](./main.exs)

# Rezolvare 2
Pentru rezolvarea aceasta, am reusit sa renunt la utilizarea procesului de tip Server.
Astfel, si Necromancer-ul si Dragonul la pornire, pornesc cate un sub-proces pentru primirea de mesaje, la fel ca si in cazul rezolvarii 1, cu diferetanta ca fiecare mai astepta cate un mesaj cu pid-ul adversarului, iar cand primesc acest pid, se mai porneste inca cate un sub-proces, anume procesul pentru trimiterea de atac-uri.

[Aici este codul](./main-without-server.exs)

# Rezolvare 3
Ca si la Reolzvare 2, doar ca procesele pentru atac nu mai sunt functii in Dragon/Necromancer, ci sunt create in propriul `defmodule`.

[Aici este codul](./main-without-server-and-stragey-processes.exs)
