# Diagramas UML

Los diagramas UML representan la estructura y el comportamiento del sistema Ñeque. Cada
diagrama existe como fuente PlantUML (`.puml`) en esta carpeta y, para verlo directamente en
GitHub, también en Mermaid dentro de este documento.

| Diagrama                         | Fuente                                                         | Imagen                                                             |
| -------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------ |
| Casos de uso                     | [`casos-de-uso.puml`](casos-de-uso.puml)                       | [`DIAGRAMA UML - CASOS DE USO.png`](DIAGRAMA%20UML%20-%20CASOS%20DE%20USO.png) |
| Secuencia: ejecutar entrenamiento | [`secuencia-entrenamiento.puml`](secuencia-entrenamiento.puml) | [`DIAGRAMA UML - FLUJO ENTRENAMIENTO.png`](DIAGRAMA%20UML%20-%20FLUJO%20ENTRENAMIENTO.png) |
| Componentes (arquitectura)       | [`componentes.puml`](componentes.puml)                         | Mermaid abajo                                                      |
| Clases del dominio               | Mermaid abajo                                                  | Mermaid abajo                                                      |

El modelo entidad-relación de la base de datos está en [`../modelo-datos.md`](../modelo-datos.md).

## 1. Casos de uso

Actores: **Entrenador** y **Alumno** (el **Administrador** da de alta entrenadores por script,
sin interfaz en el MVP).

| Entrenador                                         | Alumno                                                   |
| -------------------------------------------------- | -------------------------------------------------------- |
| Iniciar sesión y recuperar contraseña              | Aceptar invitación y crear contraseña                    |
| Registrar alumno e invitarlo por enlace o QR       | Ver la sesión del día y su rutina                        |
| Ver, buscar, editar, suspender y reactivar alumnos | Ejecutar el entrenamiento serie por serie                |
| Registrar anamnesis y evaluaciones físicas         | Registrar repeticiones y peso reales, o saltar ejercicio |
| Crear, duplicar y asignar rutinas                  | Mover un entrenamiento a otro día libre                  |
| Gestionar ejercicios propios                       | Ver progreso: peso, IMC, fotos y cargas                  |
| Agendar, reagendar y cancelar citas                | Ver agenda, confirmar o cancelar citas                   |
| Enviar mensajes al alumno                          | Enviar mensajes al entrenador y ver notificaciones       |

## 2. Secuencia: ejecución de un entrenamiento

```mermaid
sequenceDiagram
    actor A as Alumno
    participant App as App Ñeque
    participant BFF as BFF Hono (/api/v1)
    participant DB as Supabase
    A->>App: Inicia sesión
    App->>BFF: POST /auth/login
    BFF->>DB: Valida credenciales (Auth)
    DB-->>BFF: JWT + perfil
    BFF-->>App: Sesión con rol student
    A->>App: Abre "Mi rutina"
    App->>BFF: GET /students/:id/routine
    BFF->>DB: Rutina activa, días y ejercicios
    BFF-->>App: Rutina del día
    A->>App: Comenzar
    App->>BFF: POST /workouts/:id/start
    loop Por cada serie
        A->>App: Confirma reps y peso reales
        App->>BFF: POST /workouts/:id/exercises/:exerciseId/sets
        BFF->>DB: workout_sets
        App->>App: Temporizador de descanso
    end
    A->>App: Finalizar
    App->>BFF: POST /workouts/:id/complete
    BFF->>DB: status = completed
    BFF-->>App: Resumen de la sesión
```

## 3. Componentes

```mermaid
flowchart LR
    subgraph APP["App móvil · Angular 17 + Capacitor 6"]
        UI["ui/"] --> APPL["application/<br/>facades"]
        APPL --> DOM["domain/<br/>modelos + puertos"]
        INF["infrastructure/<br/>adapters HTTP"] -. implementa .-> DOM
    end
    subgraph BFF["BFF · Hono en Vercel"]
        HTTP["http/<br/>rutas + zod"] --> BAPP["application/<br/>casos de uso"]
        BAPP --> BDOM["domain/<br/>reglas puras"]
        BAPP --> BINF["infrastructure/<br/>Supabase, mappers, cifrado"]
    end
    subgraph SB["Supabase"]
        PG[("PostgreSQL + RLS")]
        AUTH["Auth (JWT)"]
        ST["Storage"]
    end
    INF -- "HTTPS + JWT" --> HTTP
    BINF --> PG
    BINF --> AUTH
    BINF --> ST
```

La regla de dependencias es la de la arquitectura hexagonal: `domain` no depende de nadie;
`application` solo de `domain`; `infrastructure` implementa los puertos de `domain`; `ui`
usa `application` y `domain`.

## 4. Clases del dominio

```mermaid
classDiagram
    class Trainer {
        +id
        +firstName
        +lastName
        +plan: free|pro
    }
    class Student {
        +id
        +firstName
        +status: active|suspended
        +goal
    }
    class Invitation {
        +token
        +expiresAt
        +status
    }
    class Routine {
        +id
        +name
        +goal
    }
    class RoutineDay {
        +weekday
        +title
        +startTime
    }
    class RoutineExercise {
        +sets
        +reps
        +weightKg
        +restSeconds
    }
    class Exercise {
        +name
        +muscleGroup
        +equipment
    }
    class WorkoutSession {
        +scheduledDate
        +status
        +durationMinutes
    }
    class WorkoutSet {
        +setNumber
        +reps
        +weightKg
        +skipped
    }
    class Assessment {
        +takenAt
        +weightKg
        +bodyFatPct
    }
    class Anamnesis {
        +medicalHistory
        +injuries
        +medications
    }
    Trainer "1" --> "*" Student : gestiona
    Student "1" --> "*" Invitation
    Student "1" --> "0..1" Anamnesis
    Student "1" --> "*" Assessment
    Trainer "1" --> "*" Routine : construye
    Routine "1" *-- "1..7" RoutineDay
    RoutineDay "1" *-- "*" RoutineExercise
    RoutineExercise "*" --> "1" Exercise
    Student "1" --> "0..1" Routine : rutina activa
    Student "1" --> "*" WorkoutSession : ejecuta
    WorkoutSession "1" *-- "*" WorkoutSet
```
