-- =========================================================
-- SOLUCIÓN (psql) - Práctica DCL PostgreSQL
-- BD: tienda | Esquema: app
-- Ejecutar con:
--   psql -U postgres -f solucion_practica_dcl_psql.sql
-- =========================================================

\echo '== 1) Crear base de datos =='
DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda;

\echo '== 2) Conectarse a la BD =='
\connect tienda

\echo '== 3) Crear esquema propio y bloquear public =='
DROP SCHEMA IF EXISTS app CASCADE;
CREATE SCHEMA app;

-- Evitar que cualquiera cree objetos en public
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

\echo '== 4) Crear tablas =='
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

\echo '== 5) Datos de prueba =='
INSERT INTO app.productos (nombre, stock) VALUES
('Teclado', 20),
('Raton', 15);

\echo '== 6) Crear roles (grupos) =='
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_consulta') THEN
    DROP ROLE rol_consulta;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_almacen') THEN
    DROP ROLE rol_almacen;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_tpvs') THEN
    DROP ROLE rol_tpvs;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_admin') THEN
    DROP ROLE rol_admin;
  END IF;
END$$;

CREATE ROLE rol_consulta;
CREATE ROLE rol_almacen;
CREATE ROLE rol_tpvs;
CREATE ROLE rol_admin;

\echo '== 7) Dar USAGE sobre el esquema app =='
GRANT USAGE ON SCHEMA app TO rol_consulta, rol_almacen, rol_tpvs, rol_admin;

\echo '== 8) Permisos sobre tablas =='
-- Consulta
GRANT SELECT ON app.productos TO rol_consulta;

-- Almacén
GRANT SELECT, UPDATE ON app.productos TO rol_almacen;

-- TPVs
GRANT SELECT ON app.productos TO rol_tpvs;
GRANT INSERT, SELECT ON app.ventas TO rol_tpvs;

-- Admin
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA app TO rol_admin;

\echo '== 9) Permisos sobre secuencias (SERIAL) =='
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA app TO rol_tpvs, rol_admin;

\echo '== 10) Crear usuarios =='
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'user_consulta') THEN
    DROP ROLE user_consulta;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'user_almacen') THEN
    DROP ROLE user_almacen;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'user_tpvs') THEN
    DROP ROLE user_tpvs;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'user_admin') THEN
    DROP ROLE user_admin;
  END IF;
END$$;

CREATE USER user_consulta WITH PASSWORD '1234';
CREATE USER user_almacen  WITH PASSWORD '1234';
CREATE USER user_tpvs     WITH PASSWORD '1234';
CREATE USER user_admin    WITH PASSWORD '1234';

\echo '== 11) Asignar roles a usuarios =='
GRANT rol_consulta TO user_consulta;
GRANT rol_almacen  TO user_almacen;
GRANT rol_tpvs     TO user_tpvs;
GRANT rol_admin    TO user_admin;

\echo '== 12) Ver usuarios y roles (\du) =='
\du

\echo '== 13) Ver permisos sobre tablas (\dp) =='
\dp app.productos
\dp app.ventas

\echo '========================================================='
\echo 'LISTO. Para probar accesos, abre otra terminal y ejecuta:'
\echo '  psql -U user_consulta -d tienda'
\echo '  psql -U user_almacen  -d tienda'
\echo '  psql -U user_tpvs     -d tienda'
\echo '  psql -U user_admin    -d tienda'
\echo ''
\echo 'Comandos de prueba sugeridos:'
\echo '  SELECT * FROM app.productos;'
\echo '  UPDATE app.productos SET stock = stock + 1 WHERE id = 1;'
\echo '  INSERT INTO app.ventas (producto_id, unidades) VALUES (1, 2);'
\echo '========================================================='

-- 14) (Opcional) Revocar rol de almacén a user_almacen
-- REVOKE rol_almacen FROM user_almacen;
