# Hamster Panel V1

Panel web estático para administrar el Firebase que usa actualmente Hamster.

## Firestore actual

- Evento principal: `Event/Evento`
- Boletos: `Event/Evento/Tickets`
- Inicio / Discover: `Event/Discover/Eventos`

## Publicar en GitHub Pages

1. Crea un repositorio, por ejemplo `hamster-panel`.
2. Sube todos los archivos de esta carpeta a la raíz del repo.
3. En GitHub: **Settings > Pages**.
4. En **Build and deployment**, selecciona **Deploy from a branch**.
5. Elige `main` y `/ (root)`.
6. Guarda. GitHub Pages puede publicar estos archivos estáticos directamente.

No hay Node, npm ni build. El panel usa Firebase Web SDK como módulos ESM desde el CDN oficial.

## Firebase Authentication (requerido)

El panel inicia sesión con Email/Password.

1. Firebase Console > Authentication > Sign-in method.
2. Habilita **Email/Password**.
3. Crea al menos un usuario administrador.

## Seguridad

La configuración pública de Firebase en `app.js` no sustituye Security Rules. Debes restringir las escrituras del panel con reglas de Firestore.

El archivo `firestore.rules.example` incluye una base que permite lecturas y exige autenticación para escritura. Ajusta esto a tus necesidades antes de producción.

## Qué permite editar V1

- `Event/Evento`: Nombre, Fecha, Lugar y eventIMG.
- `Event/Evento/Tickets`: todos los campos que consume actualmente `TicketsViewModel`.
- `Event/Discover/Eventos`: Nombre, Lugar, Fecha y EventoUrl.
- Crear y eliminar tickets.
- Crear y eliminar eventos de Inicio.

Las imágenes se manejan por URL para no depender todavía de reglas/CORS de Firebase Storage.

## Nota

Esta V1 conserva exactamente la estructura Firestore actual para no romper la app iOS. En una V2 se puede migrar a múltiples eventos administrables y clasificación real de For You / Trending / Last Chance.
