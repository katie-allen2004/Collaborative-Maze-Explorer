extends Node2D

@export var key_scene: PackedScene
@onready var spawn_a: Marker2D = $KeySpawnA
@onready var spawn_b: Marker2D = $KeySpawnB

func _ready():
	randomize()
	
	var spawns = [spawn_a.global_position, spawn_b.global_position]
	var pos = spawns.pick_random()

	var key = key_scene.instantiate()
	key.global_position = pos
	add_child(key)
