# Referencia de scripts (`Scripts/*.gd`)

Leyenda: **señal** = emitida hacia otros nodos; **slot** = conectado desde el editor o por código.

---

## `World.gd` — `class_name World` extends `Node`

Núcleo de la partida: spawns, economía, daño al castillo y game over.

| Símbolo | Tipo | Descripción |
|---------|------|-------------|
| `offset_coin` | const | Desplazamiento vertical al spawnear monedas |
| `_ready` | func | Enlaza `stats` a paneles, señales de score/gameover, instancia `Mouse` |
| `spawn_coins` | func | Crea monedas en `position`; `_amount` monedas; conecta `coin_pickUp` |
| `_on_coin_pick_up` | func | Suma monedas con multiplicador; refresca UI de monedas y botones |
| `_on_spawn_timer_timeout` | func | Ajusta intervalo del timer; elige cantidad y tipo de enemigo; llama `spawn_enemy` |
| `spawn_enemy` | func | Posiciona enemigo, conecta señales, asigna `stats`, lo añade a `Enemies` |
| `_on_castle_attacked` | func | Aplica daño vía `stats.take_damage`; actualiza barra; puede llamar `game_over` |
| `spawn_boss` | func | Igual que spawn normal pero `is_boss`, escala 1.5 y posición Y centrada |
| `game_over` | func | Pausa sistemas, congela enemigos/monedas/arqueros, muestra panel final |
| `_on_restart_button_pressed` | func | Recarga la escena actual |
| `_on_quit_button_pressed` | func | Cierra la aplicación |

---

## `Enemy.gd` — `class_name Enemy` extends `Area2D`

Clase base de todos los esqueletos.

| Símbolo | Tipo | Descripción |
|---------|------|-------------|
| `enemy_death` | señal | `(posición, cantidad_monedas)` al terminar animación de muerte |
| `enemy_attack` | señal | Daño entero hacia el castillo |
| `_ready` | func | Grupo `enemy`, barra de vida, timer de ataque |
| `_process` | func | Movimiento horizontal según `speed` |
| `_on_body_entered` | func | Reacción al chocar con `TileMap`: idle + timer de ataque |
| `recibe_damage` | func | Reduce vida, flash rojo, inicia muerte o ignora si ya está muerto |
| `_on_animated_sprite_2d_animation_changed` | func | Suma `enemy_score` al pasar a animación `death` |
| `_on_animated_sprite_2d_animation_finished` | func | Emite `enemy_death` y libera el nodo |
| `attack_castle` | func | Animación de golpe + emite `enemy_attack(atk_power)` |
| `animate_attack` | func | Tween de rotación e instancia `Enemy_Hit_FX` cerca del castillo |

---

## `Stats.gd` — `class_name Stats` extends `Node`

Estado global de partida: stats de enemigos, mejoras, monedas, vida, multiplicadores.

| Símbolo | Descripción |
|---------|-------------|
| `_init` | Calcula valores “siguiente nivel” iniciales usando `Upgrades` |
| `upgrade_click_damage` | Gasta monedas; sube nivel y daño de clic |
| `upgrade_click_area_size` | Gasta monedas; aumenta tamaño de área (escala del área) |
| `upgrade_click_area_damage` | Gasta monedas; aumenta daño del área |
| `upgrade_number_archers` | Gasta monedas; incrementa contador de arqueros comprados |
| `upgrade_arrow_damage` | Gasta monedas; sube daño por flecha |
| `upgrade_arrow_cooldown` | Gasta monedas; reduce tiempo entre disparos (valor float) |
| `upgrade_number_arrows` | Gasta monedas; más flechas por ciclo de disparo |
| `upgrade_castle_repairs` | Gasta monedas; cura hasta 25% de `castle_max_hp_stat` o tope |
| `upgrade_castle_max_hp` | Gasta monedas; sube máximo, cura al máximo, recalcula coste de reparación |
| `take_damage` | Reduce `player_hp` sin bajar de 0 |
| `increase_coin_multiplier` | Multiplica `coin_value_multiplier` por 1.7 |
| `increase_difficulty` | Incrementa multiplicadores y **vuelve a multiplicar** HP/ATK base por tipo; ajusta spawn |

---

## `Upgrades.gd` — `class_name Upgrades` extends `Node`

Fórmulas de escalado para mejoras.

| Función | Descripción |
|---------|-------------|
| `generic_update` | Duplica el entero hasta un tope incremental, luego suma `max_increment` |
| `generic_update_float` | Si `increase`: multiplica por 1.2; si no: reduce (mínimo 0.5 en cadencia); caso 0 → 1 para primer paso de área |

---

## `Click_Area.gd` extends `Area2D`

Daño en área alrededor del clic (una vez por enemigo hasta timeout).

| Función | Descripción |
|---------|-------------|
| `_ready` | Escala el nodo según `stats.click_area_size_stat` |
| `_on_area_entered` | Si es enemigo y no hubo hit global, aplica `click_area_damage_stat` |
| `_on_timer_timeout` | Marca `hit` para evitar daño repetido |
| `_on_area_fx_animation_finished` | Destruye el nodo al terminar FX |

---

## `Click_Damage.gd` extends `Area2D`

Daño del clic puntual.

| Función | Descripción |
|---------|-------------|
| `_on_area_entered` | Daño único `click_damage_stat` al primer enemigo solapado |
| `_on_timer_timeout` | Marca fin de ventana de daño |
| `_on_click_fx_animation_finished` | Libera el nodo |

---

## `Normal_Skeleton.gd` — `class_name Normal_Skeleton` extends `Enemy`

| Función | Descripción |
|---------|-------------|
| `_ready` | Asigna HP/ATK desde `stats.normal_*`, velocidad base, puntaje; si boss amplifica; llama `super._ready()` |

---

## `Warrior_Skeleton.gd` — `class_name Warrior_Skeleton` extends `Enemy`

| Función | Descripción |
|---------|-------------|
| `_ready` | Stats desde `stats.warrior_*`; más lento y resistente que el normal |

---

## `Mage_Skeleton.gd` — `class_name Mage_Skeleton` extends `Enemy`

| Función | Descripción |
|---------|-------------|
| `_ready` | Stats de mago + `super` |
| `attack_castle` | Animación + instancia `Fireball` con `damage = atk_power` |
| `_add_new_fireball` | Añade la bola de fuego al padre (mundo/enemigos) de forma diferida |
| `_on_body_entered` | Ajuste visual de posición/manos antes del comportamiento base |
| `fireball_dmg` | Reenvía daño del proyectil con `enemy_attack.emit` |
| `animate_attack` | Tween de las “manos” en lugar de la rotación genérica sola |

---

## `Rogue_Skeleton.gd` — `class_name Rogue_Skeleton` extends `Enemy`

| Función | Descripción |
|---------|-------------|
| `_ready` | Esqueleto rápido, poco daño por golpe pero `atk_speed` bajo (1 s) |

---

## `Archer.gd` — `class_name Archer` extends `Node2D`

| Función | Descripción |
|---------|-------------|
| `_ready` | Grupo `archer`; temporizador inicial = cadencia de flechas |
| `_on_timer_timeout` | Actualiza wait_time; elige hasta `number_arrows_stat` objetivos aleatorios con `disparar` |
| `disparar` | Si el enemigo está a la derecha (`x >= 0`), crea `Arrow` hacia su posición |

---

## `Arrow.gd` — `class_name Arrow` extends `Area2D`

| Función | Descripción |
|---------|-------------|
| `_ready` | Calcula dirección hacia `position_target` y rota el sprite |
| `_process` | Movimiento a velocidad fija 300; borra si sale de pantalla |
| `_on_area_entered` | Daño `arrow_damage_stat` una vez a un enemigo y se destruye |

---

## `Fireball.gd` — `class_name Fireball` extends `Area2D`

| Símbolo | Descripción |
|---------|-------------|
| `proyectile_hit` | señal con el daño al impactar castillo |
| `_process` | Avanza en X; borrado fuera de pantalla |
| `_on_body_entered` | Si es `TileMap`, para, emite daño, reproduce explosión |
| `_on_animated_sprite_2d_animation_finished` | Libera el nodo |

---

## `Mouse.gd` extends `AnimatedSprite2D`

| Función | Descripción |
|---------|-------------|
| `_process` | Cursor personalizado con el frame actual del sprite |
| `_unhandled_input` | Clic: animación + instancia `Click_Damage` y opcionalmente `Click_Area` si hay tamaño de área |

---

## `Coin.gd` — `class_name Coin` extends `Area2D`

| Símbolo | Descripción |
|---------|-------------|
| `coin_pickUp` | señal con el valor numérico de la moneda |
| `_ready` | Grupo `coin`; no monitorizable por defecto |
| `_on_mouse_exited` / `_on_input_event` / `_on_timer_timeout` | Disparan recogida |
| `on_coin_pickUp` | Tween hacia posición fija de UI |
| `on_move_coin_finished` | Emite valor y `queue_free` |

---

## `Gold_Coin.gd` / `Silver_Coin.gd`

| Clase | `value` inicial |
|-------|------------------|
| `Gold_Coin` | 10 |
| `Silver_Coin` | 50 |

Ambas llaman `super._ready()` en `Coin`.

---

## `Top_Panel.gd` — `class_name TopPanel` extends `Node`

| Función | Descripción |
|---------|-------------|
| `load_values` | Refresca HP y monedas |
| `update_player_coins` | Texto formateado de `total_coins` |
| `update_player_hp` | Barra y etiqueta HP / máximo |
| `format_number` | Abreviaturas K, M, B, etc. |

---

## `Upgrades_Panel.gd` — `class_name UpgradesPanel` extends `Node`

Muchos slots `_on_*_pressed` enlazados desde la escena: cada uno valida monedas, llama al `upgrade_*` correspondiente en `Stats`, actualiza contenedores (`Upgrade_Container`) y `update_upgrade_button_status`. Incluye atajos en `_unhandled_key_input`.

| Función | Descripción |
|---------|-------------|
| `_close_preexisting_pop_text` | Cierra tooltip anterior |
| `_show_pop_text` | Muestra título y descripción de una mejora |
| `_on_tab_container_tab_changed` | Cierra popups al cambiar pestaña |
| `_on_*_button_pressed` (Clicks/Units/Defenses) | Cambia pestaña del `TabContainer` |
| `_on_slider_button_toggled` | Animación vertical del panel de mejoras |
| `load_initial_values` | Carga todos los `Upgrade_Container` desde `stats` |
| `update_upgrade_button_status` | Habilita/deshabilita cada botón según monedas y reglas |

Funciones de UI y compra (cada par *texture* / *upgrade* donde aplica):

- `_ready`, `_close_preexisting_pop_text`, `_show_pop_text`, `_on_tab_container_tab_changed`
- `_on_clicks_button_pressed`, `_on_units_button_pressed`, `_on_defenses_button_pressed`, `_on_slider_button_toggled`
- `_on_click_damage_texture_button_pressed`, `_on_click_damage_upgrade_button_pressed`
- `_on_click_area_size_texture_button_pressed`, `_on_click_area_size_upgrade_button_pressed`
- `_on_click_area_damage_texture_button_pressed`, `_on_click_area_damage_upgrade_button_pressed`
- `_on_number_archers_texture_button_pressed`, `_on_number_archers_upgrade_button_pressed`
- `_on_arrow_damage_texture_button_pressed`, `_on_arrow_damage_upgrade_button_pressed`
- `_on_arrow_cooldown_texture_button_pressed`, `_on_arrow_cooldown_upgrade_button_pressed`
- `_on_number_arrows_texture_button_pressed`, `_on_number_arrows_upgrade_button_pressed`
- `_on_castle_repairs_texture_button_pressed`, `_on_castle_repairs_upgrade_button_pressed`
- `_on_castle_max_hp_texture_button_pressed`, `_on_castle_max_hp_upgrade_button_pressed`
- `_unhandled_key_input`, `load_initial_values`, `update_upgrade_button_status`

---

## `Upgrade_Container.gd` extends `Node`

| Función | Descripción |
|---------|-------------|
| `load_values` | Rellena etiquetas de nivel, stat actual, coste y próximo valor |
| `update_button_status` | `disabled` del botón y color del texto “siguiente” |
| `format_number` | Igual lógica abreviada que el panel superior |

---

## `Score_Panel.gd` extends `Node`

| Símbolo | Descripción |
|---------|-------------|
| `spawn_boss` | señal hacia `World.spawn_boss` |
| `_on_timer_timeout` | +1 s tiempo, +1 puntaje, `load_values`, `manage_game_events` |
| `load_values` | Actualiza etiquetas |
| `format_time` | `HH:MM:SS` o `MM:SS` |
| `manage_game_events` | Boss/minuto, dificultad/2 min, desbloqueos por tiempo |
| `stop_timer` | Detiene el temporizador del panel |

---

## `GameOver_Panel.gd` extends `Node`

| Función | Descripción |
|---------|-------------|
| `_ready` | Oculta botones; timer para mostrarlos |
| `load_values` | Rellena resumen de niveles de mejoras; arranca timer 2 s |
| `activate_buttons` | Tween de etiqueta y visibilidad de reiniciar / salir |
| `_on_restart_button_pressed` | Emite `restart_game` |
| `_on_quit_button_pressed` | Emite `quit_game` |

---

## `Heal_Point_Bar_Enemy.gd` extends `TextureRect`

| Función | Descripción |
|---------|-------------|
| `_ready` | Guarda geometría inicial de la barra |
| `set_life` | Primera vez fija `max_life`; actualiza texto y escala/posición del relleno |
| `format_number` | Abreviaturas numéricas para el texto de vida |

---

## `popText.gd` — `class_name pop_text` extends `TextureRect`

| Función | Descripción |
|---------|-------------|
| `set_text` | Asigna título y detalle |
| `_on_button_pressed` | Cierra el popup |
| `close` | Cierra desde código externo |
