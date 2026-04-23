## Moneda recogible: tween hacia la UI y emite su valor al completar el movimiento.
class_name Coin extends Area2D

signal coin_pickUp
var value

## Grupo [code]coin[/code] y desactiva monitorización para ciertas consultas de física.
func _ready():
	add_to_group("coin")
	set_monitorable(false)

## Recogida al salir el mouse del área (autocollect o arrastre).
func _on_mouse_exited():
	on_coin_pickUp()

## Recogida explícita con clic.
func _on_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		on_coin_pickUp()

## Recogida automática por temporizador de la escena.
func _on_timer_timeout():
	on_coin_pickUp()

## Inicia animación de vuelo hacia la posición fija del contador de monedas.
func on_coin_pickUp():
	var move_coin = get_tree().create_tween()
	move_coin.tween_property(self, "position", Vector2(112, 12), 0.5)
	move_coin.connect("finished", on_move_coin_finished)
	
## Al terminar el tween, notifica el valor y elimina la moneda.
func on_move_coin_finished():
	coin_pickUp.emit(value)
	queue_free()
