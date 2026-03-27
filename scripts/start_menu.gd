extends Control


# Called when the node enters the scene tree for the first time.

func _on_start_game_pressed() -> void:
	$click.play()
	get_tree().change_scene_to_file("res://EndlessFog.tscn")

func _on_options_pressed() -> void:
	$click.play()
	print("options")

func _on_exit_pressed() -> void:
	$click.play()
	get_tree().quit()
