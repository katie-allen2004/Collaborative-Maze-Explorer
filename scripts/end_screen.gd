extends Control

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

func _ready() -> void:
	apply_brightness()
	Settings.apply_volume()

func apply_brightness() -> void:
	var brightness_value = Settings.brightness_value

	var darkest := 0.25
	var brightest := 1.15

	var t = brightness_value / 100.0
	var gray = lerp(darkest, brightest, t)

	canvas_modulate.color = Color(gray, gray, gray)
	
func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://WhereLightDies.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
