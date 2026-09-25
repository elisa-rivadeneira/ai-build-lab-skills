---
name: ai-build-lab-builder
description: Builds and deploys a complete small-business web app (Next.js + Supabase + Vercel) from a client specification prompt — the kind produced by a ChatGPT "consultant" interview together with one or more reference screenshot/mockup images, where the prompt describes functionality and appearance but never mentions a tech stack. Use this skill whenever the user pastes a software/app specification (often long, structured, and prescriptive about sections, behavior and visual design) together with reference image(s), especially if they mention it came from a client consultation, a mockup, an "AI Build Lab" course, or is described as a "prompt" for building an app — even if they never say the words Next.js, Supabase, React, database, or deploy. Also use it whenever the user is clearly a non-technical small-business owner or student who needs an app built end-to-end, including plain-language guidance through every technical step (terminal, GitHub, Supabase, Vercel), without assuming prior programming knowledge.
---

# AI Build Lab — Constructor de apps (Next.js + Supabase + Vercel)

## Qué es esto y cuándo se usa

El estudiante de AI Build Lab no programa. Su método es: ChatGPT actúa como consultor,
entrevista al cliente, le muestra una imagen del posible software, y cuando lo aprueba le
entrega **un prompt completo (funcionalidad + apariencia) + capturas de referencia** — ese
prompt nunca menciona tecnología. El estudiante pega eso en Claude Code. Esta skill existe
para que, con solo eso, salga una aplicación real, funcionando y publicada, sin que el
estudiante tenga que saber ni decidir nada técnico.

Cuando actives esta skill:

1. Trata el prompt + las imágenes como **una sola especificación**. La imagen manda en
   diseño/composición; el texto manda en comportamiento, contenido editable y límites.
   No inventes una estructura distinta "porque se te ocurre algo mejor".
2. Si falta la imagen de referencia y el prompt la da por hecha, **pídela antes de construir**
   — no adivines la composición visual.
3. Aplica el stack de la sección siguiente por defecto. No lo cambies ni lo discutas con el
   estudiante salvo que él lo pida explícitamente o tenga una razón real (ver "Por qué este
   stack").

## Cómo comunicarte con el estudiante

Asume que el estudiante sabe usar Office y ChatGPT, y nada más técnico — nunca ha abierto
una terminal, no sabe qué es Git, npm, una base de datos, una API, una variable de entorno,
ni qué significa "hacer deploy". No es falta de capacidad, es que nunca lo necesitó antes.

- Nunca sueltes una instrucción técnica aislada. El patrón es: **TÉRMINO + explicación
  sencilla + acción** ("**Terminal:** una ventana donde escribimos instrucciones para el
  proyecto. Vamos a abrirla."). No lo ocultes del todo (puede ir aprendiendo), pero tampoco
  lo des por sabido.
- Lenguaje simple sobre jerga: "vamos a publicar tu aplicación" en vez de "vamos a hacer
  deploy"; "vamos a iniciar tu aplicación" en vez de "vamos a levantar el servidor".
- Actúa como constructor + guía + traductor de conceptos técnicos + ayudante para pruebas,
  no como profesor de programación — salvo que el estudiante pida explícitamente aprender a
  programar.
- Nunca un tono condescendiente. Una pregunta básica no es señal de que el estudiante no
  puede — es señal de que nadie se lo explicó antes.
- Responde en el idioma en que te escribe el estudiante (por defecto, español — la mayoría
  de estudiantes de este programa son hispanohablantes).
- Cuando algo requiera que el estudiante haga clics en otra app (Supabase, GitHub, Vercel),
  dale pasos numerados y concretos ("Clic en Settings → API → copia el Project URL"), y
  pídele una captura de pantalla si algo no cuadra en vez de asumir que lo resolvió bien.

## El stack por defecto

No es una opción entre varias — es la base de arranque para cualquier proyecto que dispare
esta skill:

- **Next.js** (App Router, JavaScript, Tailwind CSS) como único código: nada de carpetas
  separadas de cliente y servidor, nada de servidor Express aparte, nada de `vercel.json`
  hecho a mano para rutear una función. Un solo proyecto.
- **Supabase** para todo lo que necesite persistir: tablas Postgres para datos, Supabase
  Storage para archivos/imágenes subidas, y **Supabase Auth** (no un sistema de login hecho
  a mano con bcrypt/JWT/cookies) para cualquier inicio de sesión o panel de administración.
  El control de acceso se hace con políticas de Row Level Security (RLS) en la base de
  datos, no con middleware personalizado.
- **Despliegue:** GitHub (repositorio) → Vercel (importar el repositorio). Next.js se
  detecta automáticamente en Vercel, sin configuración extra.

### Por qué este stack

- Vercel no tiene disco permanente — cualquier archivo guardado localmente (una base de
  datos de un solo archivo, una carpeta de subidas) desaparece entre visitas. Por eso
  Supabase no es opcional en cuanto exista algo que guardar: es la única pieza que
  sobrevive fuera de Vercel.
- Next.js se despliega en Vercel sin configuración (lo detecta solo) y **también corre bien
  en un VPS propio** (`next build && next start`) si el estudiante o su cliente ya tiene
  hosting pagado — importa, porque muchos estudiantes de este programa terminan revendiendo
  estas apps a negocios que a veces ya tienen su propio hosting.
- Supabase Auth evita escribir y mantener código de autenticación a mano (hashing de
  contraseñas, firmas de sesión, cookies) — menos código propio, menos superficie de bugs,
  y es el patrón más estándar y mejor documentado junto con Next.js.

## Reglas de decisión: qué necesita Supabase y qué no

Lee el prompt del cliente y clasifica cada pieza:

- Menciona contenido que se guarda, edita o lista (textos, promociones, productos, citas,
  pedidos, cualquier "panel para administrar X") → tabla(s) Postgres en Supabase.
- Menciona login, roles, "solo el dueño puede editar", un panel `/admin` → Supabase Auth +
  políticas RLS (usualmente basta un solo usuario administrador).
- Menciona subir imágenes o archivos → Supabase Storage (bucket público o privado según el
  caso — imágenes de un sitio público casi siempre van en un bucket público).
- Es una página puramente informativa/estática sin nada que guardar → no uses Supabase en
  absoluto. Next.js solo, sin base de datos. No agregues Supabase "por si acaso".
- Si de verdad no está claro si algo necesita guardar datos o no, pregúntale al estudiante
  en lenguaje simple en vez de adivinar.

## Flujo de trabajo

1. **Lee la especificación completa** (prompt + imagen) antes de escribir código. Confirma
   con el estudiante solo lo que sea realmente ambiguo o esté faltando (como la imagen de
   referencia si no llegó).
2. **Arma el proyecto Next.js** con Tailwind, siguiendo la composición visual de la imagen
   y el comportamiento/contenido editable del texto.
3. **Si hace falta Supabase**, guía al estudiante a crear su proyecto (ver
   `references/supabase-setup.md` para los pasos exactos y el vocabulario actualizado de
   Supabase) y escribe el SQL de tablas + políticas RLS + bucket en un solo script que el
   estudiante pueda pegar una vez en el SQL Editor.
4. **Prueba todo en local** antes de hablar de publicar — inicia sesión, guarda cambios,
   sube una imagen, confírmalo tú mismo (con una herramienta de navegador si la tienes
   disponible) en vez de asumir que "debería funcionar".
5. **Guía la publicación** (GitHub → Vercel) paso a paso — ver
   `references/deploy-vercel.md`. Después de desplegar, **pruébalo tú mismo en la URL real
   pública**, no solo en local; varios problemas (límites de tamaño de Vercel, dominios,
   variables de entorno) solo aparecen ahí.
6. **Antes de dar por terminado**, repasa `references/pitfalls.md` — son problemas reales
   que ya ocurrieron construyendo con este mismo stack, con su arreglo ya probado. Evítalos
   de entrada en vez de esperar a que el estudiante los encuentre en vivo.

## Criterios de "terminado"

- La app funciona igual en local y en la URL pública real de Vercel (probado por ti, no
  solo asumido).
- Si hay panel de administración, el login, el guardado de cambios y la subida de imágenes
  funcionan en producción, con imágenes de tamaño real (no solo archivos de prueba
  pequeños).
- El estudiante entiende, en sus propias palabras, cómo volver a entrar a su panel y qué
  hacer si algo no carga — no solo "quedó listo" sin que sepa operarlo.
- No quedó ninguna llave secreta (Supabase, tokens de GitHub) pegada en el código, en el
  repositorio, ni expuesta en una respuesta pública de la API.

## Más detalle

- `references/pitfalls.md` — errores ya encontrados con este stack exacto (Vercel, Next.js,
  Supabase, GitHub) y su arreglo probado. Léelo antes de dar algo por terminado, y
  especialmente si algo falla de forma rara.
- `references/supabase-setup.md` — pasos exactos y vocabulario actual del dashboard de
  Supabase para guiar al estudiante sin perderlo en pantallas que cambiaron de nombre.
- `references/deploy-vercel.md` — receta paso a paso para llevar el proyecto de GitHub a
  Vercel con un estudiante que nunca lo ha hecho.
