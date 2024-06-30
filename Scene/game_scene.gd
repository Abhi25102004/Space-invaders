extends Node2D

var score : int = 0
var spawn_number : int = 0
var enemy_in_scene : int = 0
var place : Vector2 = Vector2(60,170)
var health_boost : bool = true
var ufo : PackedScene = preload("res://Scene/ufo.tscn")
var enemy : PackedScene = preload("res://Scene/enemy.tscn")
var health_object : PackedScene = preload("res://Scene/Player_health.tscn")
var star_instance : PackedScene = preload("res://Scene/stars.tscn")
@onready var player: CharacterBody2D = $Player
@onready var scored: Label = $Score

func _ready() -> void:
	for i in range(50):
		var star : Sprite2D = star_instance.instantiate()
		randomize()
		star.position = Vector2(randi_range(10,1140),randf_range(10,630))
		$Stars.add_child(star)
	player.connect("health_needed",add_health_object)

func _process(_delta: float) -> void:
	# check to spawn enemys
	if !(enemy_in_scene):
		spawn_number += 1
		add_enemy(spawn_number)

func add_enemy(spawn : int):
	var x_position : int  = 0
	var y_position : int = 0
	var iter : int = 0
	var total_arr : Array = []
	var total : int 
	if (spawn/9):
		for j in range(spawn/9):
			total_arr.append(9)
	if (spawn % 9):
		total_arr.append(spawn % 9)
	total = total_arr.pop_front()
	for i in range(spawn):
		if !(i % 9) and i!=0:
			x_position = 0
			y_position += 1
			iter = 0
			total = total_arr.pop_front()
		var enemy_inst : CharacterBody2D = enemy.instantiate()
		enemy_inst.position = Vector2(place.x + (110 * x_position) , place.y + (62 * y_position))
		x_position += 1
		enemy_inst.minimum = 60 + (iter * 110)
		enemy_inst.maximum = 1092 - ((total - 1 - iter) * 110)
		iter += 1
		add_child(enemy_inst)
		enemy_inst.connect("died",checker)
		enemy_in_scene += 1

func checker():
	# signal when enemy die
	score += 10
	Global.score = score
	scored.text = "SCORE : " + str(score)
	enemy_in_scene -= 1
	
func add_health_object():
	if health_boost:
		var health : CharacterBody2D = health_object.instantiate()
		randomize()
		health.position = Vector2(randi_range(20,1132),20)
		add_child(health)
		health.connect("add_health_checker",health_boost_true)
		health_boost = false

func health_boost_true():
	health_boost = true


func _on_quite_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/display.tscn")
