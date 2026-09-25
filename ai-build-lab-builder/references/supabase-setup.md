# Guiar a un estudiante a configurar Supabase (paso a paso)

Usa esto tal cual con el estudiante — son los pasos y el vocabulario real del dashboard
actual de Supabase (los nombres de pantallas cambian de vez en cuando; si algo no coincide,
pide una captura y ubícate desde ahí en vez de asumir).

## 1. Crear cuenta y proyecto

1. Entra a **supabase.com** → "Sign in" → **GitHub** (así no hay que crear otra contraseña).
2. **"New project"** → nombre del proyecto, contraseña de base de datos (que la guarde en
   algún lado, aunque casi no se use directamente), región más cercana.
3. Esperar 1-2 minutos mientras se prepara.

## 2. Crear las tablas, políticas y el almacén de archivos

Nunca improvises el SQL a mano con el estudiante mirando. Escribe **un solo script SQL**
(tablas + políticas RLS + bucket de Storage) según lo que el prompt del cliente realmente
necesite, y dale estos pasos:

1. Menú izquierdo → **SQL Editor** → **"New query"**.
2. Pegar todo el script de una vez.
3. Clic en **"Run"** (no hace falta "guardar" el snippet, eso es solo una copia de
   referencia dentro del editor, no afecta si los cambios en la base de datos se aplicaron).

Recuerda: toda tabla necesita `enable row level security` y políticas explícitas — sin
política, con RLS activado, nadie (ni siquiera un usuario logueado) puede leer o escribir
nada por defecto. Escribe las políticas según el caso real (ejemplo típico: lectura pública
del contenido del sitio, escritura solo para usuarios autenticados).

## 3. Activar Supabase Auth (si el prompt necesita login/admin)

1. Menú izquierdo → **Authentication** → **Users** → **"Add user"** (crear ahí mismo el
   único usuario administrador con su correo y contraseña — no hace falta un flujo de
   registro público para un panel de un solo dueño).
2. Si el prompt pide más de un tipo de usuario o registro público, ahí sí conviene revisar
   qué proveedor de login usar (email/contraseña suele bastar) y ajustar las políticas RLS
   según el rol.

## 4. Copiar las llaves de conexión

1. Menú izquierdo → ⚙️ **Settings** → **API Keys** (a veces la URL vive en
   "Integrations → Data API" y las llaves en una pestaña aparte llamada "API Keys" —
   revisa ambas si no encuentras algo de inmediato).
2. Copiar:
   - **Project URL** (termina en `.co`, no `.com`).
   - **Publishable key** (`sb_publishable_...`) — esta sí puede ir en el código del
     navegador, es pública a propósito.
   - **Secret key** (`sb_secret_...`, antes llamada `service_role`) — esta NUNCA va al
     navegador ni se pega en un chat; solo en variables de entorno del servidor/Vercel.
3. Pegar `NEXT_PUBLIC_SUPABASE_URL` y `NEXT_PUBLIC_SUPABASE_ANON_KEY` (la publishable key)
   en `.env.local`. Si algo del lado del servidor necesita permisos elevados (poco común
   con RLS bien configurado), la secret key va en una variable sin el prefijo `NEXT_PUBLIC_`
   para que nunca llegue al navegador.

## 5. Crear el bucket de Storage (si el prompt necesita subir imágenes/archivos)

Puede ir en el mismo script SQL del paso 2:

```sql
insert into storage.buckets (id, name, public)
values ('uploads', 'uploads', true)
on conflict (id) do nothing;
```

Un bucket `public: true` permite que cualquiera VEA los archivos por su URL (correcto para
fotos de un sitio público), pero seguir necesitando estar autenticado para SUBIR requiere
sus propias políticas en `storage.objects` — no asumas que "público" significa "cualquiera
puede subir también".
