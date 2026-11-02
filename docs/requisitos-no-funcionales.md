# Requisitos No Funcionales

Los requisitos no funcionales definen características de calidad y comportamiento esperadas para el sistema Ñeque.

## RNF01 - Seguridad

El sistema debe requerir autenticación para acceder a las funcionalidades asociadas a entrenadores y alumnos.

Los usuarios solo deben poder acceder a la información correspondiente a su rol y relaciones dentro de la plataforma.

El sistema debe alinearse con la ley

## RNF02 - Protección de datos

La información de los usuarios debe almacenarse de forma segura y no debe exponerse información sensible directamente desde el sistema.

## RNF03 - Rendimiento

Las principales operaciones del sistema, como iniciar sesión, visualizar alumnos, consultar entrenamientos o registrar ejercicios, deben responder en un tiempo razonable bajo condiciones normales de uso.

Como referencia, las operaciones habituales deberían completarse idealmente en menos de 3 segundos.

## RNF04 - Disponibilidad

El sistema debe encontrarse disponible para los usuarios mientras los servicios asociados a la aplicación, base de datos e infraestructura se encuentren operativos.

## RNF05 - Usabilidad

La interfaz debe ser clara y sencilla de utilizar tanto para entrenadores como para alumnos.

Las acciones principales deben poder ser identificadas fácilmente sin requerir conocimientos técnicos.

## RNF06 - Compatibilidad

La aplicación debe poder ser utilizada desde dispositivos móviles modernos.

En caso de existir una versión web, esta debe ser compatible con navegadores modernos como Google Chrome, Microsoft Edge y Safari.

## RNF07 - Escalabilidad

La arquitectura debe permitir incorporar nuevos usuarios, entrenadores, alumnos y funcionalidades sin requerir una reestructuración completa del sistema.

## RNF08 - Mantenibilidad

El código debe mantenerse organizado de manera modular y utilizar convenciones consistentes que faciliten futuras modificaciones.

## RNF09 - Integridad de la información

El sistema debe mantener relaciones consistentes entre usuarios, entrenamientos, ejercicios y registros de progreso.

Se deben evitar registros incompletos o asociaciones inválidas dentro de la base de datos.

## RNF10 - Control de versiones

El código fuente del proyecto debe mantenerse bajo control de versiones para registrar los cambios realizados durante el desarrollo.

Para este proyecto se utiliza Git como sistema de control de versiones y GitHub como repositorio remoto.