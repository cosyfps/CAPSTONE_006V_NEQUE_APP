# Innovación

## Qué problema resuelve

Los entrenadores personales independientes trabajan con herramientas desconectadas: una
planilla para las métricas, WhatsApp para comunicarse y papel o documentos sueltos para las
rutinas. El resultado es que la información del alumno se pierde, el seguimiento no escala y
el entrenador no puede demostrar el progreso que logra. Ñeque reúne en una sola aplicación la
planificación (entrenador), la ejecución (alumno) y el seguimiento (ambos).

## Qué lo hace diferente

| Diferenciador                                    | Por qué importa                                                                                                                                                                                                                       |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Registro de la carga real, no solo del check** | Cada serie se confirma con los valores prescritos ya precargados: si el alumno levantó lo previsto, cerrar la serie cuesta un toque; si no, corrige repeticiones o peso. El entrenador ve progresión real, no una lista de tareas marcadas. |
| **Ejecución guiada serie por serie**             | Pantalla completa con temporizador de descanso, pantalla siempre encendida y temporizadores que siguen en segundo plano.                                                                                                              |
| **Acceso solo por invitación**                   | El entrenador da de alta al alumno y le comparte un enlace o QR con vigencia de 48 horas; el alumno crea su propia contraseña y el entrenador nunca la conoce.                                                                         |
| **Ficha clínica con alerta**                     | Anamnesis (lesiones, medicación, antecedentes) y evaluaciones físicas; la app avisa de antecedentes clínicos antes de prescribir.                                                                                                    |
| **Mensajes cifrados en la base**                 | La conversación entrenador–alumno vive dentro de la app y su contenido se guarda cifrado.                                                                                                                                             |
| **Datos de salud protegidos por diseño**         | La app nunca habla directo con la base: todo pasa por un BFF que resuelve identidad y rol desde el JWT, con Row Level Security cerrado en todas las tablas.                                                                           |
| **Un solo código para iOS, Android y web**       | Angular + Capacitor, con accesibilidad WCAG AA y áreas táctiles de 44×44 px verificadas.                                                                                                                                              |
| **Modelo freemium**                              | Gratis hasta 3 alumnos activos: una alternativa en español y de bajo costo.                                                                                                                                                           |

## Valor que agrega

- **Al entrenador:** ordena su cartera, construye y reutiliza rutinas (biblioteca y duplicar),
  agenda citas y ve el historial real de cada alumno sin transcribir nada.
- **Al alumno:** sabe qué entrenar cada día, lo ejecuta guiado y ve su progreso (peso, IMC,
  fotos con comparador antes/después y cargas por ejercicio).
- **Al servicio:** el progreso pasa a ser demostrable, lo que ayuda a retener alumnos y a
  justificar el valor del entrenamiento personal.

## Innovación técnica

- Arquitectura hexagonal compartida entre app y BFF: el dominio (modelos y reglas) se reutiliza
  en ambos lados, y conectar el backend reemplazó solo la capa de infraestructura de la app.
- BFF como una única función serverless en Vercel, con esquemas zod como fuente de verdad de
  los límites que respeta el front.
- Calidad automatizada: 1.725 pruebas y 97% de cobertura de líneas, exigida en cada pull
  request.
