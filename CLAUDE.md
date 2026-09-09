# CLAUDE.md — Sitio web académico de Javier Feinmann

Documento de contexto persistente. Se carga automáticamente al abrir el proyecto.
**Mantenerlo actualizado**: cada vez que hagamos un cambio estructural o tomemos una
decisión, agregarla acá (sobre todo en "Registro de sesiones" y "Decisiones tomadas").

---

## 1. Qué es el proyecto

Sitio web académico personal, estático, publicado en **GitHub Pages**.

- **URL en vivo:** https://javierfeinmann.github.io/JavierFeinmann/
- **Repo:** https://github.com/javierfeinmann/JavierFeinmann (rama `main`)
- **Local:** `C:\Users\Javier Feinmann\jfeinmann Dropbox\javier feinmann\website\JavierFeinmann`
  (ojo: vive **dentro de Dropbox**, ver §6)

Sin build, sin `npm`, sin framework. Solo HTML + CSS + JS vanilla, con **Bootstrap 5.2.0-beta1
por CDN**. Se publica haciendo push a `main`; GitHub Pages sirve el repo tal cual.

Para previsualizar en local basta abrir `index.html` en el navegador. Si algo depende de
`fetch()` (los JSON, ver §2), hace falta un servidor: `python -m http.server 8000`.

---

## 2. Arquitectura (importante)

**Todo el sitio es una sola página**: `index.html`. La navegación son anclas (`#research`,
`#teaching`, `#data`), no páginas separadas. *Antes* fue multipágina (`pages/research.html`,
`pages/teaching.html`); esos archivos ya no existen.

El contenido de investigación **no está hardcodeado en el HTML**. `js/main.js` lo inyecta en
tiempo de ejecución leyendo tres JSON de la raíz:

| Archivo | Sección que alimenta | Contenedor en el HTML |
|---|---|---|
| `wp.json` | Working Papers (acordeón **con** figura) | `#accordionPanelsStayOpenPapers` |
| `progress.json` | Advanced Work in Progress (acordeón **sin** figura) | `#accordionPanelsStayOpenProgress` |
| `policy.json` | Policy Report (lista simple) | `#listPolicy` |
| `events.json` | Events (tarjetas de próximas charlas) | `#listEvents` |

> **Para agregar o editar un paper se toca el JSON, nunca el HTML.**

### Esquema de `wp.json`

```json
{
  "title":     "Título del paper",
  "coauthors": [{ "name": "Nombre", "url": "https://..." }],
  "subtitle":  "New!",
  "bullets":   ["Premio o nota corta", "Se renderizan como chips"],
  "link":      "./files/research/working_papers/archivo.pdf",
  "img":       1,
  "id":        "Papers-One",
  "text":      "Abstract completo."
}
```

- `img` es un **número**: `main.js` arma la ruta `./img/research/working_papers/{img}.webp`.
  La imagen debe existir en `.webp` (los `.jpg`/`.png` originales quedan como respaldo).
- `id` debe ser **único** — se usa para los `id` de Bootstrap del acordeón. Si se repite, el
  acordeón se rompe (dos paneles abren juntos).
- `url: ""` en un coautor lo renderiza como texto plano, sin link. Es válido y se usa.
- `coauthors` (array) es el formato actual. `main.js` todavía soporta un campo viejo
  `coauthor` (string) como fallback, pero no se usa.
- Se permite HTML dentro de `bullets` y `text` (ej. `<i>`, `<a>`).
- **El orden del array define el orden en pantalla.**

### Esquema de `progress.json`

Igual que `wp.json` salvo que:
- usa `slides` en vez de `link`;
- usa `type` para la etiqueta del link (ej. `"[Slides]"` → se renderiza "Slides"); si está
  vacío, cae a "Slides" por defecto;
- **no** renderiza imagen (no hay columna de figura).

### `policy.json`

Mínimo: solo `title` y `link`.

### Esquema de `events.json`

```json
{
  "date":      "2026-11-03",
  "endDate":   "2026-11-05",
  "event":     "IIPF Annual Congress",
  "kind":      "Conference",
  "location":  "Lisbon, Portugal",
  "paper":     "Tax Progressivity and Inequality in Brazil",
  "link":      "https://...",
  "linkLabel": "Paper"
}
```

Solo `date` y `event` son necesarios; el resto es opcional y se omite si está vacío.

**Reglas de comportamiento (implementadas en `main.js`):**

- **Las fechas van en formato ISO `YYYY-MM-DD`.** `main.js` las parsea a mano en vez de
  usar `new Date(string)`, porque este último las interpreta como UTC medianoche y en husos
  con offset negativo el evento se muestra un día antes.
- **Los eventos pasados se ocultan solos.** El corte usa `endDate` (o `date` si no hay), así
  que un congreso de varios días **sigue visible mientras transcurre** y desaparece recién el
  día después de terminar.
- **Se ordenan solos por fecha ascendente.** El orden del array *no* importa (a diferencia de
  `wp.json`).
- **Sin fecha = TBC.** Si `date` está vacío o mal escrito, el evento se muestra al final con
  el badge `TBC` y **nunca se auto-oculta**. Modo de falla deliberado: ante un typo el evento
  queda visible en vez de desaparecer sin aviso.
- **Si no queda ningún evento futuro, la sección entera y su link del menú se eliminan del
  DOM**, para no dejar un encabezado "Events" vacío.
- Rangos dentro del mismo mes se colapsan en el badge (`Nov 3-5`). Si el rango cruza meses,
  el badge muestra la fecha de inicio y el rango completo aparece como línea aparte.
- `linkLabel` por defecto es `"Slides"` si hay `link` pero no etiqueta.

---

## 3. Estructura de carpetas

```
index.html          # toda la página
css/style.css       # estilos propios (encima de Bootstrap)
js/main.js          # inyecta los JSON en el DOM + toggles de carpetas
wp.json             # working papers
progress.json       # work in progress
policy.json         # policy reports
sitemap.xml         # solo la URL raíz
img/
  home/             # perfil (.jpg/.webp), logo, iconos email/address
  research/working_papers/   # figuras 1-8, en .jpg/.png + .webp
  data&codes/       # iconos de carpeta + figuras de educación
files/
  home/             # CV en PDF (2 versiones)
  research/         # drafts y slides en PDF
  data&codes/       # el Open Data Project (~440 MB, ver §5)
```

---

## 4. Perfil académico (para redactar textos)

Economista de finanzas públicas. Actualmente **Postdoctoral Research Fellow en la Paris School
of Economics (PSE)** y el **EU Tax Observatory**. **En 2027 se incorpora a Sciences Po
(Department of Economics) como Assistant Professor.** Doctorado en Berkeley.

- Contacto público: `jfeinmann@berkeley.edu` · Office R4-14, PSE, ENS Campus Jordan
- Temas: evasión y colusión fiscal (*payments under the table*), progresividad tributaria,
  desigualdad, educación superior y movilidad social, mercados de crédito.
- Contextos empíricos: sobre todo **Brasil** (datos administrativos), más Uruguay, República
  Dominicana y un proyecto comparado LatAm.
- Coautor recurrente: **Roberto Hsu Rocha** (en 5 de los 8 papers).
- Docencia: GSI en Berkeley Haas (MBA) y en la Universidad Torcuato Di Tella.

---

## 5. Open Data Project

La sección `#data` publica microdatos agregados **a nivel clase (universidad × carrera)** del
sistema de educación superior brasileño, en `.csv` y `.dta` (duplicados a propósito, para
usuarios de R y de Stata).

- `graduates` y `new_students`, cohortes **2010–2015**
- `co_escola`: egresados de secundaria que rindieron el **ENEM**, cohortes 2009–2014
- Confidencialidad: **solo clases con ≥10 estudiantes**. No hay datos individuales.
- Cita requerida: *"Social Mobility and Higher Education: The Role of Elite Public Colleges"*,
  Feinmann & Hsu Rocha.

### ⚠️ Riesgo con el límite de GitHub

| Archivo | Tamaño |
|---|---|
| `high_school_graduates_cohort_2009_2014_ENEM.csv` | **89,1 MB** |
| `high_school_graduates_cohort_2009_2014_ENEM.dta` | 43,3 MB |

GitHub **rechaza el push de cualquier archivo >100 MB**. Ese CSV está a ~11 MB del tope.
Hoy funciona, pero **si esa extracción se actualiza con más cohortes o variables, el push va a
fallar**. En ese momento hay que migrar a **Git LFS** *antes* de commitear.
El repo tampoco tiene `.gitignore`.

---

## 6. Entorno y setup de git

- **Git for Windows 2.55.0** en `C:\Program Files\Git\cmd\git.exe`, ya en el PATH del sistema.
- También hay un git viejo (2.53) empaquetado dentro de GitHub Desktop 3.6.5. **No usarlo**:
  su ruta incluye la versión (`app-3.6.5\...`) y se rompe en cada actualización de la app.
- **Gotcha:** si Claude Code arrancó *antes* de instalar git, la sesión hereda el PATH viejo y
  `git` a secas no resuelve. Solución: reiniciar Claude Code, o llamar al ejecutable por ruta
  completa.
- **Autenticación:** `credential.helper = manager` a nivel *system*. El token de GitHub ya está
  en el Administrador de Credenciales de Windows → **el push no pide nada**.
- **Identidad:** la config *local* del repo pisa a la global. Los commits salen como
  `javierfeinmann <jfeinmann@berkeley.edu>`, consistente con todo el historial. La global
  (que puso GitHub Desktop) usa el email `@users.noreply.github.com` — **no** es la que se usa.
- **Dropbox:** el repo está dentro de Dropbox. Los comandos de git que recorren el working tree
  pueden tardar **más de 2 minutos** por los ~440 MB de datos. Si un `git commit` parece
  colgado, casi seguro terminó igual: verificar con `git log` antes de reintentar.
- **Fin de línea:** los archivos del repo usan **CRLF**. Al reescribir un archivo entero,
  escribirlo con CRLF; si no, el diff sale como "archivo entero modificado" y es ilegible.

---

## 7. Trampas conocidas del sitio

1. **GitHub Pages distingue mayúsculas de minúsculas** (Linux); Windows no. Una ruta con
   `.PNG` cuando el archivo es `.png` **funciona en local y se rompe en producción**.
   Siempre verificar rutas contra el nombre real del archivo.
2. Las imágenes de perfil y logo están en `img/home/`, **no** en `img/`. Es un error fácil de
   repetir en los metatags.
3. El sitio es de **una sola página**: no agregar URLs de subpáginas al `sitemap.xml`.
4. Hay dos figuras sin usar en `img/data&codes/education/`: `public_sector_degree.png` y
   `wages_entrepreneurship_degrees.png`.

---

## 8. Decisiones tomadas

- Usar **Git for Windows**, no el git de GitHub Desktop (§6).
- Los arreglos de rutas van en **un solo commit** por ser un cambio coherente.
- **No hacer push sin confirmación explícita de Javier**, porque el push publica en el sitio
  en vivo. Commitear en local está OK.
- El link muerto al `.xls` de RAIS se **eliminó** en vez de comentarse; si aparece el archivo,
  se vuelve a agregar (está en el historial de git).

---

## 9. Pendientes abiertos

- **"The Margins of Firm Tax Incentives"** (confirmado por Javier el 2026-09-09):
  **reemplaza** a *"Income Shifting vs. Real Responses in Simplified Tax Regimes"* (el del
  Factor R, `id: Papers-Eight`, `img: 8`). Javier sube el draft nuevo el **10 u 11 de
  septiembre de 2026**. Cuando llegue, hay que:
  1. reemplazar el PDF en `files/research/working_papers/` (hoy está `slides_FactorR.pdf`);
  2. actualizar título, `link` y `text` de la entrada `Papers-Eight` en `wp.json`;
  3. revisar si la figura `img/research/working_papers/8.webp` sigue siendo la correcta;
  4. verificar que el título coincida **exactamente** con el campo `paper` de los 6 seminarios
     en `events.json`, para que agenda y Research sean consistentes.
- **Git LFS**: migrar antes de que el CSV de 89 MB crezca (§5).

---

## 10. Registro de sesiones

### 2026-09-09 — Setup inicial + arreglo de rutas

**Contexto:** primera sesión. Se exploró el repo completo y se instaló git.

**Setup:** no había git en el PATH. Se instaló Git for Windows 2.55.0 vía
`winget install --id Git.Git -e --source winget`. Se verificó identidad, credenciales y remote.

**Auditoría:** se encontraron 6 rutas rotas, 3 de ellas invisibles en local porque solo fallan
en el Linux de GitHub Pages.

**Commit `b3c55a4` — `fix broken asset paths and stale sitemap entries`:**
- `itemprop` thumbnailUrl/image/imageUrl apuntaban a `img/perfil.jpg` (inexistente) →
  `img/home/perfil.jpg`. Rompía la vista previa al compartir el link.
- Se eliminaron `og:image` e `itemprop image` duplicados en el `<head>`.
- Favicon: `img/logo.png` → `img/home/logo.png`.
- `wages_degree_distribution.PNG` → `.png` (rompía en producción).
- Se quitó el link muerto a `RAIS_vinculos_layoutmicrodados2017.xls`.
- `sitemap.xml`: se sacaron `pages/research.html`, `pages/teaching.html` y la entrada duplicada
  `index.html`; se actualizó `lastmod`.

**Verificación:** se comprobó por script que las 100% de las rutas locales de `index.html`, las
8 figuras `.webp` de `wp.json` y los 7 PDFs referenciados en los JSON existen en disco.

**Estado al cierre:** commiteado en local, **sin push** (pendiente de confirmación).

### 2026-09-09 — Nueva sección "Events"

Javier pidió una cuarta sección para listar seminarios y conferencias futuras.

**Decisiones (elegidas por él):**
- Posición en el menú: **después de Research** → Home · Research · Events · Teaching · Data & Codes.
- Eventos pasados: **se ocultan automáticamente** por fecha.
- Formato: **tarjetas con la fecha destacada** en un badge navy a la izquierda.

**Implementación** — se siguió el patrón existente (JSON + render en `main.js`):
- `events.json` nuevo (ver esquema en §2).
- `js/main.js`: bloque `=== Events ===` con `parseLocalDate`, filtrado, orden y render.
- `index.html`: link en el navbar + `<section id="events">`.
- `css/style.css`: bloque `====== Events ======` al final.

**Verificación:** como no hay Node en la máquina, se portó la lógica de fecha a un script de
Python y se corrió contra `events.json` simulando cuatro "hoy" distintos más casos borde
(congreso a caballo de dos meses, fecha vacía, fecha mal escrita). Confirmado: los rangos
sobreviven mientras transcurren, el orden es correcto y la sección se elimina si queda vacía.

**Preview local:** `python -m http.server 8000` en la raíz → http://localhost:8000
(hace falta servidor, no alcanza con abrir el archivo: `main.js` usa `fetch`).

**Agenda real cargada:** 9 seminarios entre sep-2026 y mar-2027 (Dublin, Barcelona, San Andrés,
UdelaR, FGV-SP, FGV-RJ, PUC-Rio, CAF, CREST-ENSAE). 6 de los 9 presentan el mismo paper,
*"The Margins of Firm Tax Incentives"* — **ese título no existe en `wp.json`** (ver §9).

**Normalizaciones aplicadas a los datos que pasó Javier** (avisadas, revertibles):
"Universita" → "Universitat de Barcelona"; acentos en San Andrés, República y São Paulo;
espacio final y formato en "CREST-ENSAE, Institut Polytechnique de Paris".

**Caso `"paper": "TBD"`:** dos seminarios lo tienen. `main.js` detecta `TBD`/`TBA`/`TBC`
(case-insensitive) y lo renderiza como "Paper to be confirmed" en gris y sin itálica, para que
no parezca un paper titulado "TBD".

Los archivos usan **UTF-8 sin BOM**; combinado con `<meta charset="UTF-8">` los acentos
renderizan bien. Cuidado: PowerShell 5.1 los muestra mal en consola (`AndrÃ©s`), pero es un
artefacto de la terminal, no del archivo.
