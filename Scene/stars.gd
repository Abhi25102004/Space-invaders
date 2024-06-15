extends Sprite2D

var change : int = 1
var size : float = 0.5

func _process(delta: float) -> void:
	randomize()
	size += change * size * delta
	scale = Vector2(size,size)
	if size >= 0.6:
		change = -1
	if size <= 0.4:
		change = 1
