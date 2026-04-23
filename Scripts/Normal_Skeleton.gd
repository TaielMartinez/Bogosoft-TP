## Esqueleto estándar: stats tomados de [code]stats.normal_*[/code], velocidad media y puntaje base.
class_name Normal_Skeleton extends Enemy

const spd_base = 40
const score = 10

## Inicializa vida, ataque, velocidad y puntaje; los jefes amplifican stats y puntaje.
func _ready():
	life = stats.normal_hp
	atk_power = stats.normal_atk
	speed = spd_base
	enemy_score = score
	if is_boss : 
		life *= 10
		atk_power *= 5
		speed *= 0.8
		enemy_score = 1000
	super()
