## Panel de tiempo y puntaje: avanza cada segundo y dispara eventos de jefe y dificultad.
extends Node

var stats:Stats

@onready var time_label = $MarginContainer/HBoxContainer/TimeContainer/Label
@onready var score_label = $MarginContainer/HBoxContainer/ScoreContainer/Label

## Aviso al [World] para generar un jefe y ajustar economía.
signal spawn_boss

## Suma un segundo de tiempo, un punto de score y evalúa hitos de desbloqueo y dificultad.
func _on_timer_timeout():
	stats.time += 1
	stats.score += 1
	load_values()
	manage_game_events()

## Actualiza las etiquetas visibles con [code]stats[/code].
func load_values():
	time_label.text = format_time()
	score_label.text = str(stats.score)

## Devuelve tiempo como MM:SS o HH:MM:SS según duración.
func format_time():
	var hours = stats.time / 3600
	var minutes = (stats.time % 3600) / 60
	var seconds = stats.time % 60
	
	if hours < 1: return "%02d:%02d" % [minutes, seconds]
	else: return "%02d:%02d:%02d" % [hours, minutes, seconds]

## Cada minuto: jefe y más valor de moneda. Cada 2 minutos: sube dificultad. Desbloqueos por tiempo fijo.
func manage_game_events():
	# Emit special event signals / adjust difficulty HERE
	# (starts checking from second 1)
	
	# Boss Enemy every minute
	if stats.time % 60 == 0: 
		spawn_boss.emit()
		stats.increase_coin_multiplier()
		
	# Difficulty increase every 2 minutes
	if stats.time % 120 == 0: stats.increase_difficulty()
	
	# Unlock more enemy types
	if stats.time == 60: stats.unlock_warriors = true
	if stats.time == 180 : stats.unlock_mages = true
	if stats.time == 300 : stats.unlock_rogues = true

## Detiene el reloj de partida (game over).
func stop_timer():
	$Timer.stop()
