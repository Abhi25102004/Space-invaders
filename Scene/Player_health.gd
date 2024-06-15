extends CharacterBody2D

signal add_health_checker

var speed : int = 350


func _physics_process(_delta: float) -> void:
	
	# movement
	velocity = Vector2(0,1) * speed
	move_and_slide()
	
	# bounds
	if global_position.y > 631:
		queue_free()

func _on_tree_exited() -> void:
	add_health_checker.emit()
