# Errores ya encontrados con este stack (y su arreglo probado)

Todo esto ocurrió construyendo una app real con este mismo stack (Next.js/Express +
Supabase + Vercel + GitHub). No son hipótesis — son bugs reales que costaron tiempo de
diagnóstico. Revisa esta lista antes de dar algo por terminado.

## 1. Vercel no tiene disco permanente

**Síntoma:** datos o archivos que "se guardan" pero desaparecen en la siguiente visita, o
funcionan en local y fallan solo en producción.

**Causa:** las funciones serverless de Vercel corren en contenedores temporales sin disco
propio. Cualquier archivo escrito localmente (una base de datos de un solo archivo tipo
SQLite, una carpeta de imágenes subidas) se borra entre invocaciones.

**Arreglo:** nunca uses almacenamiento en disco local para nada que deba persistir. Todo
dato va a Supabase (Postgres), todo archivo va a Supabase Storage. Esto no es una opción
cuando el destino es Vercel — es obligatorio en cuanto exista algo que guardar.

## 2. Error 413 (Payload Too Large) al guardar varias imágenes juntas

**Síntoma:** guardar un formulario con varias imágenes falla con `413` en producción
(Vercel), aunque funcione bien en local.

**Causa:** las funciones Node de Vercel rechazan cuerpos de petición mayores a ~4.5 MB. Si
el formulario sube 3-4 imágenes de varios MB cada una en una sola petición, se pasa del
límite fácilmente — incluso con fotos "normales" de un celular o generadas por IA.

**Arreglo:** reduce cada imagen en el navegador (con `<canvas>`) antes de subirla, con un
tamaño máximo fijo por campo (ej. 1600×900 para una foto de portada, 1200×900 para una
promoción, 500×500 para un logo). Para fotos, fuerza formato **JPEG** aunque el archivo
original sea PNG — un PNG de una imagen generada por IA (ChatGPT, Midjourney, etc.) casi no
comprime y puede seguir siendo pesado incluso ya reducido de tamaño; JPEG sí comprime bien.
Solo usa PNG cuando de verdad se necesita fondo transparente (típicamente, un logo).
Alternativa más robusta para archivos grandes de verdad: usar una URL de subida firmada de
Supabase Storage para que el archivo vaya directo del navegador a Supabase, sin pasar por la
función de Vercel.

## 3. `.co` no es un error de tipeo — es el dominio real de Supabase

**Síntoma:** la conexión a Supabase falla con `fetch failed` después de que alguien "corrige"
la URL.

**Causa:** el dominio real de los proyectos de Supabase termina en `.co`, no en `.com`. Es
fácil que alguien sin experiencia lo lea como un error de tipeo y le agregue la "m".

**Arreglo:** confirma explícitamente que `.co` es correcto cuando guíes a alguien a copiar
su Project URL. No dejes que lo "corrijan".

## 4. Node < 22 y el cliente de Supabase: error de WebSocket

**Síntoma:** al crear el cliente de Supabase (`createClient(...)`), truena con
`Node.js detected without native WebSocket support`, incluso sin usar nada de Realtime.

**Causa:** `@supabase/supabase-js` intenta armar un cliente de Realtime al construirse,
sin importar si se usa o no, y en Node menor a 22 no hay WebSocket nativo.

**Arreglo:** instala el paquete `ws` y pásalo como transporte:

```js
const { createClient } = require('@supabase/supabase-js');
const WebSocket = require('ws');

const supabase = createClient(url, key, {
  realtime: { transport: WebSocket },
});
```

O asegúrate de que el entorno use Node 22+, si es posible elegirlo.

## 5. Los nombres de las llaves de Supabase cambiaron

**Síntoma:** confusión al buscar la llave `service_role` o `anon` en el dashboard — ya no
aparecen con esos nombres.

**Causa:** el dashboard nuevo de Supabase renombró las llaves: lo que era `service_role`
ahora aparece como **"Secret key"** (`sb_secret_...`), y lo que era `anon` ahora es
**"Publishable key"** (`sb_publishable_...`). Misma función, nombre distinto. Ambas están en
Settings → **API Keys** (a veces solo aparece esa pestaña dentro de "Integrations → Data
API" para la URL, y "API Keys" aparte para las llaves).

**Arreglo:** cuando guíes a alguien a buscar la llave privada del servidor, dile que busque
la sección **"Secret keys"**, no la palabra literal "service_role".

## 6. Tokens de GitHub: "Fine-grained" vs "Classic"

**Síntoma:** un Personal Access Token recién creado da error 403 al hacer `git push`, aunque
se haya marcado el repositorio correcto.

**Causa:** los tokens **fine-grained** (los que empiezan con `github_pat_`) no tienen ningún
permiso por defecto — hay que configurárselos repositorio por repositorio, y es fácil
dejarlos incompletos.

**Arreglo:** para un push puntual, es más simple crear un token **classic** (empieza con
`ghp_`) con el scope `repo` marcado — funciona de inmediato. Mejor todavía: si el estudiante
tiene VS Code abierto, usar el botón de "Publish/Push" del panel de Control de código fuente
evita tokens por completo (usa el inicio de sesión de GitHub ya guardado en el navegador) —
pero confirma primero que la ventana de VS Code tenga abierto el proyecto correcto, no otro
proyecto viejo del estudiante.

**Seguridad:** un token pegado en el chat es una llave real. Úsalo para el push, y de
inmediato limpia la URL del remoto (`git remote set-url origin https://github.com/...` sin
el token) para no dejarlo guardado en texto plano en el proyecto. Sugiere al estudiante
revocarlo cuando ya no se necesite.

## 7. Chrome marca `*.vercel.app` como "Dangerous" si hay un login

**Síntoma:** al visitar la URL pública de Vercel (`algo.vercel.app`), Chrome muestra un
aviso rojo "Dangerous" y "Check your passwords" al iniciar sesión — y sigue apareciendo
incluso en una ventana de Incógnito (o sea, no es solo del navegador de una persona, le
pasa a cualquiera).

**Causa:** las subdominios gratuitos de `vercel.app` se usan mucho para páginas de phishing
que imitan formularios de login, así que Google Safe Browsing a veces marca por precaución
cualquier dirección nueva de `vercel.app` con un formulario de contraseña.

**Arreglo real:** conectar un dominio propio (o subdominio de uno que el cliente ya tenga)
al proyecto de Vercel antes de mostrarlo en público o grabarlo — un dominio propio
prácticamente nunca tiene este problema, y además se ve más profesional. No hay arreglo de
código para esto; es de configuración de dominio.

**Diagnóstico rápido:** para saber si es un aviso real (le pasa a cualquiera) o solo del
navegador de una persona (por una contraseña repetida guardada), probar la misma URL en una
ventana de Incógnito.

## 8. Nunca dejes mensajes de error técnicos expuestos en producción

Está bien exponer temporalmente el detalle real de un error (`error.message`, un log en
consola) mientras se diagnostica algo en vivo — es la forma más rápida de ver qué está
pasando sin adivinar. Pero quítalo apenas quede resuelto: un mensaje de error con detalles
internos expuesto permanentemente en una respuesta pública de la API es información que no
debería ver cualquier visitante.
