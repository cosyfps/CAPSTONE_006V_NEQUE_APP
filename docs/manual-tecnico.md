# Manual técnico

Guía de instalación, configuración y despliegue de Ñeque. El código está en
[`cosyfps/api-any-neque-mobile-app`](https://github.com/cosyfps/api-any-neque-mobile-app).

## 1. Requisitos

| Herramienta          | Versión / nota                                     |
| -------------------- | -------------------------------------------------- |
| Node.js              | 22 o superior                                      |
| npm                  | Incluido con Node                                  |
| Git                  | Cualquier versión reciente                         |
| Proyecto Supabase    | Base de datos, Auth y Storage                      |
| Docker (opcional)    | Para levantar todo con `docker compose`            |
| Xcode + macOS        | Solo para compilar iOS en local (alternativa: CI)  |
| Android Studio       | Solo para compilar la app Android                  |

## 2. Variables de entorno

Se copian desde `.env.example` a `.env.local` (desarrollo) o a las variables del proyecto en
Vercel (producción). **Nunca se versionan.**

| Variable                   | Uso                                                        |
| -------------------------- | ---------------------------------------------------------- |
| `SUPABASE_URL`             | URL del proyecto Supabase                                  |
| `SUPABASE_PUBLISHABLE_KEY` | Clave pública del proyecto                                 |
| `SUPABASE_SECRET_KEY`      | Clave secreta; solo en el servidor (BFF)                   |
| `ALLOWED_ORIGINS`          | Orígenes web permitidos por CORS, separados por coma       |
| `NEQUE_WEB_ACCESS`         | Acceso desde navegador en Vercel: `off` o `mobile`         |

## 3. Base de datos

1. Crear un proyecto en Supabase.
2. Aplicar las migraciones de `supabase/migrations/` en orden (CLI de Supabase:
   `supabase db push`, o pegándolas en el editor SQL).
3. Crear el primer entrenador (el alta de entrenadores es por script):

```bash
TRAINER_PASSWORD='<contraseña segura>' npm run create:trainer -- <correo> <nombre> [apellido]
```

El modelo está documentado en [`modelo-datos.md`](modelo-datos.md).

## 4. Ejecución local

```bash
git clone https://github.com/cosyfps/api-any-neque-mobile-app.git
cd api-any-neque-mobile-app
npm ci
cp .env.example .env.local   # completar con las claves de Supabase
npm run dev:api              # BFF en http://localhost:3000/api/v1
npm start                    # app en http://localhost:4200 (proxy /api -> :3000)
```

### Con Docker

Desde la raíz de este repositorio (Capstone):

```bash
cp .env.example .env         # completar con las claves de Supabase
docker compose up --build
```

- App web: `http://localhost:8080`
- BFF: `http://localhost:3000/api/v1/health`

El `Dockerfile` clona el repositorio de la aplicación (argumentos `APP_REPO` y `APP_REF`), sirve
el BFF con Node y el front compilado con Nginx, que reenvía `/api` al BFF.

## 5. Validaciones de calidad

```bash
npm run lint
npm run format:check
npm run typecheck
npm run test:coverage   # umbral 80% en las 4 métricas
npm run build:prod
```

Las mismas validaciones corren en GitHub Actions (`ci-gate`) en cada pull request. Detalle en
[`pruebas.md`](pruebas.md).

## 6. Despliegue

- **Vercel:** el proyecto usa `npm run build:vercel`, que genera el front estático y empaqueta
  el BFF como una única función bajo `/api/v1` (región `gru1`, São Paulo). Las variables de la
  sección 2 se configuran en *Project Settings → Environment Variables*.
- **Supabase:** las migraciones nuevas se agregan como archivos nuevos en
  `supabase/migrations/`; nunca se edita una migración existente.

## 7. Build nativo

Las carpetas nativas no se versionan; se generan con `npx cap add ios` / `npx cap add android`.

```bash
npm run cap:build       # build de producción + copia a las plataformas nativas
npx cap open ios        # abre Xcode (requiere macOS)
npx cap open android    # abre Android Studio
```

Sin Mac, la IPA de prueba se genera con el workflow manual `ios-ipa.yml` de GitHub Actions
(runner macOS, IPA sin firmar) y se instala en el iPhone con Sideloadly usando un Apple ID
gratuito (la instalación caduca a los 7 días).

## 8. Estructura del código

```
src/app/
├── domain/          # modelos + puertos (interfaz + InjectionToken)
├── application/     # facades con signals (casos de uso)
├── infrastructure/  # adapters HTTP al BFF
└── ui/              # páginas y componentes (auth, trainer, student, shared)
server/              # BFF Hono: http/, application/, domain/, infrastructure/, scripts/
supabase/migrations/ # esquema, funciones, storage y catálogo de ejercicios
```
