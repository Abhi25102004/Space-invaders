extends CharacterBody2D

var direction : int = 1
var speed : int = 300
var able_shoot : bool = false
var damage : int = 5
var laser_instance : PackedScene = preload("res://Scene/enemy_laser.tscn")
@onready var timer: Timer = $Timer
@onready var marker_2d: Node2D = $Markers

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
		for mark in marker_2d.get_children():
			var laser : CharacterBody2D = laser_instance.instantiate()
			laser.position = mark.global_position
			laser.damage = damage
			get_parent().add_child(laser)
		timer.start()
		able_shoot = false

func enemy_shoot() -> void:
	able_shoot = true
	randomize()
	speed = randi_range(300,500)
	timer.wait_time = randi_range(1,5)

func die(body: CharacterBody2D) -> void:
	body.queue_free()
	randomize()
	damage += randi_range(1,5)
