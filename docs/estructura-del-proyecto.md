# Estructura de carpetas del repositorio

## Raíz del proyecto

| Elemento | Descripción |
|----------|-------------|
| `project.godot` | Nombre del proyecto, escena principal, tamaño de ventana, mapa de acciones de entrada |
| `icon.svg` | Icono de la aplicación |
| `game_theme.tres` | Tema de UI reutilizable por los controles |
| `README.md` | Descripción académica y enlaces del equipo (no sustituye esta carpeta `docs/`) |

## `Scenes/`

Escenas Godot (`.tscn`): nodos, jerarquías, instancias y conexiones de señales. Son el “ensamblado” visual del juego. Listado detallado en [escenas-godot.md](escenas-godot.md).

## `Scripts/`

Lógica en GDScript (`.gd`). Cada escena con comportamiento enlaza uno o más scripts aquí. Referencia función por función en [referencia-de-scripts.md](referencia-de-scripts.md).

Archivos auxiliares `*.gd.uid` los genera Godot 4 para identificar scripts de forma estable.

## `Resources/`

Contenido artístico y de datos importados por el motor:

| Subcarpeta | Uso típico |
|------------|------------|
| `Fonts/` | Tipografías (por ejemplo título UI) |
| `Sprites/` | Sprites del personaje, arquero, enemigos, iconos de mejoras, cursor, efectos |
| `Textures/` | Tilesets y texturas de mapa / props |
| `Sprites/enemies/fireball/` | Frames de animación del proyectil y explosión |

Los archivos `.import` son metadatos de importación de Godot; no suelen editarse a mano.

### Detalle habitual de `Resources/`

| Ruta | Contenido típico |
|------|-------------------|
| `Resources/Fonts/` | Fuentes para UI |
| `Resources/Textures/` | Tilesets, barra de HP, bordes |
| `Resources/Sprites/character/` | Sprite del defensor |
| `Resources/Sprites/archer/` | Sprite del arquero |
| `Resources/Sprites/cursor/` | Frames del cursor y efecto de clic |
| `Resources/Sprites/icons/` | Iconos de mejoras (flechas, castillo, moneda, etc.) |
| `Resources/Sprites/enemies/` | Carpetas `skeleton`, `warrior`, `mage`, `rogue`, efectos y `fireball/` con animaciones del proyectil |

## `.godot/` (local)

Caché del editor e importaciones. Suele **no** versionarse en git; en este entorno puede aparecer como no rastreado.

## Archivos temporales

Algunos `Scenes/*.tmp` pueden ser backups del editor; no forman parte del flujo de ejecución estable.
