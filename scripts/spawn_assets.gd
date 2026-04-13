extends Node2D

@export var key_scene: PackedScene
@onready var spawn_a: Marker2D = $KeySpawnA
@onready var spawn_b: Marker2D = $KeySpawnB
@onready var monster_spawn: Marker2D = $MonsterSpawn

func _ready():
	randomize()
	
	var spawns = [spawn_a.global_position, spawn_b.global_position]
	var pos = spawns.pick_random()

	var key = key_scene.instantiate()
	add_child(key)
	key.global_position = pos
	key.connect("key_collected", Callable(self, "_on_key_collected"))


func _on_key_collected():
	call_deferred("_spawn_unit_safely")
	
func _spawn_unit_safely():
	var monster = preload("res://monster.tscn").instantiate()
	add_child(monster)
	
