# Ñeque — Portafolio de Título (CAPSTONE)

**Ñeque** es una aplicación móvil (iOS, Android y web) para **entrenadores personales y sus
alumnos**. El entrenador gestiona su cartera, registra anamnesis y evaluaciones físicas,
construye rutinas y las asigna; el alumno ve su rutina del día, la ejecuta guiado serie por
serie registrando la carga real y sigue su progreso.

Resuelve un problema concreto: los entrenadores independientes trabajan con planillas,
WhatsApp y papel, por lo que la información del alumno se pierde, el seguimiento no escala y
el progreso no es demostrable. Ñeque reúne planificación, ejecución y seguimiento en una sola
herramienta. Ver [Innovación](docs/innovacion.md).

| Dato        | Valor                                                      |
| ----------- | ---------------------------------------------------------- |
| Asignatura  | Capstone (PTY4614) — Sección PTY4614-006, sede Plaza Norte |
| Docente     | Álvaro Mellado                                             |
| Equipo      | 9                                                          |
| Metodología | **Scrum** — ver [metodología](docs/metodologia.md)         |

## Repositorios

Este repositorio es el **contenedor de evidencias académicas y documentación**. El código de
la aplicación (app móvil, BFF y migraciones de base de datos) vive en un único repositorio:

| Componente                     | Repositorio                                                                                  |
| ------------------------------ | -------------------------------------------------------------------------------------------- |
| App móvil, BFF y base de datos | [cosyfps/api-any-neque-mobile-app](https://github.com/cosyfps/api-any-neque-mobile-app)      |
| Evidencias y documentación     | [cosyfps/CAPSTONE_006V_NEQUE_APP](https://github.com/cosyfps/CAPSTONE_006V_NEQUE_APP) (este) |

## Tecnologías

| Categoría     | Tecnología                                                                                     |
| ------------- | ---------------------------------------------------------------------------------------------- |
| App móvil     | Angular 17 (standalone + signals) y Capacitor 6 (iOS/Android), SCSS con design tokens propios |
| BFF (backend) | Hono + TypeScript, validación con zod, función serverless en Vercel                            |
| Datos y Auth  | Supabase: PostgreSQL con Row Level Security, Auth (JWT) y Storage                              |
| Testing       | Jest 29: 1.725 pruebas, 97% de cobertura de líneas (umbral 80%)                                |
| Calidad       | ESLint, Prettier, Husky y commitlint (Conventional Commits)                                    |
| CI/CD         | GitHub Actions (quality gate e IPA iOS) y Vercel                                               |
| Contenedores  | Docker + Docker Compose (Nginx para el front, Node para el BFF)                                |

## Arquitectura

```
App Ñeque (Angular 17 + Capacitor 6)      hexagonal: domain / application / infrastructure / ui
        │  HTTPS /api/v1 + JWT
        ▼
BFF Hono (función serverless en Vercel)   http → application → domain / infrastructure
        │  clave de servicio (solo servidor)
        ▼
Supabase: PostgreSQL + RLS · Auth · Storage
```

La app nunca habla directo con Supabase: todo pasa por el BFF, que resuelve identidad y rol
desde el JWT, para que ninguna clave sensible viaje en el binario. Detalle en los
[diagramas UML](docs/uml/uml.md) y el [modelo de datos](docs/modelo-datos.md).

## Cómo levantar el proyecto

### Con Docker (desde este repositorio)

```bash
cp .env.example .env      # completar con las claves del proyecto Supabase
docker compose up --build
```

- App web: http://localhost:8080
- BFF: http://localhost:3000/api/v1/health

El [`Dockerfile`](Dockerfile) clona el repositorio de la aplicación, sirve el BFF con Node y el
front compilado con Nginx ([`docker/nginx.conf`](docker/nginx.conf)), que reenvía `/api` al BFF.

### Sin Docker

```bash
git clone https://github.com/cosyfps/api-any-neque-mobile-app.git
cd api-any-neque-mobile-app
npm ci
cp .env.example .env.local   # completar con las claves de Supabase
npm run dev:api              # BFF en http://localhost:3000/api/v1
npm start                    # app en http://localhost:4200
```

Instalación completa, base de datos, despliegue y build nativo en el
[manual técnico](docs/manual-tecnico.md).

## Documentación técnica

| Documento                                                      | Contenido                                             |
| -------------------------------------------------------------- | ----------------------------------------------------- |
| [Product Vision](docs/product-vision.md)                       | Problema, público objetivo y propuesta de valor       |
| [Metodología](docs/metodologia.md)                             | Scrum: roles, artefactos, eventos y prácticas         |
| [Product Backlog](docs/product-backlog.md)                     | Historias de usuario priorizadas                      |
| [Sprint Backlog](docs/sprint-backlog.md)                       | Sprints, objetivos y estado                           |
| [Definition of Done](docs/definition-of-done.md)               | Criterios de terminado                                |
| [Retrospectivas](docs/retrospectivas.md)                       | Aprendizajes y acciones de mejora                     |
| [Requisitos no funcionales](docs/requisitos-no-funcionales.md) | Seguridad, rendimiento, usabilidad y otros            |
| [Modelo de datos](docs/modelo-datos.md)                        | Diagrama entidad-relación, tablas y reglas de negocio |
| [Diagramas UML](docs/uml/uml.md)                               | Casos de uso, secuencia, componentes y clases         |
| [Plan de pruebas](docs/pruebas.md)                             | Tipos de prueba, CI y resultados de cobertura         |
| [Manual técnico](docs/manual-tecnico.md)                       | Instalación, configuración, despliegue y build nativo |
| [Innovación](docs/innovacion.md)                               | Qué resuelve, qué lo diferencia y qué valor agrega    |

## Integrantes del equipo

| Integrante       | Rol                                               |
| ---------------- | ------------------------------------------------- |
| Kelvin A. Moreno | Desarrollador full-stack y líder técnico          |
| Benjamin Hidalgo | Product Owner, Analista de Negocio y Scrum Master |
| Daniel Aravena   | QA, documentación y diseño de datos               |

## Estructura de este repositorio

Las evidencias se organizan por fase y, dentro de cada fase, por tipo de entrega, siguiendo la
tabla oficial de entregables de la asignatura.

```
Fase 1/
├── Evidencias Individuales/   → autoevaluación de competencias, diario de reflexión y autoevaluación
└── Evidencias Grupales/       → formativa 1.4, guía 1.5 (definición del proyecto) y presentación
Fase 2/
├── Evidencias Individuales/   → diario de reflexión de cada integrante
├── Evidencias Grupales/       → guía 2.4 (avance), guía 2.6 (informe final) y planillas de evaluación
└── Evidencias Proyecto/       → presentación, evidencias de documentación y de sistema
Fase 3/
├── Evidencias Individuales/   → diario de reflexión de cada integrante
└── Evidencias Grupales/       → orientaciones 3.3, planilla de evaluación y presentación final
docs/                          → documentación técnica (tabla de arriba)
Dockerfile, docker-compose.yml, .env.example, docker/   → entorno con contenedores
```

> La `PLANILLA DE EVALUACIÓN FASE 1.xlsx` no vive en este repositorio: según la tabla oficial
> de entregables se envía por correo al docente. Las versiones en inglés de las guías son
> optativas y el equipo no las presenta.

## Referencia

Este repositorio sigue el **Instructivo Capstone 46104** de Duoc UC (Escuela de Informática y
Telecomunicaciones). Se mantiene **público** y activo hasta la semana 18, cuando se realiza la
extracción final del proyecto.
