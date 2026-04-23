## Proyectil del arquero: vuela en línea recta hacia el punto apuntado y daña un enemigo una vez.
class_name Arrow extends Area2D

var viewport_size = DisplayServer.window_get_size()
var position_target : Vector2
var direction : Vector2
var stats : Stats
var hit : bool = false

## Calcula vector unitario hacia el objetivo y orienta el sprite.
func _ready():
	direction = global_position.direction_to(position_target)
	rotation = direction.angle()

## Movimiento constante; se destruye al salir de los bordes de la ventana.
func _process(delta):
	global_position += direction * 300 * delta
	if position.x < 0 or position.x > viewport_size.x or position.y < 0 or position.y > viewport_size.y:
		queue_free()

## Colisión con enemigo: aplica daño de flecha y destruye la flecha.
func _on_area_entered(area):
	if area.is_in_group("enemy") and !hit:
		area.recibe_damage(stats.arrow_damage_stat)
		hit = true
		queue_free()
