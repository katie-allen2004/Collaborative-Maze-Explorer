extends Node

var brightness_value := 50.0
var volume_value := 100.0
var visual_cue_enabled := true

var master_bus := AudioServer.get_bus_index("Master")

func _ready() -> void:
	apply_volume()

func apply_volume() -> void:
	if volume_value <= 0.0:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(volume_value / 100.0))

func set_default_controls() -> void:
	InputMap.action_erase_events("move_up")
	InputMap.action_erase_events("move_down")
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_right")

	var up := InputEventKey.new()
	up.keycode = KEY_W
	InputMap.action_add_event("move_up", up)

	var down := InputEventKey.new()
	down.keycode = KEY_S
	InputMap.action_add_event("move_down", down)

	var left := InputEventKey.new()
	left.keycode = KEY_A
	InputMap.action_add_event("move_left", left)

	var right := InputEventKey.new()
	right.keycode = KEY_D
	InputMap.action_add_event("move_right", right)
