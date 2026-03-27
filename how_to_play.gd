extends Control

func _ready():
	$VBoxContainer/TitleLabel.text = "How to Play"
	$VBoxContainer/InstructionsLabel.text = "Use WASD or arrow keys to move.\nFind the key in the maze.\nReach the door to escape.\nDo not get lost in the fog."
	$VBoxContainer/BackButton.text = "Back"

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")
