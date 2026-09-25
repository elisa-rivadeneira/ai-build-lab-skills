# Guiar a un estudiante a publicar en Vercel (paso a paso)

Con Next.js, este paso es mucho más simple que con un backend separado — Vercel reconoce
Next.js solo, sin archivos de configuración extra.

## 1. Subir el código a GitHub

Si el estudiante ya tiene VS Code abierto **con el proyecto correcto** (confírmalo — puede
tener otros proyectos abiertos en la misma ventana):

1. Panel de **Control de código fuente** (ícono de ramita, o `Ctrl+Shift+G`).
2. Botón **"Publish Branch"** o **"Sync Changes"** → login de GitHub por navegador (sin
   tokens).

Si eso no está disponible o se complica, créale un repositorio vacío en github.com/new (sin
marcar README/gitignore) y usa un Personal Access Token **classic** con scope `repo` para
hacer el push tú mismo (ver `pitfalls.md`, punto 6, para los detalles y el manejo seguro del
token).

## 2. Importar el proyecto en Vercel

1. **vercel.com** → login con GitHub (si ya inició sesión en GitHub antes, suele quedar
   logueado solo).
2. **"Add New..." → "Project"** → elegir el repositorio recién subido → **"Import"**.
3. Vercel detecta Next.js automáticamente — no hace falta tocar el comando de build ni el
   directorio de salida.

## 3. Variables de entorno

Antes de darle a "Deploy" (o después, en Settings → Environment Variables si ya se
desplegó), agregar las mismas variables que están en `.env.local`:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- cualquier otra variable de servidor que el proyecto use

Marcar las tres casillas de ambiente (Production, Preview, Development). Si se agregan
DESPUÉS del primer deploy, hay que volver a **Deployments → (los tres puntos) → Redeploy**
para que se apliquen — no se aplican solas a un deploy ya hecho.

## 4. Verificar en producción de verdad

No des el trabajo por terminado con "ya se desplegó". Entra tú mismo (con una herramienta
de navegador si la tienes disponible) a la URL pública real y prueba el flujo completo:
página pública, login si aplica, guardar cambios, subir una imagen de tamaño real (no un
archivo de prueba de unos KB). Varios problemas del stack (límite de tamaño de Vercel,
llaves mal copiadas, políticas RLS faltantes) solo aparecen ahí, no en local.

## 5. Antes de que el estudiante lo muestre en público o lo grabe

Revisa el punto 7 de `pitfalls.md` (Chrome marcando `*.vercel.app` como "Dangerous"). Si el
estudiante va a grabar una demo o mostrárselo a su cliente, es buen momento para sugerir
conectar un dominio propio (Vercel → Settings → Domains) en vez de quedarse con la URL
gratuita de Vercel.
