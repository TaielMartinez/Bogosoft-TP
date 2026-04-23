## Esqueleto tanque: más vida y daño que el normal, más lento.
class_name Warrior_Skeleton extends Enemy

const spd_base = 25
const score = 25

## Inicializa desde [code]stats.warrior_*[/code] y aplica multiplicadores de jefe si corresponde.
func _ready():
	life = stats.warrior_hp
	atk_power = stats.warrior_atk
	speed = spd_base
	enemy_score = score
	if is_boss : 
		life *= 10
		atk_power *= 5
		speed *= 0.8
		enemy_score = 1000
	super()
