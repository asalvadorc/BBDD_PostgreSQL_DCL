# 1. Introducció

- **Llenguatge de control de dades (DCL, data control language*)**, és l’encarregat d’establir els mecanismes de control. Ofereix solucions als problemes de concurrència dels usuaris i garanteix la seguretat de les dades.

El llenguatge SQL és un llenguatge declaratiu, és a dir, no és imperatiu o procedimental. El llenguatge SQL indicarà què es vol fer, no indicarà com s’ha de fer. Per aquesta raó, necessita al seu costat un altre llenguatge sí procedimental que doni les instruccions al sistema per fer una sèrie d’operacions.

Aquest apartat se centra en el llenguatge de control de dades (DCL). S’encarrega de totes les instruccions que tenen a veure amb l’administració de la base de dades:

- creació d’usuaris,
- assignació de privilegis,
- accessos,
- *tunning*,
- …

Aquest llenguatge pot resumir les seves **funcionalitats** en dues: 

1) Oferir accions per dur a terme transaccions  
2) Oferir solucions per garantir la seguretat de les dades. 

Aquestes dues funcionalitats són clau per solucionar els problemes d’una de les característiques més importants d’una base de dades: **la capacitat de ser-ne multiusuari.** L’accés comú de diversos usuaris a les mateixes dades pot donar peu a problemes molt importants, com el problema de la protecció de dades i l’assignació posterior de privilegis. Per tant, requereix un tractament especial.

Les dues funcionalitats estan directament relacionades amb els conceptes de *confidencialitat*, *integritat* i *disponibilitat*:

- Amb la possibilitat de donar **permisos als usuaris** per accedir a part de la informació s’ofereix una solució al problema de la confidencialitat.
- Amb la possibilitat de dur a terme execucions de consultes (*query*) a partir de **transaccions** s’ofereixen solucions als problemes d’integritat i disponibilitat.