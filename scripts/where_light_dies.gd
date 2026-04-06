extends Node2D

@export var current_map: PackedScene
@onready var map_location: Marker2D = $CurrentLevel

var map_choice = []

func _ready():
	randomize()
	if GlobalStats.difficulty == "easy":
		map_choice = ["res://levels/Level1Maze1.tscn", "res://levels/Easy1.tscn", "res://levels/Easy2.tscn","res://levels/Easy3.tscn"]
		#map_choice = ["res://levels/Easy1.tscn"]
	elif GlobalStats.difficulty == "medium":
		map_choice = ["res://levels/Medium1.tscn", "res://levels/Medium2.tscn","res://levels/Medium3.tscn"]
	else:
		map_choice = ["res://levels/Hard1.tscn", "res://levels/Hard2.tscn","res://levels/Hard3.tscn"]
	var current_map_choice = map_choice.pick_random()
	current_map = load(current_map_choice)
	var pos = map_location.global_position
	var map = current_map.instantiate()
	map.global_position = pos
	add_child(map)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			$PauseMenu.resume_game()
		else:
			$PauseMenu.pause_game()
