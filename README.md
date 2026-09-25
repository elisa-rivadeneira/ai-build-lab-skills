# AI Build Lab — Skills para Claude Code

Colección de Skills reutilizables para el programa AI Build Lab. Le dicen a Claude Code
cómo construir y publicar aplicaciones (stack, reglas de decisión, forma de comunicarse con
un alumno sin experiencia técnica) automáticamente a partir de un prompt de especificación
(por ejemplo, uno generado por un consultor de ChatGPT) más una imagen de referencia.

## Instalación para alumnos

**Windows** — abrir PowerShell y pegar:

```powershell
irm https://raw.githubusercontent.com/elisa-rivadeneira/ai-build-lab-skills/main/install.ps1 | iex
```

**Mac / Linux** — abrir la Terminal y pegar:

```bash
curl -fsSL https://raw.githubusercontent.com/elisa-rivadeneira/ai-build-lab-skills/main/install.sh | bash
```

Esto copia los Skills a la carpeta personal de Claude Code (`~/.claude/skills/` en Mac/Linux,
`C:\Users\<usuario>\.claude\skills\` en Windows). Se hace una sola vez por computadora — a
partir de ahí funciona automáticamente en cualquier proyecto nuevo.

## Cómo probar que quedó instalado

Abrir Claude Code en cualquier carpeta (puede ser una carpeta vacía nueva) y pegar un
prompt de especificación de una app (con una imagen de referencia si se tiene). Claude
Code debería reconocer el patrón y empezar a construir siguiendo las reglas del Skill, sin
que haga falta mencionar ninguna tecnología.

## Skills incluidos

- **`ai-build-lab-builder/`** — stack por defecto (Next.js + Supabase + Vercel), reglas de
  decisión, estilo de comunicación con el alumno, y errores ya conocidos con su arreglo
  (ver `ai-build-lab-builder/references/`).

## Actualizar un Skill

Editar los archivos dentro de la carpeta del skill correspondiente, subir los cambios a
este repositorio (`git push`), y pedirle a los alumnos que vuelvan a correr el instalador —
sobrescribe la versión anterior sin duplicar nada.
