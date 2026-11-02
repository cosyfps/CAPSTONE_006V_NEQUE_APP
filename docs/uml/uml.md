# Diagramas UML

Los diagramas UML permiten representar de forma visual la estructura y el comportamiento del sistema Ñeque.

Para documentar el proyecto se consideran los siguientes diagramas:

## 1. Diagrama de Casos de Uso

Representa las principales interacciones entre los usuarios y el sistema.

Actores principales:

- Administrador.
- Entrenador.
- Alumno.

Casos de uso principales:

- Iniciar sesión.
- Crear entrenador.
- Invitar alumno.
- Gestionar alumnos.
- Crear entrenamiento.
- Asignar entrenamiento.
- Visualizar entrenamiento.
- Registrar ejecución de ejercicios.
- Registrar repeticiones y peso.
- Marcar ejercicios como realizados o saltados.
- Visualizar estadísticas y progreso.

## 2. Diagrama de Clases

Representa las principales entidades y relaciones del sistema.

Este diagrama se construirá a partir del modelo de datos y de la estructura implementada en el sistema.

## 3. Diagrama de Secuencia

Representa el flujo de interacción entre los componentes del sistema para una operación específica.

Como flujo principal se puede documentar la ejecución de un entrenamiento por parte de un alumno, considerando:

1. El alumno inicia sesión.
2. Consulta sus entrenamientos asignados.
3. Selecciona un entrenamiento.
4. Inicia su ejecución.
5. Registra repeticiones y peso.
6. Marca los ejercicios realizados o saltados.
7. Finaliza el entrenamiento.
8. El sistema registra el resultado y actualiza el progreso.