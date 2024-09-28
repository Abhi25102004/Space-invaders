extends Node2D

@onready var score: Label = $score

func _ready() -> void:
	score.text = "High Score : " + str(Global.HighScore)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/game_scene.tscn")
	
