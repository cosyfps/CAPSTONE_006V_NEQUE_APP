# Ñeque — Portafolio de Título (CAPSTONE)

**Ñeque** es una app móvil híbrida para entrenadores personales: acceso invitation-only,
recuperación de contraseña y un panel de entrenador para gestionar dashboard, clientes,
rutinas y perfil. Resuelve la falta de una herramienta simple y propia para que un
entrenador personal administre a sus clientes y sus rutinas desde el celular, sin
depender de planillas sueltas o WhatsApp.

Este repositorio es el **contenedor de evidencias académicas** de la asignatura CAPSTONE
(Instructivo Capstone 46104, Duoc UC) para el proceso de Portafolio de Título — no
contiene código de la aplicación. El código vive en dos repositorios aparte:

| Componente | Repositorio | Stack |
| ---------- | ----------- | ----- |
| Frontend (app móvil) | [ui-any-neque-mobile-app](https://github.com/cosyfps/ui-any-neque-mobile-app) | Angular 17 + Ionic 8 + Capacitor 6 |
| BFF (backend) | [bff-any-neque-mobile-app](https://github.com/cosyfps/bff-any-neque-mobile-app) | NestJS (arquitectura hexagonal) + Supabase |

## Tecnologías utilizadas

| Categoría | Tecnología |
| --------- | ---------- |
| Frontend | Angular 17 (standalone + signals), Ionic 8, Capacitor 6 (Android/iOS), SCSS con design tokens propios |
| Backend | NestJS con arquitectura hexagonal (vertical slicing por feature), TypeScript |
| Datos y Auth | Supabase (Postgres + Auth), acceso vía `service_role` solo desde el BFF |
| Pagos (a futuro) | Flow.cl |
| Testing | Jest 29 en ambos repos (umbral de cobertura 80%) |
| Calidad | ESLint + Prettier + Husky + commitlint |
| CI/CD | GitHub Actions |

## Arquitectura de la solución

```
App Ñeque (Angular 17 + Ionic + Capacitor)
        │  HTTP + JWT propio
        ▼
   BFF NestJS  ──service_role──> Supabase (Postgres + Auth)
               └──────────────> Flow.cl u otras APIs (a futuro)
```

La app nunca habla directo con Supabase: todo pasa por el BFF, que agrega las
credenciales privilegiadas detrás de un único contrato HTTP para que ninguna clave
sensible viaje en el binario de la app.

## Cómo ejecutar el proyecto localmente

El código ejecutable está en los dos repos enlazados arriba; cada uno trae su propio
README con el detalle completo. En resumen:

```bash
# Frontend
git clone https://github.com/cosyfps/ui-any-neque-mobile-app.git
cd ui-any-neque-mobile-app
npm ci
npm start          # http://localhost:4200

# BFF
git clone https://github.com/cosyfps/bff-any-neque-mobile-app.git
cd bff-any-neque-mobile-app
npm install
cp .env.example .env
npm run start:dev  # http://localhost:3000
```

## Integrantes del equipo

| Integrante | Rol |
| ---------- | --- |
| Kelvin Moreno | Full-stack |
| Benjamin Hidalgo | Product Owner (PO), Business Analyst (BA), Scrum Master |

## Metodología de trabajo

El equipo trabaja con **metodología Ágil (Scrum/Kanban)**. El ciclo de tres fases de la
asignatura (Fase 1: definición 20%, Fase 2: desarrollo 50%, Fase 3: presentación 30%)
enmarca los sprints y las entregas sumativas del ramo.

## Estructura de este repositorio

Las evidencias se organizan por Fase y, dentro de cada Fase, por tipo de entrega —
siguiendo la tabla oficial de entregables de la asignatura.

```
Fase 1/
├── Evidencias Individuales/   → autoevaluación de competencias, diario de reflexión y
│                                 autoevaluación de cada integrante (3 docs x 2 personas)
└── Evidencias Grupales/       → formativa, guía de estudiante (ES/EN) y presentación

Fase 2/
├── Evidencias Individuales/   → diario de reflexión de cada integrante
├── Evidencias Grupales/       → guías de estudiante de avance e informe final (ES/EN)
│                                 y planillas de evaluación de avance y final
└── Evidencias Proyecto/       → presentación, evidencias de documentación y evidencias
                                  de sistema (Aplicación / Base de datos)

Fase 3/
├── Evidencias Individuales/   → diario de reflexión de cada integrante
└── Evidencias Grupales/       → planilla de evaluación y presentación final (ES/EN)
```

Cada archivo listado en las carpetas ya está creado como placeholder vacío con el nombre
exacto que exige la asignatura (`Apellido_Nombre_X.Y_APT122_...` para las evidencias
individuales); el equipo reemplaza cada uno por el documento real a medida que avanza
cada fase.

> La `PLANILLA DE EVALUACIÓN FASE 1.xlsx` no vive en este repositorio: según la tabla
> oficial de entregables se envía directamente por correo al/la docente, no se sube aquí.

## Referencia

Este repositorio y su estructura de evidencias siguen el **Instructivo Capstone 46104**
de Duoc UC (Escuela de Informática y Telecomunicaciones). El repositorio se mantiene
**público** desde el inicio de la asignatura y debe permanecer activo hasta la semana 18,
cuando se realiza la extracción final del proyecto.
