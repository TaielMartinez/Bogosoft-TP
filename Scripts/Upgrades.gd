## Utilidades numéricas para calcular el siguiente valor de una mejora (enteros y flotantes).
class_name Upgrades extends Node

# For generic_update
const multiplier = 2 
const max_increment = 100

# For generic_update_float
const delta_upgrade = 0.2

## Si el valor es bajo, lo multiplica por [code]multiplier[/code]; si ya es alto, suma [code]max_increment[/code].
func generic_update(var_to_update):
	if var_to_update < max_increment: var_to_update = int(var_to_update * multiplier)
	else: var_to_update += max_increment
	return var_to_update

## Ajusta un float: si [param increase] es verdadero crece (~20%); si no, decrece (mínimo 0.5 para cadencias). Caso especial 0→1 para el primer tamaño de área.
func generic_update_float(var_to_update, increase):
	if !increase and var_to_update <= 0.5: return 0.5
	if var_to_update == 0: return 1 # First Area Size upgrade
	
	if increase: var_to_update *= (1 + delta_upgrade)
	else: var_to_update *= (1 - delta_upgrade)
	return var_to_update
