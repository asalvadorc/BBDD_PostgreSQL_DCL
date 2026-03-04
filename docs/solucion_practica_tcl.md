# 🛒 PRÁCTICA DCL POSTGRESQL (SOLUCIÓN)



## BD: tienda | Esquema: app

---

## 1) Crear base de datos

    ```sql
    CREATE DATABASE tienda;
    ```

---

## 2) Crear esquema propio

    ```sql
    CREATE SCHEMA app;
    ```

---

## 3) Bloquear creación en public

    ```sql
    REVOKE CREATE ON SCHEMA public FROM PUBLIC;
    ```

---

## 4) Crear tablas

    ```sql
    CREATE TABLE app.productos (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL,
        stock INT NOT NULL DEFAULT 0
    );

    CREATE TABLE app.ventas (
        id SERIAL PRIMARY KEY,
        producto_id INT NOT NULL REFERENCES app.productos(id),
        unidades INT NOT NULL,
        fecha TIMESTAMP NOT NULL DEFAULT NOW()
    );
    ```

Datos de prueba:

    ```sql
    INSERT INTO app.productos (nombre, stock) VALUES
    ('Teclado', 20),
    ('Raton', 15);

INSERT INTO app.ventas (producto_id, unidades) VALUES
 (1, 2),
 (2, 5);
    ```
---

## 5) Crear roles

    ```sql
    CREATE ROLE rol_consulta;
    CREATE ROLE rol_almacen;
    CREATE ROLE rol_tpvs;
    CREATE ROLE rol_admin;
    ```

---

## 6) Acceso al esquema

    ```sql
    GRANT USAGE ON SCHEMA app TO rol_consulta, rol_almacen, rol_tpvs, rol_admin;
    ```

---

## 7) Permisos

    ```sql
    GRANT SELECT ON app.productos TO rol_consulta;
    GRANT SELECT, UPDATE ON app.productos TO rol_almacen;
    GRANT SELECT ON app.productos TO rol_tpvs;
    GRANT INSERT, SELECT ON app.ventas TO rol_tpvs;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA app TO rol_admin;
    ```

---

## 8) Secuencias

    ```sql
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA app TO rol_tpvs, rol_admin;
    ```

---

## 9) Usuarios

    ```sql
    CREATE USER user_consulta WITH PASSWORD '1234';
    CREATE USER user_almacen  WITH PASSWORD '1234';
    CREATE USER user_tpvs     WITH PASSWORD '1234';
    CREATE USER user_admin    WITH PASSWORD '1234';
    ```

---

## 10) Asignar roles

    ```sql
    GRANT rol_consulta TO user_consulta;
    GRANT rol_almacen  TO user_almacen;
    GRANT rol_tpvs     TO user_tpvs;
    GRANT rol_admin    TO user_admin;
    ```

---

## 11) PRUEBAS

## Conexión

    ```sql
    GRANT CONNECT ON DATABASE tienda TO
    user_consulta,
    user_almacen,
    user_tpvs,
    user_admin;
    ```

---

## user_consulta

    SET ROLE user_consulta;

    ```sql
    SELECT * FROM app.productos;
    ```

Debe fallar:

    ```sql
    UPDATE app.productos SET stock = 10 WHERE id = 1;
    INSERT INTO app.ventas (producto_id, unidades) VALUES (1,2);
    ```

---

## user_almacen

  SET ROLE user_almacen;

    ```sql
    SELECT * FROM app.productos;
    UPDATE app.productos SET stock = stock + 5 WHERE id = 1;
    ```

Debe fallar:

    ```sql
    INSERT INTO app.ventas (producto_id, unidades) VALUES (1,2);
    ```

---

## user_tpvs

    SET ROLE user_tpvs;

    ```sql
    SELECT * FROM app.productos;
    INSERT INTO app.ventas (producto_id, unidades) VALUES (1,3);
    ```

Debe fallar:

    ```sql
    UPDATE app.productos SET stock = 5 WHERE id = 1;
    ```

---

## user_auditor

    SET ROLE user_auditor;

    ```sql
    SELECT * FROM app.productos;
    SELECT * FROM app.ventas;
    ```

Debe fallar:

    ```sql
    UPDATE app.productos SET stock = 99 WHERE id = 1;
    ```

---

## user_admin

    SET ROLE user_admin;

    ```sql
    SELECT * FROM app.productos;
    UPDATE app.productos SET stock = 99 WHERE id = 1;
    INSERT INTO app.ventas (producto_id, unidades) VALUES (1,1);
    DELETE FROM app.ventas WHERE id = 1;
    ```

—

## 12) Auditor

    ```sql
    CREATE USER user_auditor WITH PASSWORD '1234';
    GRANT CONNECT ON DATABASE tienda TO user_auditor;
    GRANT pg_read_all_data TO user_auditor;
    ```

---


## 13) Ver permisos

    ```sql
    SELECT
    r.rolname,
    ARRAY(SELECT b.rolname
    FROM pg_catalog.pg_auth_members m
    JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid)
    WHERE m.member = r.oid ) as memberof
    FROM pg_catalog.pg_roles r
    ORDER BY 1;
    ```
