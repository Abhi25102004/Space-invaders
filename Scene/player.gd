extends CharacterBody2D

var direction : int
var speed : int = 400
var able_shoot : bool = true
var laser_instance : PackedScene = preload("res://Scene/laser.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var timer: Timer = $Shooting_timer
@onready var health_bar: TextureProgressBar = $TextureProgressBar
@onready var shield: Sprite2D = $Shield
@onready var shield_timer: Timer = $Shield_timer
@onready var area_2d: Area2D = $Area2D
@onready var player_image: Sprite2D = $Player_image
@onready var laser_audio: AudioStreamPlayer2D = $laser_audio

signal health_needed

func _physics_process(_delta: float) -> void:
	# movement
	direction = int(Input.get_axis("left","right"))
	velocity = Vector2(direction,0) * speed
	move_and_slide()
	Global.players_global_position = global_position
	
	# bounds
	if global_position.x < 60:
		global_position.x = 60
	elif global_position.x > 1092:
		global_position.x = 1092
	
	# shooting laser
	if Input.is_action_pressed("shoot") and able_shoot:
		laser_audio.play()
		var laser : CharacterBody2D = laser_instance.instantiate()
		laser.position = marker_2d.global_position
		get_parent().add_child(laser)
		timer.start()
		able_shoot = false
	
	# die
	if health_bar.value <= 0:
		Global.HighScore = Global.score if Global.HighScore < Global.score else Global.HighScore
		get_parent().get_tree().change_scene_to_file("res://Scene/death_scene.tscn")
	
	if health_bar.value <= 35:
		health_needed.emit()

func able_to_shoot_laser() -> void:
	able_shoot = true

func decrease_health(body: CharacterBody2D) -> void:
	if body.collision_layer == 32:
		randomize()
		health_bar.value += randi_range(35,50)
		shield.visible = true
		area_2d.collision_layer = 64
		area_2d.collision_mask = 32
		shield_timer.start()
		speed += randi_range(50,100)
	else :
		health_bar.value -= body.damage
	body.queue_free()

func _on_shield_timer_timeout() -> void:
	area_2d.collision_layer = 1
	area_2d.collision_mask = 48
	shield.visible = false
	speed = 400
