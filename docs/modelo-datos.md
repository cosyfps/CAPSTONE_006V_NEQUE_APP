# Modelo de datos

Ñeque persiste sus datos en **PostgreSQL** administrado por **Supabase**. El esquema se
define con migraciones SQL versionadas en el repositorio de la aplicación
([`supabase/migrations/`](https://github.com/cosyfps/api-any-neque-mobile-app/tree/develop/supabase/migrations)):

| Migración                              | Contenido                                                   |
| -------------------------------------- | ----------------------------------------------------------- |
| `20261102000000_schema.sql`            | Enumeraciones, tablas, claves, índices y políticas RLS      |
| `20261102000100_functions.sql`         | Funciones transaccionales: `save_routine`, `set_routine_assignments`, `save_workout_session` |
| `20261102000200_storage.sql`           | Buckets de Storage para avatares y fotos de progreso        |
| `20261102000300_exercise_catalog.sql`  | Catálogo inicial de ejercicios                              |
| `20261103000000_active_session.sql`    | Sesión única por cuenta                                     |
| `20261104000000_routine_day_start_time.sql` | Hora de inicio por día de rutina                       |
| `20261104000100_messages.sql`          | Mensajes entre entrenador y alumno                          |
| `20261104000200_messages_encrypted.sql`| Cifrado del cuerpo de los mensajes                          |

En total: **21 tablas** y **16 enumeraciones**. Todas las claves primarias son UUID (salvo
tokens), los tiempos se guardan en UTC (`timestamptz`) y el borrado de rutinas, ejercicios y
fotos es lógico (`deleted_at`).

## Diagrama entidad-relación

```mermaid
erDiagram
    AUTH_USERS ||--|| PROFILES : "tiene"
    PROFILES ||--o| TRAINERS : "es"
    PROFILES ||--o| STUDENTS : "es"
    TRAINERS ||--o{ STUDENTS : "gestiona"
    STUDENTS ||--o{ INVITATIONS : "recibe"
    STUDENTS ||--o| ANAMNESIS : "tiene"
    STUDENTS ||--o{ ASSESSMENTS : "evaluado en"
    TRAINERS ||--o{ ASSESSMENTS : "registra"
    TRAINERS ||--o{ EXERCISES : "crea (propios)"
    TRAINERS ||--o{ ROUTINES : "construye"
    ROUTINES ||--o{ ROUTINE_DAYS : "se divide en"
    ROUTINE_DAYS ||--o{ ROUTINE_EXERCISES : "contiene"
    EXERCISES ||--o{ ROUTINE_EXERCISES : "se prescribe en"
    ROUTINES ||--o{ ROUTINE_ASSIGNMENTS : "se asigna"
    STUDENTS ||--o{ ROUTINE_ASSIGNMENTS : "recibe"
    STUDENTS ||--o{ WORKOUT_SESSIONS : "ejecuta"
    ROUTINE_DAYS ||--o{ WORKOUT_SESSIONS : "origina"
    WORKOUT_SESSIONS ||--o{ WORKOUT_EXERCISE_LOGS : "registra"
    WORKOUT_EXERCISE_LOGS ||--o{ WORKOUT_SETS : "detalla series"
    STUDENTS ||--o{ PROGRESS_PHOTOS : "sube"
    STUDENTS ||--o{ SCHEDULED_SESSIONS : "agenda"
    TRAINERS ||--o{ SCHEDULED_SESSIONS : "agenda"
    STUDENTS ||--o{ MESSAGES : "conversa"
    TRAINERS ||--o{ MESSAGES : "conversa"
    AUTH_USERS ||--o{ NOTIFICATIONS : "recibe"
    AUTH_USERS ||--o{ DEVICE_TOKENS : "registra"
    AUTH_USERS ||--o{ PASSWORD_RESET_TICKETS : "solicita"

    PROFILES {
        uuid id PK
        user_role role
        citext email
        text display_name
    }
    TRAINERS {
        uuid id PK
        uuid user_id FK
        text first_name
        text last_name
        trainer_plan plan
    }
    STUDENTS {
        uuid id PK
        uuid user_id FK
        uuid trainer_id FK
        student_status status
        date birth_date
        numeric height_cm
        text goal
    }
    INVITATIONS {
        text token PK
        uuid student_id FK
        timestamptz expires_at
        invitation_status status
    }
    ANAMNESIS {
        uuid id PK
        uuid student_id FK "unico"
        text medical_history
        text previous_injuries
        text medications
        jsonb weekly_availability
    }
    ASSESSMENTS {
        uuid id PK
        uuid student_id FK
        uuid trainer_id FK
        timestamptz taken_at
        numeric weight_kg
        numeric body_fat_pct
    }
    EXERCISES {
        uuid id PK
        text name
        muscle_group muscle_group
        uuid owner_trainer_id FK "null = catalogo"
    }
    ROUTINES {
        uuid id PK
        uuid trainer_id FK
        text name
        text goal
    }
    ROUTINE_DAYS {
        uuid id PK
        uuid routine_id FK
        smallint weekday
        text title
    }
    ROUTINE_EXERCISES {
        uuid id PK
        uuid routine_day_id FK
        uuid exercise_id FK
        int sets
        int reps
        numeric weight_kg
        int rest_seconds
    }
    ROUTINE_ASSIGNMENTS {
        uuid id PK
        uuid routine_id FK
        uuid student_id FK
        date start_date
        timestamptz ended_at
    }
    WORKOUT_SESSIONS {
        uuid id PK
        uuid student_id FK
        uuid routine_day_id FK
        date scheduled_date
        workout_status status
    }
    WORKOUT_EXERCISE_LOGS {
        uuid id PK
        uuid workout_session_id FK
        uuid exercise_id FK
        int completed_sets
        boolean skipped
    }
    WORKOUT_SETS {
        uuid id PK
        uuid workout_exercise_log_id FK
        smallint set_number
        int reps
        numeric weight_kg
    }
    PROGRESS_PHOTOS {
        uuid id PK
        uuid student_id FK
        text storage_path
        photo_angle angle
    }
    SCHEDULED_SESSIONS {
        uuid id PK
        uuid student_id FK
        uuid trainer_id FK
        timestamptz starts_at
        schedule_status status
    }
    MESSAGES {
        uuid id PK
        uuid student_id FK
        uuid trainer_id FK
        text sender_role
        text body "cifrado"
    }
    NOTIFICATIONS {
        uuid id PK
        uuid user_id FK
        notification_kind kind
        target_type target_type
        uuid target_id
    }
```

> `login_attempts` (control de intentos de inicio de sesión) no tiene relaciones y se omite
> del diagrama.

## Entidades por área

| Área                | Tablas                                                                 |
| ------------------- | ---------------------------------------------------------------------- |
| Identidad y acceso  | `profiles`, `trainers`, `students`, `invitations`, `password_reset_tickets`, `login_attempts`, `device_tokens` |
| Ficha del alumno    | `anamnesis`, `assessments`, `progress_photos`                          |
| Rutinas             | `exercises`, `routines`, `routine_days`, `routine_exercises`, `routine_assignments` |
| Ejecución           | `workout_sessions`, `workout_exercise_logs`, `workout_sets`            |
| Agenda y contacto   | `scheduled_sessions`, `notifications`, `messages`                      |

## Reglas de negocio que garantiza la base

- Un alumno tiene **una sola rutina activa** a la vez (índice único parcial sobre
  `routine_assignments` sin `ended_at`); asignar una nueva archiva la anterior.
- Una rutina tiene **un solo día por día de la semana** (índice único `routine_id + weekday`).
- La anamnesis es **única por alumno** (`student_id unique`).
- La sesión ejecutada guarda una **copia de lo prescrito** (`workout_exercise_logs`): es un
  hecho histórico y no cambia si el entrenador edita la rutina después.
- Un alumno tiene **una sola invitación pendiente** y cada ejercicio ocupa una **posición
  única** dentro de su día.
- **Row Level Security** habilitado y cerrado en todas las tablas (`anon` y `authenticated`
  sin permisos): solo el BFF accede con la clave de servicio, resuelve el actor desde el JWT y
  filtra por entrenador o alumno.
- El cuerpo de los mensajes se guarda **cifrado** y lo descifra el BFF.

## Enumeraciones

`user_role`, `student_status`, `trainer_plan`, `invitation_status`, `muscle_group`,
`exercise_load`, `exercise_measure`, `workout_status`, `skip_reason`, `photo_angle`,
`session_kind`, `schedule_status`, `cancel_reason`, `notification_kind`, `target_type`,
`device_platform`.
