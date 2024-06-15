extends CharacterBody2D

var direction : int = 1
var speed : int = 300
var able_shoot : bool = false
var laser_instance : PackedScene = preload("res://Scene/enemy_laser.tscn")
@onready var timer: Timer = $Timer
@onready var marker_2d: Marker2D = $Marker2D
signal died

func _ready() -> void:
	# to start shooting
	timer.start()

func _physics_process(_delta: float) -> void:
	
	# movement
	velocity = Vector2(direction,0) * speed
	move_and_slide()
	
	# bounds
	if global_position.x <= 60:
		direction = 1
	elif global_position.x >= 1092:
		direction = -1
	
	# shooting laser
	if able_shoot:
		var laser : CharacterBody2D = laser_instance.instantiate()
		laser.position = marker_2d.global_position
		randomize()
		laser.damage = randi_range(5,10)
		get_parent().add_child(laser)
		timer.start()
		able_shoot = false

func enemy_shoot() -> void:
	able_shoot = true

func die(body: CharacterBody2D) -> void:
	body.queue_free()
	queue_free()
	died.emit()
