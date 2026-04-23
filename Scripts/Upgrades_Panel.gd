## Panel de mejoras: pestañas (clics, unidades, defensa), compras, tooltips y atajos de teclado.
class_name UpgradesPanel extends Node

# Importing instantiable scenes
var archer : PackedScene = preload("res://Scenes/Archer.tscn")
@onready var _pop_text = preload("res://Scenes/pop_text.tscn")
var pop_text_instance

# Received from World
var stats:Stats
var top_panel:TopPanel

# Archer Positions
var archer_positions = [Vector2(361, 16), Vector2(361, 65), Vector2(361, 155), Vector2(361, 191)]

# Upgrade Container scenes
@onready var tab_container = $MarginContainer/TabContainer
@onready var click_damage = $MarginContainer/TabContainer/ClicksPanel/VBoxContainer/ClickDamageContainer
@onready var click_area_size = $MarginContainer/TabContainer/ClicksPanel/VBoxContainer/ClickAreaSizeContainer
@onready var click_area_damage = $MarginContainer/TabContainer/ClicksPanel/VBoxContainer/ClickAreaDamageContainer
@onready var number_archers = $MarginContainer/TabContainer/UnitsPanel/VBoxContainer/NumberArchersContainer
@onready var arrow_damage = $MarginContainer/TabContainer/UnitsPanel/VBoxContainer/ArrowDamageContainer
@onready var arrow_cooldown = $MarginContainer/TabContainer/UnitsPanel/VBoxContainer/ArrowCooldownContainer
@onready var number_arrows = $MarginContainer/TabContainer/UnitsPanel/VBoxContainer/NumberArrowsContainer
@onready var castle_repairs = $MarginContainer/TabContainer/DefensesPanel/VBoxContainer/CastleRepairsContainer
@onready var castle_max_hp = $MarginContainer/TabContainer/DefensesPanel/VBoxContainer/CastleMaxHPContainer

## Enfoca el botón de pestaña “Clicks” al iniciar.
func _ready():
	# Focus on Clicks menu button at startup
	$MenuControls/ClicksButton.grab_focus()

# Upgrades' pop text behavior ------------------------
## Cierra el tooltip de ayuda si sigue abierto.
func _close_preexisting_pop_text():
	if pop_text_instance != null:
		pop_text_instance.close()
		
## Muestra un cuadro de ayuda (escena pop_text) con título y descripción de la mejora.
func _show_pop_text(title, description):
	_close_preexisting_pop_text()
	pop_text_instance = _pop_text.instantiate()
	pop_text_instance.position = Vector2(468, 5)
	pop_text_instance.set_text(title, description)
	add_child(pop_text_instance)

# Tab switching and sliding -------------------------------
## Al cambiar de pestaña, cierra tooltips para no dejar texto obsoleto.
func _on_tab_container_tab_changed(_tab):
	_close_preexisting_pop_text()

## Cambia a la pestaña de mejoras de clic.
func _on_clicks_button_pressed():
	tab_container.set_current_tab(0)

## Cambia a la pestaña de unidades (arqueros / flechas).
func _on_units_button_pressed():
	tab_container.set_current_tab(1)

## Cambia a la pestaña de defensas del castillo.
func _on_defenses_button_pressed():
	tab_container.set_current_tab(2)

## Desliza el panel verticalmente y alterna el texto del botón (panel plegable).
func _on_slider_button_toggled(toggled_on):
	_close_preexisting_pop_text()
	
	var slide_tween = get_tree().create_tween()
	if !toggled_on: 
		slide_tween.tween_property(self, "position", Vector2(0, 174), 0.25)
		$SliderButton.set_text("▼ Upgrades")
	else: 
		slide_tween.tween_property(self, "position", Vector2(0, 224), 0.25)
		$SliderButton.set_text("▲ Upgrades")


# CLICKS UPGRADES -----------------------------------------
# Click Damage container
## Abre tooltip: daño de clic.
func _on_click_damage_texture_button_pressed():
	_show_pop_text(
		"Click Damage [Q]", 
		"Increases the damage dealt by the player's active clicks.")

## Compra mejora de daño de clic si hay monedas suficientes.
func _on_click_damage_upgrade_button_pressed():
	# Extra check in case of KeyboardInput
	if stats.total_coins < stats.click_damage_cost: return
	
	# Stats updates (coin, level, stat, etc.)
	stats.upgrade_click_damage()
	
	# UI updates (coins on topbar, upgrade_container, every upgrade_button)
	top_panel.update_player_coins()
	click_damage.load_values(stats.click_damage_level, stats.click_damage_stat, stats.click_damage_cost, stats.click_damage_next)
	update_upgrade_button_status()

# Click Area Size container
## Abre tooltip: tamaño del área de clic.
func _on_click_area_size_texture_button_pressed():
	_show_pop_text(
		"Click Area Size [W]", 
		"Expands the size of the damaging area surrounding a ​​click.")

## Compra tamaño de área y puede revelar la mejora de daño de área.
func _on_click_area_size_upgrade_button_pressed():
	# Extra check in case of KeyboardInput
	if stats.total_coins < stats.click_area_size_cost: return
	
	# Stats updates (coin, level, stat, etc.)
	stats.upgrade_click_area_size()
	
	# UI updates (coins on topbar, upgrade_container, every upgrade_button)
	top_panel.update_player_coins()
	click_area_size.load_values(stats.click_area_size_level, stats.click_area_size_stat, stats.click_area_size_cost, stats.click_area_size_next)
	update_upgrade_button_status()
	
	# If upgraded once, click_area_damage container appears
	if stats.click_area_damage_level >= 1: click_area_damage.set_visible(true)

# Click Area Damage container
## Abre tooltip: daño del área de clic.
func _on_click_area_damage_texture_button_pressed():
	_show_pop_text(
		"Click Area Damage [E]", 
		"Increases the damage of the area surrounding a click.")

## Compra daño de área (requiere haber desbloqueado área con tamaño > 0).
func _on_click_area_damage_upgrade_button_pressed():
	# Extra check in case of KeyboardInput
	if stats.total_coins < stats.click_area_damage_cost or stats.click_area_size_stat == 0:
		return
	
	# Stats updates (coin, level, stat, etc.)
	stats.upgrade_click_area_damage()
	
	# UI updates (coins on topbar, upgrade_container, every upgrade_button)
	top_panel.update_player_coins()
	click_area_damage.load_values(stats.click_area_damage_level, stats.click_area_damage_stat, stats.click_area_damage_cost, stats.click_area_damage_next)
	update_upgrade_button_status()


# UNITS UPGRADES ------------------------------------------
# +1 Archer container
## Abre tooltip: añadir arquero.
func _on_number_archers_texture_button_pressed():
	_show_pop_text(
		"+1 Archer [A]", 
		"Places an additional archer, fires arrows automatically.")

## Compra un arquero: instancia en [code]Defences[/code] y actualiza visibilidad de mejoras de flecha.
func _on_number_archers_upgrade_button_pressed():
	# Extra check in case of KeyboardInput
	if stats.total_coins < stats.number_archers_cost or stats.number_archers_level >= 4:
		return
	
	# Add archer to World
	var new_archer = archer.instantiate()
	new_archer.stats = stats
	new_archer.global_position = archer_positions[stats.number_archers_level]
	get_parent().get_parent().get_node("Defences").add_child(new_archer)
	
	# Stats updates (coin, level, stat, etc.)
	stats.upgrade_number_archers()
	
	# UI updates (coins on topbar, upgrade_container, every upgrade_button)
	top_panel.update_player_coins()
	number_archers.load_values(stats.number_archers_level, stats.number_archers_stat, stats.number_archers_cost, stats.number_archers_next)
	update_upgrade_button_status()
	
	# If upgraded once, show arrow upgrades
	# If all archers bought, replace upgrade for number_arrows
	if stats.number_archers_level == 1:
		arrow_damage.set_visible(true)
		arrow_cooldown.set_visible(true)
	if stats.number_archers_level == 4:
		number_archers.set_visible(false)
		number_arrows.set_visible(true)

# Arrow Damage container ----------------------------------
## Abre tooltip: daño de flecha.
func _on_arrow_damage_texture_button_pressed():
	_show_pop_text(
		"Arrow Damage [S]", 
		"Increases the damage of a fired arrow.")

## Compra daño de flecha (requiere al menos un arquero).
func _on_arrow_damage_upgrade_button_pressed():
	# Extra check in case of KeyboardInput
	if stats.total_coins < stats.arrow_damage_cost or stats.number_archers_level == 0:
		return
	
	# Stats updates (coin, level, stat, etc.)
	stats.upgrade_arrow_damage()
	
	# UI updates (coins on topbar, upgrade_container, every upgrade_button)
	top_panel.update_player_coins()
	arrow_damage.load_values(stats.arrow_damage_level, stats.arrow_damage_stat, stats.arrow_damage_cost, stats.arrow_damage_next)
	update_upgrade_button_status()

# Arrow Cooldown container --------------------------------
## Abre tooltip: cadencia de disparo.
func _on_arrow_cooldown_texture_button_pressed():
	_show_pop_text(
		"Arrow Cooldown [D]", 
		"Decreases the time between arrows fired.")

## Compra reducción de tiempo entre disparos.
func _on_arrow_cooldown_upgrade_button_pressed():
	# Extra check in case of KeyboardInput
	if stats.total_coins < stats.arrow_cooldown_cost or stats.number_archers_level == 0:
		return
	
	# Stats updates (coin, level, stat, etc.)
	stats.upgrade_arrow_cooldown()
	
	# UI updates (coins on topbar, upgrade_container, every upgrade_button)
	top_panel.update_player_coins()
	arrow_cooldown.load_values(stats.arrow_cooldown_level, stats.arrow_cooldown_stat, stats.arrow_cooldown_cost, stats.arrow_cooldown_next)
	update_upgrade_button_status()

# +1 Arrow container --------------------------------------
## Abre tooltip: más flechas por disparo.
func _on_number_arrows_texture_button_pressed():
	_show_pop_text(
		"+1 Arrow [F]", 
		"Fires an additional arrow per shot.")

## Compra flecha adicional por ciclo (solo con los 4 arqueros comprados).
func _on_number_arrows_upgrade_button_pressed():
	# Extra check in case of KeyboardInput
	if stats.total_coins < stats.number_arrows_cost or stats.number_archers_level < 4:
		return
	
	# Stats updates (coin, level, stat, etc.)
	stats.upgrade_number_arrows()
	
	# UI updates (coins on topbar, upgrade_container, every upgrade_button)
	top_panel.update_player_coins()
	number_arrows.load_values(stats.number_arrows_level, stats.number_arrows_stat, stats.number_arrows_cost, stats.number_arrows_next)
	update_upgrade_button_status()


# DEFENSES UPGRADES ---------------------------------------
# Castle Repairs container --------------------------------
## Abre tooltip: reparación del castillo.
func _on_castle_repairs_texture_button_pressed():
	_show_pop_text(
		"Castle Repairs [Z]", 
		"Instantly recovers a fixed amount of HP.")
	
## Gasta monedas para curar una fracción de la vida máxima.
func _on_castle_repairs_upgrade_button_pressed():
	# Extra check in case of KeyboardInput
	if stats.total_coins < stats.castle_repairs_cost or stats.player_hp == stats.castle_max_hp_stat:
		return
	
	# Stats updates (coin, level, stat, etc.)
	stats.upgrade_castle_repairs()
	
	# UI updates (coins AND HP on topbar, upgrade_container not needed, every upgrade_button)
	top_panel.update_player_coins()
	top_panel.update_player_hp()
	#castle_repairs.load_values(null, "Heal 25%HP", stats.castle_repairs_cost, null)
	update_upgrade_button_status()

# Castle Max HP container ---------------------------------
## Abre tooltip: subir vida máxima.
func _on_castle_max_hp_texture_button_pressed():
	_show_pop_text(
		"Castle Max HP [X]", 
		"Increases the castle's maximum health points.")
	
## Compra aumento de vida máxima y actualiza coste de reparación en UI.
func _on_castle_max_hp_upgrade_button_pressed():
	# Extra check in case of KeyboardInput
	if stats.total_coins < stats.castle_max_hp_cost:
		return
	
	# Stats updates (coin, level, stat, etc.)
	stats.upgrade_castle_max_hp()
	
	# UI updates (coins AND HP on topbar, repair AND max_hp containers, every upgrade_button)
	top_panel.update_player_coins()
	top_panel.update_player_hp()
	castle_repairs.load_values(null, "Heal 25%HP", stats.castle_repairs_cost, null)
	castle_max_hp.load_values(stats.castle_max_hp_level, stats.castle_max_hp_stat, stats.castle_max_hp_cost, stats.castle_max_hp_next)
	update_upgrade_button_status()


# Keyboard Inputs -----------------------------------------
## Atajos (Q/W/E/A/S/D/F/Z/X y espacio): delegan en los mismos handlers que los botones.
func _unhandled_key_input (_event):
	# Disable inputs on game over
	if stats.player_hp == 0: return
	
	if Input.is_action_just_pressed("upgclick"):
		_on_click_damage_upgrade_button_pressed()
	elif Input.is_action_just_pressed("upgarea"):
		_on_click_area_size_upgrade_button_pressed()
	elif Input.is_action_just_pressed("upgareadmg"):
		_on_click_area_damage_upgrade_button_pressed()
	elif Input.is_action_just_pressed("unlockarcher"):
		_on_number_archers_upgrade_button_pressed()
	elif Input.is_action_just_pressed("upgarchdmg"):
		_on_arrow_damage_upgrade_button_pressed()
	elif Input.is_action_just_pressed("upgarchas"):
		_on_arrow_cooldown_upgrade_button_pressed()
	elif Input.is_action_just_pressed("upgarchmultishot"):
		_on_number_arrows_upgrade_button_pressed()
	elif Input.is_action_just_pressed("upgheal"):
		_on_castle_repairs_upgrade_button_pressed()
	elif Input.is_action_just_pressed("upgmaxlife"):
		_on_castle_max_hp_upgrade_button_pressed()
	elif Input.is_action_just_pressed("openupgmenu"):
		$SliderButton.set_pressed(!$SliderButton.is_pressed())


# VALUE LOADING AND UPDATING ------------------------------
## Rellena todos los contenedores de mejora desde [code]stats[/code] al inicio de la partida.
func load_initial_values():
	# Loads initial values of containers and buttons at startup
	# Clicks upgrades
	click_damage.load_values(stats.click_damage_level, stats.click_damage_stat, stats.click_damage_cost, stats.click_damage_next)
	click_area_size.load_values(stats.click_area_size_level, stats.click_area_size_stat, stats.click_area_size_cost, stats.click_area_size_next)
	click_area_damage.load_values(stats.click_area_damage_level, stats.click_area_damage_stat, stats.click_area_damage_cost, stats.click_area_damage_next)
	
	# Units upgrades
	number_archers.load_values(stats.number_archers_level, stats.number_archers_stat, stats.number_archers_cost, stats.number_archers_next)
	arrow_damage.load_values(stats.arrow_damage_level, stats.arrow_damage_stat, stats.arrow_damage_cost, stats.arrow_damage_next)
	arrow_cooldown.load_values(stats.arrow_cooldown_level, stats.arrow_cooldown_stat, stats.arrow_cooldown_cost, stats.arrow_cooldown_next)
	number_arrows.load_values(stats.number_arrows_level, stats.number_arrows_stat, stats.number_arrows_cost, stats.number_arrows_next)
	
	# Defenses upgrades
	castle_repairs.load_values(null, "Heal 25%HP", stats.castle_repairs_cost, null)
	castle_max_hp.load_values(stats.castle_max_hp_level, stats.castle_max_hp_stat, stats.castle_max_hp_cost, stats.castle_max_hp_next)
	
	# Buttons statuses
	update_upgrade_button_status()

## Habilita o deshabilita cada botón de compra según monedas y reglas (vida llena, prerequisitos).
func update_upgrade_button_status():
	# Runs at startup, after collecting a coin, and after buying an upgrade
	click_damage.update_button_status(stats.total_coins < stats.click_damage_cost)
	click_area_size.update_button_status(stats.total_coins < stats.click_area_size_cost)
	click_area_damage.update_button_status(stats.total_coins < stats.click_area_damage_cost)
	
	number_archers.update_button_status(stats.total_coins < stats.number_archers_cost)
	arrow_damage.update_button_status(stats.total_coins < stats.arrow_damage_cost)
	arrow_cooldown.update_button_status(stats.total_coins < stats.arrow_cooldown_cost)
	number_arrows.update_button_status(stats.total_coins < stats.number_arrows_cost)
	
	castle_repairs.update_button_status(stats.total_coins < stats.castle_repairs_cost or stats.player_hp == stats.castle_max_hp_stat)
	castle_max_hp.update_button_status(stats.total_coins < stats.castle_max_hp_cost)
