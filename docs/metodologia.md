# Metodología de desarrollo

> **Metodología declarada: Scrum** (marco de trabajo ágil), con sprints de dos semanas.

Para el desarrollo del proyecto se utilizó una metodología ágil basada en Scrum, adaptada a las necesidades y tamaño del equipo.

Se optó por este enfoque porque permitió organizar el trabajo de manera incremental, dividir el proyecto en tareas más pequeñas y realizar avances progresivos durante el desarrollo.

El trabajo fue organizado mediante un Product Backlog, donde se definieron las principales funcionalidades y requerimientos del sistema. A partir de este backlog, las tareas fueron distribuidas en distintas etapas de desarrollo o sprints.

Durante cada sprint se trabajó en funcionalidades específicas del sistema, permitiendo revisar los avances, detectar dificultades y realizar ajustes cuando fue necesario.

La metodología fue adaptada al contexto real del equipo, por lo que algunas ceremonias formales de Scrum no fueron realizadas de manera estricta. Sin embargo, se mantuvieron sus principales conceptos:

- Priorización de funcionalidades.
- División del trabajo en tareas pequeñas.
- Desarrollo incremental.
- Revisión continua de avances.
- Uso de control de versiones mediante GitHub.
- Coordinación entre los integrantes del equipo.

Esta metodología nos permite mantener una estructura de trabajo flexible y facilitar la evolución progresiva del proyecto.

## Por qué Scrum y no cascada

Ñeque es un producto nuevo: varios requerimientos (cómo registra un alumno su carga real, cómo
agenda un entrenador) se precisaron al construirlos y probarlos. Scrum permite entregar
incrementos funcionales en sprints cortos y repriorizar sin rehacer toda la planificación. Una
metodología en cascada exigiría congelar los requisitos al inicio, lo que no se ajusta a un
producto nuevo ni al plazo fijo de 18 semanas de la asignatura.

## Roles

| Integrante       | Rol Scrum                        | Responsabilidades                                                                                                    |
| ---------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Benjamin Hidalgo | Product Owner y Scrum Master     | Visión del producto, priorización del backlog, historias y criterios de aceptación; facilita los eventos. También es analista de negocio. |
| Kelvin A. Moreno | Equipo de desarrollo (líder técnico) | Arquitectura, desarrollo full-stack (app y BFF), base de datos, CI/CD y despliegue.                               |
| Daniel Aravena   | Equipo de desarrollo (QA y datos) | Plan y casos de prueba, QA en dispositivo, modelo de datos y documentación técnica.                                  |

## Artefactos

- [Product Vision](product-vision.md)
- [Product Backlog](product-backlog.md): épicas → historias de usuario → tickets, priorizados con MoSCoW.
- [Sprint Backlog](sprint-backlog.md): objetivo y elementos comprometidos por sprint.
- [Definition of Done](definition-of-done.md)
- [Retrospectivas](retrospectivas.md)

## Eventos

| Evento          | Frecuencia            | Propósito                                     |
| --------------- | --------------------- | --------------------------------------------- |
| Sprint          | 2 semanas             | Entregar un incremento funcional              |
| Sprint Planning | Inicio de cada sprint | Elegir y desglosar los tickets del sprint     |
| Daily           | Breve, por mensajería | Avance, siguiente paso e impedimentos         |
| Sprint Review   | Cierre de cada sprint | Demostrar el incremento y ajustar el backlog  |
| Retrospectiva   | Cierre de cada sprint | Qué funcionó, qué no y acciones de mejora     |

## Prácticas técnicas

- **Gitflow:** una rama por ticket (`<tipo>/NEQUE-<épica>.<historia>.<ticket>-<slug>`) desde
  `develop`; `main` y `develop` protegidas. Regla: 1 ticket = 1 rama = 1 pull request.
- **Conventional Commits** validados con commitlint.
- **Quality gate en GitHub Actions:** lint, formato, tipos, pruebas con cobertura ≥ 80% y build
  de producción antes de mergear.

## Fases de la asignatura

| Fase             | Semanas | Foco                                                       |
| ---------------- | ------- | ---------------------------------------------------------- |
| 1 · Definición   | S1–S4   | Problema, visión, backlog, arquitectura y plan de trabajo  |
| 2 · Desarrollo   | S5–S15  | Sprints de construcción, QA y despliegue                   |
| 3 · Presentación | S16–S18 | Informe final, presentación y demostración                 |