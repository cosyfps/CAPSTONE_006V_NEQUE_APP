# Plan de pruebas

Responsable: **Daniel Aravena** (QA). Aplica al repositorio de la aplicación
[`cosyfps/api-any-neque-mobile-app`](https://github.com/cosyfps/api-any-neque-mobile-app),
que contiene la app móvil y el BFF.

## 1. Objetivo

Certificar que cada funcionalidad de Ñeque cumple sus criterios de aceptación, que los
cambios no rompen lo que ya funciona y que la app se comporta bien en dispositivos reales,
antes de cada versión.

## 2. Tipos de prueba

| Tipo                          | Qué valida                                                                 | Herramienta                       | Cuándo                      |
| ----------------------------- | -------------------------------------------------------------------------- | --------------------------------- | --------------------------- |
| Unitarias de dominio          | Funciones puras: reglas de negocio, fechas, validadores, cálculos de gráficos | Jest 29                         | En cada pull request (CI) |
| Unitarias de aplicación       | Facades y casos de uso con puertos simulados (`of`, `throwError`): estados loading / error / empty / success | Jest + `@testing/typed-mock` | En cada pull request |
| Unitarias de infraestructura  | Adapters HTTP, interceptor de autenticación y traducción de errores       | Jest + `HttpTestingController`    | En cada pull request        |
| Unitarias de UI               | Páginas como clase y componentes compartidos renderizados                 | Jest + `jest-preset-angular`      | En cada pull request        |
| Unitarias del BFF             | Reglas del servidor (asignación de rutinas, sesiones, zonas horarias) y mappers fila ↔ modelo | Jest            | En cada pull request        |
| Estáticas                     | Estilo, formato y tipos de la app y del BFF                               | ESLint, Prettier, `tsc`           | En cada pull request        |
| Manuales funcionales          | Casos de prueba end-to-end por rol (entrenador y alumno)                   | Planilla de casos de prueba       | Antes de cada versión       |
| Visuales y accesibilidad      | Layout en 375×812 y 320×568, contraste WCAG AA, área táctil 44×44, navegación con `Tab` | Navegador + barrido manual | Cada pantalla nueva o modificada |
| En dispositivo                | Teclado, cámara, compartir, pantalla encendida, temporizadores en segundo plano | iPhone con la IPA            | Cada versión de la IPA      |

## 3. Criterios de aceptación de calidad

- Cobertura global **≥ 80%** en sentencias, ramas, funciones y líneas (umbral configurado en
  Jest; si baja, el CI falla).
- `lint` sin advertencias (`--max-warnings 0`), `format:check`, `typecheck` y `build:prod` en
  verde.
- Ningún caso de prueba manual crítico en estado fallido al cerrar una versión.
- Los tests de ejemplo del framework no cuentan: cada `*.spec.ts` prueba código propio.

## 4. Integración continua

El workflow `ci.yml` (GitHub Actions) corre en cada pull request hacia `develop` y `main`:
instalación con `npm ci` y verificación del lockfile → ESLint y Prettier → TypeScript (app y
BFF) → Jest con cobertura → build de producción. El check `ci-gate` es obligatorio para
mergear.

## 5. Resultados

Ejecución de `npm run test:coverage` del 6 de noviembre de 2026 sobre `develop`:

| Métrica                | Resultado               |
| ---------------------- | ----------------------- |
| Suites                 | 103 aprobadas de 103    |
| Pruebas                | 1.725 aprobadas de 1.725 |
| Cobertura de sentencias | 97,31% (5.553 / 5.706) |
| Cobertura de ramas     | 85,45% (1.621 / 1.897)  |
| Cobertura de funciones | 95,22% (1.575 / 1.654)  |
| Cobertura de líneas    | 97,47% (5.086 / 5.218)  |

Distribución de archivos de prueba por capa:

| Capa                         | Archivos `*.spec.ts` |
| ---------------------------- | -------------------: |
| `src/app/domain`             | 24 |
| `src/app/application`        | 15 |
| `src/app/infrastructure`     | 5 |
| `src/app/ui`                 | 53 |
| `server` (BFF)               | 5 |
| `src/app` (componente raíz)  | 1 |
| **Total**                    | **103** |

## 6. QA en dispositivo

Cada versión de la app iOS (IPA 0.0.1 a 0.0.12) se instaló en un iPhone y se recorrió con
los casos de prueba de la planilla (`docs/qa/casos-de-prueba-neque.pdf` del repositorio de la
aplicación). Los hallazgos se registraron como tickets en el backlog (Épica 13) y se
corrigieron en la versión siguiente. Ejemplos: el teclado tapaba el chat, la pantalla se
apagaba durante el entrenamiento y los temporizadores se detenían en segundo plano.

## 7. Cómo ejecutar las pruebas

```bash
npm ci
npm run test:coverage   # Jest con cobertura (umbral 80%)
npm run lint && npm run format:check && npm run typecheck
npx jest src/app/ui/auth/start/start.page.spec.ts   # una prueba puntual
```
