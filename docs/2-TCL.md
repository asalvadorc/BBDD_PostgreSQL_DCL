# El llenguatge de .... TCL

## Les transaccions

Quan s’han de dur a terme un conjunt de sentències de definició (amb DDL) o de manipulació de dades (amb DML) que estan estretament lligades entre elles, caldrà que siguin executades com si es tractés d’una sola sentència. Si es poden executar totes de manera satisfactòria, llavors la transacció es donarà per finalitzada i es validaran els canvis duts a terme a la base de dades. En cas contrari, caldrà desfer tots els canvis i deixar la base de dades igual que si cap de les sentències executades no s’hagués començat.

*Exemple de transacció*:

*Per exemple, si es vol fer una compra d’una entrada per a un espectacle en un portal web, primer caldrà mostrar quantes entrades queden lliures, mostrar els seients lliures i els preus, permetre a l’usuari que triï quin l’interessa. Si l’usuari vol, finalment, comprar uns seients determinats, el sistema haurà de validar que el pagament ha estat correcte, indicar que els seients es troben ocupats, rebaixar el nombre total de seients lliures…*

*Si durant tot aquest procés alguna de les sentències de manipulació de les dades no s’executés correctament, el sistema quedaria inestable (de manera que no quadrarien, per exemple, els seients oferts i el nombre total de seients disponibles).* 

*Per aquesta raó, és necessari garantir que o bé s’executen totes les sentències de manipulació de dades o no se n’executa cap.*

#### DEFINIR UNA TRANSACCIÓ

**Es pot definir que una <u>transacció</u> és un conjunt d’instruccions que formen una unitat lògica de treball, una unitat atòmica que es garanteix que s’executarà completament o no s’executarà.**

##### INICI DE TRANSACCIÓ

Per limitar les instruccions que poden formar part d’una transacció es pot començar amb la primera ordre SQL o es pot fer servir la sentència `BEGIN`  o `START TRANSACTION` que indicarà que tot el que hi hagi a continuació fins a trobar-se la sentència de finalització s’entendrà com una unitat atòmica.

Tot el que hi hagi a continuació del `BEGIN` no tindrà una execució física fins que no s’arribi al final de la transacció. D’aquesta manera es garanteix que, en cas de fallada del sistema (disc complet, tall d’energia, fallada del maquinari…), la base de dades es veurà alterada per totes les sentències o per cap.



##### FI DE TRANSACCIÓ 

Les dues sentències que poden finalitzar el contenidor de sentències que formen la transacció poden ser:

**1. Confirmar la transacció (guardar els canvis)**

`COMMIT`: aquesta sentència executarà, seguint el mateix ordre establert, totes les sentències incloses dins del establert com a transacció.

Una vegada finalitzada l’execució de totes les sentències se’n podrà començar una de nova.

La seva sintaxi és:

```
COMMIT [WORK | TRANSACTION]
```

La paraula *Work* és opcional.



**2.Desfer la transacció (revertir els canvis)**

`ROLLBACK`: aquesta sentència permet desfer una sèrie de consultes que s’hagin anat executant però que no s’hagin confirmat amb la sentència `COMMIT`. Les operacions que es podran desfer són les de:

- `INSERT`,
- `UPDATE`,
- `DELETE`.

Trobant una sentència ```ROLLBACK` es desfaran totes les modificacions fetes sobre la base de dades fins a trobar el darrer estat estable. Serà com fer servir la funcionalitat `UNDO` dels programes ofimàtics.

La seva sintaxi és:

```
ROLLBACK [WORK | TRANSACTION]
[SAVEPOINT savepointname]
```

La paraula *Work* és opcional.

##### PUNTS DE SEGURETAT

Un *`SAVEPOINT`* permetrà fer una utilització més fina de les transaccions. Si es marquen un o diversos punts de seguretat al llarg del codi, segons interessi es podrà fer un `ROLLBACK` no fins al principi de la transacció, sinó fins al punt de seguretat que sigui més adient. En el cas de fer servir aquesta instrucció, el `ROLLBACK` restablirà el conjunt de dades fins al punt especificat.

D’aquesta manera, quan es van executant les consultes que es troben a partir d’una sentència `BEGIN`, aquestes no representaran una execució física sobre la base de dades. Les taules afectades es veuran modificades de manera lògica, i no es confirmaran les alteracions fins a arribar a la sentència `COMMIT` o es descartaran en arribar a la sentència `ROLLBACK`.

Què succeeix si una transacció començada no finalitza, és a dir, s’arriba al final del programa sense cap ordre d’acceptació o confirmació o de desfer? La norma no especifica quina de les dues accions pot tenir lloc, així que dependrà de la implementació del sistema gestor de base de dades.

*Exemple de transacció començada no finalitzada*:

*Tenim una base de dades relacional amb les relacions de productes i proveïdors. En un moment determinat, un proveïdor ha de tancar la seva empresa. Caldrà actualitzar la base de dades de tal manera que els productes vinculats amb el proveïdor també s’esborrin de la base de dades (o passin a una altra relació amb dades històriques). Es podria dur a terme l’execució següent:*

```
BEGIN TRANSACTION
DELETE FROM Proveïdors WHERE PK_Codi_Proveïdor  = 3
DELETE FROM Productes WHERE FK_Proveïdor =3
COMMIT TRANSACTION
```

*En el cas de fallada de sistema després del primer `DELETE`, si no s’hagués implementat amb transaccions, s’hauria esborrat el proveïdor però els productes dependents d’aquell proveïdor continuarien en la taula de manera incorrecta.*

