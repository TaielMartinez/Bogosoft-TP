## Área de efecto del clic: daña a todos los enemigos solapados una vez (salvo lógica del timer interno).
extends Area2D

var stats : Stats
## Evita aplicar daño en área repetidamente en el mismo ciclo de vida del nodo.
var hit : bool = false

## Escala el área según la mejora de tamaño en [Stats].
func _ready():
	self.scale = Vector2(stats.click_area_size_stat, stats.click_area_size_stat)
	#CollisionShape2D.shape.set("radius", stats.click_area_size_stat)

#func _draw():
	#var cen = Vector2(0, 0)
	#var rad = stats.click_area_size_stat * 15
	#var col = Color(1,1,1)
	#var line_length = 5
	#var gap_length = 3
	#draw_dotted_circle(cen, rad, line_length, gap_length, col)
#
#func draw_dotted_circle(center: Vector2, radius: float, line_length: float, gap_length: float, color: Color):
	#var total_circumference = 2 * PI * radius
	#var num_segments = int(total_circumference / (line_length + gap_length))
	#var angle_increment = (2 * PI) / num_segments
	#
	#for i in range(num_segments):
		#var start_angle = i * angle_increment
		#var end_angle = start_angle + angle_increment * (line_length / (line_length + gap_length))
		#
		#var start_point = center + Vector2(cos(start_angle), sin(start_angle)) * radius
		#var end_point = center + Vector2(cos(end_angle), sin(end_angle)) * radius
		#
		#draw_line(start_point, end_point, color, 1)

## Al solaparse con un enemigo, aplica el daño de área una sola vez por instancia de este nodo.
func _on_area_entered(area):
	if area.is_in_group("enemy") and !hit:
		area.recibe_damage(stats.click_area_damage_stat)

## Marca que el daño en área ya no debe aplicarse (tras un breve periodo definido en la escena).
func _on_timer_timeout():
	hit = true

## Destruye el efecto visual cuando su animación termina.
func _on_area_fx_animation_finished():
	queue_free()
