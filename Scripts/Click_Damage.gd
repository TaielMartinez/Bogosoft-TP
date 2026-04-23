## Hitbox puntual del clic: daña al primer enemigo que entre en contacto y luego se desactiva.
extends Area2D

var stats : Stats
## Impide dañar más de un enemigo con el mismo impacto puntual.
var hit : bool = false

## Aplica daño de clic al primer enemigo detectado.
func _on_area_entered(area):
	if area.is_in_group("enemy") && !hit:
		area.recibe_damage(stats.click_damage_stat)
		hit = true

## Cierra la ventana de daño (sincronizado con timer de la escena).
func _on_timer_timeout():
	hit = true

## Elimina el nodo al terminar la animación del efecto de clic.
func _on_click_fx_animation_finished():
	queue_free()
