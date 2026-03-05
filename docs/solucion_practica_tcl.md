# 🛒 PRÁCTICA TCL POSTGRESQL (SOLUCIÓN)



# 🧪 PRÁCTICA: Gestión de Transacciones con TCL (VERSIÓN CON SOLUCIÓN)

## 🎯 Objetivo

Aprender a:

- Utilizar **BEGIN / START TRANSACTION**
- Aplicar **COMMIT**
- Aplicar **ROLLBACK**
- Usar **SAVEPOINT**
- Entender la importancia de la atomicidad en bases de datos

---

## 🗂️ Contexto

Trabajaremos con una base de datos de **ventas de entradas de cine**.

Cuando un cliente compra una entrada, deben realizarse varias acciones:

1. Registrar la compra  
2. Marcar el asiento como ocupado  
3. Reducir el número de asientos disponibles  

⚠️ Todo esto debe hacerse como una única unidad lógica.

---

# 🏗️ PREPARACIÓN (SOLUCIÓN)

> 💡 *Opcional: si ya existen tablas, primero bórralas.*

```sql
DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Asientos;
DROP TABLE IF EXISTS Sesiones;
```

## Crear tablas

```sql
CREATE TABLE Sesiones (
    id_sesion INT PRIMARY KEY,
    pelicula VARCHAR(50),
    asientos_disponibles INT
);

CREATE TABLE Asientos (
    id_asiento INT PRIMARY KEY,
    id_sesion INT,
    ocupado BOOLEAN
);

CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY,
    id_sesion INT,
    id_asiento INT
);
```
ALTER TABLE Asientos
ADD CONSTRAINT fk_asientos_sesion
FOREIGN KEY (id_sesion)
REFERENCES Sesiones(id_sesion);

ALTER TABLE Ventas
ADD CONSTRAINT fk_ventas_sesion
FOREIGN KEY (id_sesion)
REFERENCES Sesiones(id_sesion);

ALTER TABLE Ventas
ADD CONSTRAINT fk_ventas_asiento
FOREIGN KEY (id_asiento)
REFERENCES Asientos(id_asiento);
## Insertar datos iniciales


```sql
INSERT INTO Sesiones VALUES (1, 'Avatar 3', 5);

INSERT INTO Asientos VALUES
(1,1,false),
(2,1,false),
(3,1,false),
(4,1,false),
(5,1,false);
```

---

# 🧩 PARTE 1 — Sin Transacción (SOLUCIÓN + explicación)

Simulación de compra SIN transacción (queda inconsistente si “falla” la última sentencia):

```sql
INSERT INTO Ventas VALUES (1,1,2);

UPDATE Asientos
SET ocupado = true
WHERE id_asiento = 2;

-- Simular fallo (NO ejecutar la siguiente línea)
UPDATE Sesiones
SET asientos_disponibles = asientos_disponibles - 1
WHERE id_sesion = 1;
```

Consultar:

```sql
SELECT * FROM Sesiones;
SELECT * FROM Asientos;
SELECT * FROM Ventas;
```

✅ **Solución / conclusión esperada:**  
La BD queda **inconsistente**, porque hay una venta y un asiento ocupado, pero **no se ha reducido** `asientos_disponibles`.

---

# 🧩 PARTE 2 — BEGIN + COMMIT (SOLUCIÓN)

Compra correcta con transacción:

```sql
START TRANSACTION;

INSERT INTO Ventas VALUES (2,1,3);

UPDATE Asientos
SET ocupado = true
WHERE id_asiento = 3;

UPDATE Sesiones
SET asientos_disponibles = asientos_disponibles - 1
WHERE id_sesion = 1;

COMMIT;
```

Consultar:

```sql
SELECT * FROM Sesiones;
SELECT * FROM Asientos;
SELECT * FROM Ventas;
```

✅ **Resultado esperado:**  
Todo se guarda a la vez: venta registrada, asiento ocupado y `asientos_disponibles` reducido en 1.

---

# 🧩 PARTE 3 — ROLLBACK (SOLUCIÓN)

Simular error y deshacer todo:

```sql
START TRANSACTION;

INSERT INTO Ventas VALUES (3,1,4);

UPDATE Asientos
SET ocupado = true
WHERE id_asiento = 4;

-- ERROR SIMULADO → sesión no existe (no afectará a ninguna fila)
UPDATE Sesiones
SET asientos_disponibles = asientos_disponibles - 1
WHERE id_sesion = 99;

ROLLBACK;
```

Consultar:

```sql
SELECT * FROM Sesiones;
SELECT * FROM Asientos;
SELECT * FROM Ventas;
```

✅ **Resultado esperado:**  
No se guarda **nada** de esta operación (ni venta 3 ni el asiento 4 ocupado), porque se ejecuta `ROLLBACK`.

> 💡 Nota: en algunos SGBD, si no hay error “real” (solo 0 filas afectadas), el rollback igualmente deshace lo hecho hasta el momento si se decide ejecutarlo.

---

# 🧩 PARTE 4 — SAVEPOINT (SOLUCIÓN)

> Objetivo: deshacer solo parte de la transacción.

```sql
START TRANSACTION;

INSERT INTO Ventas VALUES (4,1,5);
SAVEPOINT venta_realizada;

UPDATE Asientos
SET ocupado = true
WHERE id_asiento = 5;
SAVEPOINT asiento_actualizado;

-- ERROR SIMULADO (0 filas actualizadas)
UPDATE Sesiones
SET asientos_disponibles = asientos_disponibles - 1
WHERE id_sesion = 99;

ROLLBACK TO asiento_actualizado;

COMMIT;
```

Consultar:

```sql
SELECT * FROM Sesiones;
SELECT * FROM Asientos;
SELECT * FROM Ventas;
```

✅ **Resultado esperado (tal como está escrito):**  
- La **venta 4** queda guardada  
- El **asiento 5** queda ocupado  
- La actualización fallida no cambia nada  
- Se confirma con `COMMIT`

> ⚠️ Importante: `ROLLBACK TO asiento_actualizado` vuelve al estado justo DESPUÉS del `SAVEPOINT asiento_actualizado` (por tanto, mantiene la venta y el asiento ocupado).  
> Si se quisiera deshacer el asiento pero mantener la venta, habría que hacer `ROLLBACK TO venta_realizada`.

### Variante extra (para ver el efecto real del SAVEPOINT)

Mantener la venta pero deshacer el asiento:

```sql
START TRANSACTION;

INSERT INTO Ventas VALUES (5,1,1);
SAVEPOINT venta_ok;

UPDATE Asientos
SET ocupado = true
WHERE id_asiento = 1;

-- Decidimos no ocuparlo finalmente
ROLLBACK TO venta_ok;

COMMIT;
```

✅ **Resultado esperado:**  
- Se guarda la venta 5  
- El asiento 1 **NO** queda ocupado (se deshace esa parte)

---

# 🧠 PARTE 5 — Reflexión (SOLUCIÓN)

1. **Ventaja:** Garantiza consistencia: o todo se hace o no se hace nada.  
2. Sin transacciones, una operación a medias deja datos incoherentes (ventas sin asientos, stock incorrecto, etc.).  
3. `ROLLBACK` deshace toda la transacción; `ROLLBACK TO SAVEPOINT` deshace solo hasta un punto intermedio.  
4. SAVEPOINT se usa en procesos largos donde interesa conservar parte del trabajo (ej. registro de pedido) pero deshacer otra (ej. asignación de stock).

---

# 🏁 RETO FINAL (SOLUCIÓN)

## Requisito
Vender 2 entradas a la vez. Si falla una, no se vende ninguna.

### Solución (con comprobación de asientos libres antes de ocupar)

```sql
START TRANSACTION;

-- VENTA 6: asiento 1 (comprobar que está libre)
UPDATE Asientos
SET ocupado = true
WHERE id_asiento = 1 AND id_sesion = 1 AND ocupado = false;

-- Si no se actualiza ninguna fila, significa que estaba ocupado → abortar
-- (esto depende del SGBD; en MySQL se puede comprobar ROW_COUNT())
-- En un entorno docente, si ROW_COUNT() = 0 entonces hacemos ROLLBACK.

-- Registrar venta 6 (asiento 1)
INSERT INTO Ventas VALUES (6,1,1);

-- VENTA 7: asiento 2 (comprobar que está libre)
UPDATE Asientos
SET ocupado = true
WHERE id_asiento = 2 AND id_sesion = 1 AND ocupado = false;

-- Registrar venta 7 (asiento 2)
INSERT INTO Ventas VALUES (7,1,2);

-- Reducir asientos disponibles en 2
UPDATE Sesiones
SET asientos_disponibles = asientos_disponibles - 2
WHERE id_sesion = 1;

COMMIT;
```

✅ **Resultado esperado:**  
Las dos ventas se registran y los dos asientos quedan ocupados, reduciendo el contador en 2.  
Si en algún punto se decide abortar (por ejemplo, un asiento ya estaba ocupado), se hace `ROLLBACK` y no se guarda nada.

---

## ✅ CONSULTAS DE COMPROBACIÓN (opcional)

```sql
SELECT * FROM Sesiones;
SELECT * FROM Asientos ORDER BY id_asiento;
SELECT * FROM Ventas ORDER BY id_venta;
```
