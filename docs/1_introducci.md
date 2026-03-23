# 0. Introducción

- **Lenguaje de control de datos (DCL, Data Control Language)**, es el encargado de establecer los mecanismos de control. Ofrece soluciones a los problemas de concurrencia de los usuarios y garantiza la seguridad de los datos.

El lenguaje SQL es un lenguaje declarativo, es decir, no es imperativo o procedimental. SQL indica qué se quiere hacer, pero no cómo se debe hacer. Por esta razón, necesita apoyarse en otro lenguaje procedimental que proporcione las instrucciones necesarias al sistema para realizar una serie de operaciones.

Este apartado se centra en el lenguaje de control de datos (DCL). Se encarga de todas las instrucciones relacionadas con la administración de la base de datos:

- creación de usuarios  
- asignación de privilegios  
- accesos  
- tuning  
- …  

Este lenguaje puede resumir sus **funcionalidades** en dos:

1) Ofrecer acciones para llevar a cabo transacciones  
2) Ofrecer soluciones para garantizar la seguridad de los datos  

Estas dos funcionalidades son clave para resolver los problemas derivados de una de las características más importantes de una base de datos: **la capacidad de ser multiusuario**. El acceso simultáneo de varios usuarios a los mismos datos puede dar lugar a problemas importantes, como la protección de la información y la asignación de privilegios. Por ello, requiere un tratamiento específico.

Estas funcionalidades están directamente relacionadas con los conceptos de *confidencialidad*, *integridad* y *disponibilidad*:

- La posibilidad de asignar **permisos a los usuarios** para acceder a parte de la información proporciona una solución al problema de la confidencialidad.  
- La posibilidad de ejecutar consultas (*queries*) mediante **transacciones** ofrece soluciones a los problemas de integridad y disponibilidad.