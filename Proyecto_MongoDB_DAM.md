# 🚀 Proyecto Práctico: Introducción a MongoDB
**Módulo:** Bases de Datos (1º DAM)
**Duración estimada:** 4-6 horas

## 📖 1. Introducción y Objetivos
Hasta ahora hemos trabajado con bases de datos relacionales (SQL). En este proyecto daremos el salto a las bases de datos **NoSQL**, concretamente aprenderemos a usar **MongoDB**, un motor de bases de datos orientado a documentos.

**Objetivos de aprendizaje:**
* Comprender la diferencia entre tablas (SQL) y colecciones/documentos (NoSQL).
* Familiarizarse con el formato JSON/BSON.
* Realizar operaciones CRUD (Crear, Leer, Actualizar, Borrar) utilizando la consola (Mongo Shell) o MongoDB Compass.

---

## 🛠️ 2. Requisitos y Preparación
Antes de empezar, asegúrate de tener el entorno preparado:
1. **Opción A (Local):** Tener instalado MongoDB Community Server y MongoDB Compass.
2. **Opción B (Nube):** Haber creado un clúster gratuito en **MongoDB Atlas** y conectarse mediante MongoDB Compass.

---

## 🎬 3. Caso de Estudio: "StreamFlix"
Vamos a crear el backend de datos de una nueva plataforma de streaming llamada **StreamFlix**. En MongoDB no tenemos un esquema rígido, pero es buena práctica tener claro qué vamos a guardar.

Trabajaremos con una base de datos llamada `streamflix_db` y dos colecciones principales:
1. `usuarios`: Guardará la información de los clientes.
2. `contenidos`: Guardará las películas y series disponibles.

---

## ⚙️ 4. Fases del Proyecto

### Fase 1: Creación e Inserción de Datos (Create)

Abre tu entorno de MongoDB y crea la base de datos `streamflix_db` y las colecciones mencionadas. Luego, realiza las siguientes inserciones.

**1.1. Insertar Usuarios:**
Inserta al menos **3 usuarios**. Cada usuario debe tener una estructura JSON similar a esta:
```json
{
  "nombre": "Ana García",
  "email": "ana.garcia@email.com",
  "plan": "Premium",
  "fecha_registro": new Date(),
  "perfiles": ["Ana", "Kids"],
  "activo": true
}
```

**1.2. Insertar Contenidos (InsertMany):**
Inserta de golpe al menos **5 contenidos** (mezcla películas y series).
Ejemplo de estructura de un contenido:
```json
{
  "titulo": "El Retorno del Rey",
  "tipo": "Pelicula",
  "generos": ["Fantasía", "Aventura"],
  "anyo": 2003,
  "director": "Peter Jackson",
  "valoracion": 9.0,
  "visualizaciones": 1500000
}
```

### Fase 2: Consultas de Datos (Read)

Escribe y prueba las siguientes consultas `find()`:

1. Muestra todos los contenidos disponibles en la plataforma.
2. Busca a un usuario específico por su `email`.
3. Encuentra todas las películas (tipo: "Pelicula").
4. Encuentra todos los contenidos del género "Fantasía" (búsqueda en arrays).
5. Encuentra los contenidos estrenados *después* del año 2010 (usa el operador `$gt`).
6. Encuentra los contenidos con una valoración *mayor o igual* a 8.5 (usa el operador `$gte`).

### Fase 3: Actualización de Datos (Update)

Escribe las operaciones necesarias para:

1. Un usuario ha cambiado su plan de "Básico" a "Premium". Actualiza su documento (usa `$set`).
2. Una película ha tenido mucho éxito hoy. Incrementa en 50.000 sus `visualizaciones` (usa el operador `$inc`).
3. Añade un nuevo género ("Premiada") a una película que te guste (usa el operador `$push`).
4. **UpdateMany:** Una serie ha sido cancelada. Actualiza todos los documentos de esa serie para añadir un campo `"estado": "Cancelada"`.

### Fase 4: Borrado de Datos (Delete)

1. Un usuario ha decidido darse de baja. Elimina su documento por su `email` (`deleteOne`).
2. Elimina todos los contenidos que tengan una valoración inferior a 5.0 (`deleteMany`).

---

## 🌟 5. Reto Extra (Para subir nota)
1. **Proyecciones:** Modifica una de tus consultas para que *solo* devuelva el título y el año de las películas (oculta el campo `_id` y el resto de información).
2. **Ordenación y Límite:** Obtén el "Top 3" de contenidos más vistos (ordena de forma descendente por `visualizaciones` y limita el resultado a 3 con `.sort()` y `.limit()`).

---

## 📦 6. Entregables
Deberás entregar a tu profesor:
1. Un archivo **`.js` o `.txt`** llamado `streamflix_consultas.js` que contenga todos los comandos que has ejecutado en cada fase debidamente comentados.
2. Un documento **PDF** con capturas de pantalla de MongoDB Compass o de tu consola demostrando que las inserciones, consultas y modificaciones han ejecutado correctamente.

---

## 📊 7. Criterios de Evaluación
| Criterio | Puntuación Max |
| :--- | :--- |
| Creación de base de datos e inserción correcta de documentos (JSON válido) | 3 puntos |
| Uso correcto de consultas simples y filtrado (operadores lógicos) | 3 puntos |
| Actualización de datos (uso de `$set`, `$inc`, etc.) | 2 puntos |
| Borrado correcto de documentos | 1 punto |
| Formato de entrega, limpieza del código e intento del Reto Extra | 1 punto |
