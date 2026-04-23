# Documentación del proyecto Bogosoft-TP

Este directorio describe el juego **Bogosoft-TP**: una mezcla de *tower defense* y *clicker* hecha en **Godot 4** (GDScript). El jugador representa al defensor (personaje blanco junto al castillo), hace clic para dañar esqueletos que avanzan desde la izquierda, compra mejoras con monedas y puede desbloquear arqueros automáticos.

## Contenido de esta carpeta

| Archivo | Contenido |
|---------|-----------|
| [estructura-del-proyecto.md](estructura-del-proyecto.md) | Árbol de carpetas y rol de cada una |
| [escenas-godot.md](escenas-godot.md) | Cada escena `.tscn` y qué instancia |
| [referencia-de-scripts.md](referencia-de-scripts.md) | Cada script `.gd`: clases, señales y funciones |
| [flujo-de-juego.md](flujo-de-juego.md) | Cómo encajan combate, economía y dificultad |
| [controles-e-interaccion.md](controles-e-interaccion.md) | Ratón, teclado, UI y cómo interactúa el jugador |

## Resumen en una frase

**`World`** es la escena principal: crea **`Stats`**, conecta paneles de UI, spawnea enemigos con **`SpawnTimer`**, monedas al morir enemigos, y termina la partida cuando la vida del castillo llega a 0.

## Controles e interacción

Listado breve: **clic izquierdo** (ataque clicker y, si aplica, área), **recogida de monedas** (clic, salir del área o timer), **UI del panel de mejoras** y **atajos Q/W/E/A/S/D/F/Z/X** y **espacio**. La referencia completa (comportamiento, prerrequisitos y límites tras game over) está en [controles-e-interaccion.md](controles-e-interaccion.md).

Para oleadas, jefes y dificultad, ver [flujo-de-juego.md](flujo-de-juego.md).

## Motor y escena principal

- Configuración: `project.godot` → escena de arranque `res://Scenes/World.tscn`.
- Resolución base 854×480 con modo *stretch* `viewport`.

El código fuente está comentado en español en cada archivo bajo `Scripts/`.
