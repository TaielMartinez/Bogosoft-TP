## Moneda plateada: valor base 50 (recompensa rara).
class_name Silver_Coin extends Coin

var base_value:int = 50

## Fija [code]value[/code] y ejecuta la inicialización de [Coin].
func _ready():
	value = base_value
	super()
