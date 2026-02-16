# El llenguatge de control de les dades DCL

**El Data Control Language (DCL – Llenguatge de control de dades)** s’utilitza per gestionar els permisos i privilegis d’accés als objectes dins d’una base de dades, establint polítiques de seguretat que determinen quins usuaris o rols poden interactuar amb les dades i de quina manera.

A través del DCL, els administradors de bases de dades poden atorgar o revocar permisos, assegurant que cada usuari només puga realitzar les accions que li han sigut expressament autoritzades. Aquest control és essencial per protegir la informació sensible, evitar accessos no autoritzats i mantenir la integritat de les dades.

## Usuaris

Així doncs, el primer pas és la creació d’usuaris i de les seues credencials.

SQL proporciona comandes específiques per crear, modificar i eliminar usuaris, encara que la sintaxi pot variar lleugerament segons el SGBD (com SQLite, PostgreSQL o Oracle).

Per crear un nou usuari es fa amb la sentència CREATE USER, mitjançant la sintaxi.

    CREATE USER nombre_usuario IDENTIFIED BY 'contraseña';

En indicar la contrasenya, aquesta s’encriptarà amb un hash mitjançant l’algorisme mysql_native_password. El hash és irreversible, la qual cosa significa que no es pot recuperar la contrasenya original a partir d’aquest.    

## La seguretat

El propietari de la base de dades és qui en té tots els privilegis, però no és l’únic que hi accedeix. A una base de dades poden accedir moltes persones, que moltes vegades potser no tenen res a veure o no es coneixen en fer els accessos remotament per diferents motius.

*Per exemple, a una base de dades amb l’estoc de productes d’una distribuïdora amb moltes botigues ubicades a diferents poblacions podran accedir per manipular o consultar dades persones tant distintes com:*

- **Receptors de productes als magatzems**, per actualitzar-ne els estocs.
- **Treballadors** per consultar si hi ha estoc d’un producte determinat.
- **Les màquines registradores**, automàticament, per actualitzar l’estoc després d’una venda.
- **Els encarregats de les compre**s, per consultar la situació i prendre decisions.
- **Els treballadors del departament de control** per prendre un altre tipus de decisions.
- **Els clients finals**, des de casa seva, consultant si poden anar a comprar aquell producte determinat.



Segons es veu en aquest situació, poden arribar a ser moltes mans les que accedeixin a les dades. Però no serà el mateix el que ha de poder veure un client final des de casa seva que el que ha de veure un treballador del departament de control. Per aquesta raó, és important assignar una sèrie de privilegis als usuaris que accedeixen a les dades, de tal manera que cada usuari tingui un perfil assignat amb uns permisos determinats sobre la base de dades, en global, i sobre les relacions, en particular.

L’assignació dels privilegis es pot dur a terme des de dos possibles punts de vista:

1. Des del punt de vista de l’usuari.
2. Des del punt de vista de les taules o les vistes.

La sentència que es fa servir en ambdós casos per assignar permisos és la sentència `GRANT`.

La seva sintaxi és:

```
GRANT { <Privilegi1> [, < Privilegi2> ..] } | ALL
ON [<User1>.]<Objecte>
TO {<User2> [, <User3> ...]} | PUBLIC.
```

Els privilegis poden ser:

- `ALL`: assigna tots els permisos possibles a una taula o a una vista.
- `SELECT`: assigna el permís de fer consultes (llegir) a un usuari o sobre una taula concreta.
- `INSERT`: assigna el permís d’inserció de dades a un usuari o sobre una taula concreta.
- `UPDATE`: assigna el permís de modificació de dades a un usuari o sobre una taula concreta.
- `DELETE`: assigna el permís d’esborrament de dades a un usuari o sobre una taula concreta.
- `INDEX`: assigna el permís de creació d’índexs per a una taula concreta o per a un usuari.
- `ALTER`*: assigna el permís de modificació de l’estructura d’una taula o a un usuari.

Un _Objecte_ pot ser una taula o una vista.  
Un _User_ es refereix a un usuari concret.

Per exemple:

```
GRANT SELECT
ON Productes
TO Joan
```

En aquest exemple s’atorga el permís de consultes a l’usuari _Joan_ sobre la taula _Productes_.

La sentència que es fa servir per treure els permisos a un usuari determinat o sobre una taula determinada és `REVOKE`.

La seva sintaxi és:

```
REVOKE {ALL | SELECT | INSERT | DELETE | INDEX | ALTER |
UPDATE | UPDATE(<Columna1> [, <Columna2> ...])}
ON {<Taula> | <Vista>}
FROM {PUBLIC | <Usuari1> [, <Usuari2> ...]}
{RESTRICT/CASCADE}
```

Un exemple d’utilització de la sentència `REVOKE` és:

```
REVOKE ALL
ON Proveïdors
TO Joan
```

en què ara es treuen tots els privilegis sobre la taula _Proveïdors_ a l’usuari _Joan_, que no podrà ni accedir a registres d’aquesta taula, ni modificar-los, ni esborrar-los.

Les opcions `RESTRICT`/`CASCADE` permeten allargar o aturar l’aplicació de la sentència `REVOKE` al llarg dels usuaris que s’hagin anant donant permisos. És a dir, si un usuari B va donar permisos a l’usuari C per accedir a una taula determinada. Ara l’usuari B rep una sentència que revoca els seus privilegis per accedir a aquesta taula amb la indicació `CASCADE`. Automàticament l’usuari C perdrà els privilegis d’accés a aquesta taula també.

### Altres sentències DCL

A més de les sentencies sobre transaccions i seguretat, cal referenciar altres sentències també molt útils i importants que s’engloben dins del llenguatge de control de dades.

És el cas de l’accés múltiple a les taules i les estratègies existents de bloqueig.

Per exemple, a partir d’una base de dades amb informacions sobre vols que es fa servir per accedir des d’un entorn web per reservar i comprar bitllets, dos usuaris accedeixen a la vegada a la consulta de places per a un vol determinat. Cada usuari vol comprar tres bitllets, però només en queden dos. Si hi accedeixen a la vegada i cerquen el mateix vol abans que l’altre hagi fet efectiva la compra, si no s’han pres mesures, els dos veuran places disponibles i pensaran que les poden comprar. En algun moment caldria establir un criteri per decidir a quin dels dos li vendran els bitllets, i l’altre es quedarà amb un pam de nas.

Per solucionar aquest problema es poden fer servir instruccions que permetin bloquejar una taula determinada mentre un usuari l’està fent servir.

La sentència `SHARE LOCK` permet compartir l’ús de la taula per més d’un usuari a la vegada, si es troba en mode compartició.

La seva sintaxi és:

```
LOCK TABLE [<User>.]<tablename> IN SHARE [nowait]
```

Una altra sentència és `EXCLUSIVE LOCK`. Aquesta sentència permet bloquejar una taula per a la resta d’usuaris de la base de dades. Aquesta sentència és fàcil d’utilitzar, però comporta molt temps d’espera per a la resta d’usuaris.

La seva sintaxi és:

```
LOCK TABLE [<User>.]<tablename> IN EXCLUSIVE [nowait]
```

Per solucionar els problemes de la sentència anterior es pot fer servir un sistema anomenat *bloqueig exclusiu de línies*.

El bloqueig de cada línia és, sens dubte, la millor manera de resoldre el problema de les esperes. Es recomana utilitzar un dels mètodes de bloqueig de les dades només si és necessari.

La seva sintaxi és:

```
SELECT ....
FROM ...
[WHERE ...]
[ORDER BY ...]
FOR UPDATE OF Spalte1 [, Spalte2] ...
```

Un exemple d’utilització:

```
SELECT Llocs, Des de, Fins, Ubicació
FROM Viatges
WHERE Ubicació  = 'Rom'
FOR UPDATE OF Llocs
UPDATE Viatges
SET Llocs = Llocs – Llocs_reservats
WHERE Ubicació = 'Rom'
Commit
```
