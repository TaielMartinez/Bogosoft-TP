# Flujo de juego y reglas actuales

## Bucle principal

1. **`World._ready`**: crea `Stats`, enlaza `TopPanel`, `UpgradesPanel`, `GameOverPanel`, `ScorePanel`, instancia el cursor lógico `Mouse` y lo añade al árbol.
2. **`SpawnTimer`**: en cada timeout se ajusta `wait_time` a `stats.enemy_spawn_rate` y se genera entre 1 y `enemy_max_spawn_amount` enemigos. El tipo depende de probabilidades y de flags `unlock_warriors`, `unlock_mages`, `unlock_rogues`.
3. Cada enemigo recibe la referencia a `stats`, emite `enemy_death` (monedas) y `enemy_attack` (daño al castillo).
4. **`Score_Panel`**: cada segundo suma tiempo, suma 1 al puntaje y ejecuta `manage_game_events()`.

## Enemigos y castillo

- Los enemigos son `Area2D` que se mueven en X hacia la derecha (`Enemy._process`).
- Al colisionar con el nodo **`TileMap`** (nombre exacto `"TileMap"`), dejan de moverse y atacan el castillo con un temporizador (`atk_speed`).
- **`Mage_Skeleton`** no aplica daño cuerpo a cuerpo igual: lanza **`Fireball`** que al chocar con el `TileMap` emite daño vía señal.
- La vida del jugador/castillo es `stats.player_hp` con tope `stats.castle_max_hp_stat`. Cuando llega a 0, **`World.game_over()`** pausa spawns, enemigos, monedas y arqueros, y muestra el panel de fin.

## Economía

- Al morir un enemigo normal se spawnea **1** moneda; un **boss** spawnea **5** con posición ligeramente dispersa.
- ~5% de probabilidad de **moneda plateada** (más valor); el resto **oro**.
- Las monedas pueden recogerse por **timer** (autorecaudación), **clic** o **salir del área del mouse**; al recogerse hacen tween hacia la UI y emiten `coin_pickUp`.

## Progresión y dificultad

| Tiempo (seg) | Efecto |
|--------------|--------|
| Cada 60 | Boss aleatorio; `increase_coin_multiplier()` (×1.7 acumulativo sobre valor de monedas) |
| Cada 120 | `increase_difficulty()`: más vida y daño base de enemigos, más enemigos por spawn, spawn más rápido |
| 60 | Desbloquea guerreros |
| 180 | Desbloquea magos |
| 300 | Desbloquea pícaros |

## Mejoras (alto nivel)

- **Clic**: daño directo (`Click_Damage`), tamaño y daño de área (`Click_Area`).
- **Unidades**: hasta 4 arqueros en posiciones fijas; luego mejora de “+1 flecha” por disparo. Daño de flecha y cadencia escalables.
- **Defensa**: reparación (% de vida máx.) y subida de vida máxima (cura completa al comprar).

Los costes suelen duplicarse tras cada compra; las fórmulas de “siguiente valor” están en `Stats` + `Upgrades`.
