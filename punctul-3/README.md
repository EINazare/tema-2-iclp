# Cerinta
```
Necromancer-ul este un expert in zombie. Stie sa isi faca proprii lui Zombie Knight care pot incasa Whiptail in locul lui.

Practic Necromancer mai cunoaste si vraja Summon: Zombie Knight care dureaza 20 de milisecunde si invoca un Zombie Knight cu 600 cantitate de viata. Fiecare Zombie Knight are un singur atac:

Sword Slash care dureaza 5 milisecunde si loveste dragonul pentru o valoare aleatoare intre 20 si 50 cantiate de viata.
Acuma cand dragonul foloseste Whiptail, va lovi aleator unul dintre Zombie Knights daca exista vreunul, sau pe Necromancer altfel.
```
# Rezolvare 1
Pentru 3, am creat un nou proces numit ZombieKnight care este exact asemenea cu procesul de tip Necromancer de la punctul 2, ma rog, cu diferentele de timpi, putere a loviturii, nivel de viata si mesajele pe care le trimite.

Mai departe, in procesul de tip Necromancer, in functia pentru atac, am adaugat un random intre 1 si 2, si in functie de acesta, Necromancer-ul fie invoca un nou ZombieKnight, fie trimite un atac de tipul Anti_zombie_bolt.

In procesul de tip Sever, am adaugat un nou listener de mesaj, anume acela pentru crearea unui proces de tip ZombieKnight, iar la crearea fiecarui astfel de proces, il adaug in State-ul server-ului intr-un array - cred ca se numeste lista in elixir.
De asemenea, am modificat mesajul de tip lovitura din partea Dragonului sa nu mai fie trimisa catre Necromancer, in cazul in care un proces de tip ZombieKnight exista, iar daca exista mai multe, unul din acela va fi ales aleator.
Inca un mesaj a mai fost nevoie sa fie adaugat la Server, anume mesajul in care un ZombieKnight este omorat, caz in care procesul trebuie oprit, si scos din State-ul server-ului.

[Aici este codul](./main.exs)

# Rezolvare 2
Nu am reusit sa resolv fara utilizarea server-ului.

# Rezolvare 3
Nu am reusit sa resolv fara utilizarea server-ului.
