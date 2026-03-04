# El lenguaje de control de transacciones (TCL)

## Las transacciones

Cuando se debe llevar a cabo un conjunto de sentencias de definición (DDL) o de manipulación de datos (DML) que están estrechamente ligadas entre sí, será necesario que se ejecuten como si se tratara de una sola sentencia.

Si todas se pueden ejecutar satisfactoriamente, entonces la transacción se dará por finalizada y se validarán los cambios realizados en la base de datos. En caso contrario, será necesario deshacer todos los cambios y dejar la base de datos como si ninguna de las sentencias se hubiera ejecutado.

**Ejemplo** de transacción:

Por ejemplo, si se quiere comprar una entrada para un espectáculo en un portal web, primero será necesario mostrar cuántas entradas quedan libres, los asientos disponibles y los precios, y permitir que el usuario elija cuál le interesa.

Si finalmente el usuario decide comprar determinados asientos, el sistema deberá:

* Validar que el pago ha sido correcto
* Marcar los asientos como ocupados
* Reducir el número total de asientos disponibles

Si durante este proceso alguna de las sentencias de manipulación de datos no se ejecutara correctamente, el sistema quedaría inconsistente (por ejemplo, no coincidirían los asientos ocupados con el total disponible).

Por esta razón, es necesario garantizar que o bien se ejecutan todas las sentencias o no se ejecuta ninguna.

### Definir una transacción

**Una transacción es un conjunto de instrucciones que forman una unidad lógica de trabajo, una unidad atómica que se garantiza que se ejecutará completamente o no se ejecutará.**

### Inicio de transacción

Para delimitar las instrucciones que forman parte de una transacción, se puede comenzar con la primera orden SQL o utilizar: **BEGIN** o **START TRANSACTION**


Esto indicará que todo lo que aparezca a continuación hasta encontrar la sentencia de finalización se considerará una unidad atómica.

Nada de lo que esté después del BEGIN tendrá ejecución física hasta que se llegue al final de la transacción.

De esta manera se garantiza que, en caso de fallo del sistema (disco lleno, corte de energía, fallo de hardware, etc.), la base de datos se verá alterada por **todas las sentencias o por ninguna**.



### Fin de la transacción

Las dos sentencias que pueden finalizar una transacción son:

**1. Confirmar la transacción (guardar los cambios)**

`COMMIT`: Esta sentencia ejecutará todas las sentencias incluidas en la transacción en el orden establecido.

Después de su ejecución, se podrá iniciar una nueva transacción.

Sintaxis:

```
COMMIT [WORK | TRANSACTION]
```

(La palabra WORK es opcional)



**2.Deshacer la transacción (revertir los cambios)**

`ROLLBACK`: Permite deshacer las operaciones realizadas que aún no se han confirmado con COMMIT.Se pueden revertir operaciones como:

- `INSERT`,
- `UPDATE`,
- `DELETE`.

Al ejecutar ROLLBACK, se desharán todas las modificaciones realizadas hasta el último estado estable. Es equivalente al botón "Deshacer" (UNDO) en programas ofimáticos.

Sintaxis:

```
ROLLBACK [WORK | TRANSACTION]
[SAVEPOINT savepointname]
```

(La palabra WORK es opcional)

## Puntos de seguridad (SAVEPOINT)

Un SAVEPOINT permite un control más preciso de las transacciones.

Permite marcar puntos intermedios dentro de la transacción para poder hacer un ROLLBACK hasta ese punto y no necesariamente hasta el inicio.

Así:

* Las modificaciones se realizan de forma lógica
* No se hacen físicas hasta el COMMIT
* Se pueden descartar con ROLLBACK

¿Qué sucede si una transacción no finaliza?

Si se llega al final del programa sin ejecutar COMMIT ni ROLLBACK, la norma no especifica qué ocurre.

Dependerá del sistema gestor de bases de datos.

**Ejemplo de transacción**:

Supongamos una base de datos con las tablas Proveedores y Productos.

Si un proveedor cierra su empresa, será necesario eliminar:

* El proveedor
* Sus productos asociados

Esto puede hacerse así:

    BEGIN TRANSACTION
    DELETE FROM Proveedores WHERE PK_Codigo_Proveedor = 3
    DELETE FROM Productos WHERE FK_Proveedor = 3
    COMMIT TRANSACTION

Si ocurriera un fallo del sistema después del primer DELETE y no se hubieran usado transacciones, el proveedor se habría eliminado pero los productos seguirían existiendo incorrectamente en la base de datos.