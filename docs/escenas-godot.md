# Referencia de escenas (`.tscn`)

Convención: cada escena instancia nodos y asigna el script indicado en `ext_resource`. Las conexiones `signal → método` se definen en el archivo de escena.

## Escena principal y mundo

### `Scenes/World.tscn`

Escena de ejecución (`run/main_scene`). Nodos relevantes bajo `World` (Node2D con script `World.gd`):

- `SpawnTimer`: temporizador de aparición de enemigos
- `TileMap`: límite/castillo; colisión con nombre `TileMap` usada por enemigos y bolas de fuego
- `Character`: personaje decorativo / jugador visual
- `Camera2D`
- `Coins`, `Enemies`, `Defences`: contenedores para instancias dinámicas
- `CanvasLayer` → `GameOverPanel`, `TopPanel`, `UpgradesPanel`, `ScorePanel`

## UI y paneles

| Escena | Rol |
|--------|-----|
| `Top_Panel.tscn` | Vida del castillo y monedas (`TopPanel.gd`) |
| `Upgrades_Panel.tscn` | Pestañas de mejoras, botones y contenedores (`Upgrades_Panel.gd`) |
| `Score_Panel.tscn` | Tiempo y puntaje; temporizador 1 s (`Score_Panel.gd`) |
| `GameOver_Panel.tscn` | Resumen de niveles y reinicio / salir (`GameOver_Panel.gd`) |
| `pop_text.tscn` | Tooltip emergente de ayuda (`popText.gd`) |

## Jugador, entrada y proyectiles

| Escena | Rol |
|--------|-----|
| `Mouse.tscn` | Cursor animado que spawnea `Click_Damage` y opcionalmente `Click_Area` (`Mouse.gd`) |
| `Click_Damage.tscn` | Área de un solo impacto de clic (`Click_Damage.gd`) |
| `Click_Area.tscn` | Área de daño en radio alrededor del clic (`Click_Area.gd`) |
| `Character.tscn` | Personaje decorativo en el mapa (la escena no asigna script `.gd` en el repositorio; el combate es por clic vía `Mouse.tscn`) |
| `Archer.tscn` | Torreta que dispara `Arrow` periódicamente (`Archer.gd`) |
| `Arrow.tscn` | Proyectil hacia un enemigo (`Arrow.gd`) |
| `Fireball.tscn` | Proyectil del mago (`Fireball.gd`) |

## Enemigos

| Escena | Script de clase |
|--------|-----------------|
| `Normal_Skeleton.tscn` | `Normal_Skeleton.gd` → `Enemy` |
| `Warrior_Skeleton.tscn` | `Warrior_Skeleton.gd` |
| `Mage_Skeleton.tscn` | `Mage_Skeleton.gd` |
| `Rogue_Skeleton.tscn` | `Rogue_Skeleton.gd` |

Cada prefab de esqueleto extiende `Enemy.gd` y define velocidad, puntaje y stats tomados de `Stats`.

## Recolección y efectos

| Escena | Rol |
|--------|-----|
| `Gold_Coin.tscn` | Moneda base (`Gold_Coin.gd` → `Coin`) |
| `Silver_Coin.tscn` | Moneda rara de mayor valor (`Silver_Coin.gd`) |
| `Heal_Point_Bar.tscn` | Barra de vida sobre el enemigo (`Heal_Point_Bar_Enemy.gd` en el nodo raíz según asignación del editor) |
| `Enemy_Hit_FX.tscn` | Partículas/animación de impacto en el castillo |

> Nota: el script `Heal_Point_Bar_Enemy.gd` controla la barra de HP flotante; la escena debe tener los nodos `Life` y `PercentLife` esperados por el script.
