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
		if spawn_number == 11:
			get_tree().change_scene_to_file("res://Scene/win_screen.tscn")
		add_enemy(spawn_number)

func add_enemy(spawn : int):
	# spawning enemys
	for i in range(spawn):
		var enemy_inst : CharacterBody2D = enemy.instantiate()
		enemy_inst.position = Vector2(place.x + (100 * i),170)
		add_child(enemy_inst)
		enemy_inst.connect("died",checker)
		enemy_in_scene += 1

func checker():
	# signal when enemy die
	score += 10
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
