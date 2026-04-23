## Moneda dorada: valor base 10 antes de multiplicadores globales.
class_name Gold_Coin extends Coin

var base_value:int = 10

## Fija [code]value[/code] y ejecuta la inicialización de [Coin].
func _ready():
	value = base_value
	super()
