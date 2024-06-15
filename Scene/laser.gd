extends CharacterBody2D

var speed : int = 550
@export var damage : int

func _physics_process(_delta: float) -> void:
	
	# movement
	velocity = Vector2(0,-1) * speed
	move_and_slide()
	
	# bounds
	if global_position.y < 17:
		queue_free()
