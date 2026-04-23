## Ventana emergente de ayuda para una mejora (título + descripción).
class_name pop_text extends TextureRect

## Asigna textos del tooltip.
func set_text(title, details):
	$Title.text = title
	$Details.text = details

## Cierra al pulsar el botón integrado en la escena.
func _on_button_pressed():
	queue_free()

## Cierra desde código (por ejemplo al cambiar de pestaña).
func close():
	queue_free()
