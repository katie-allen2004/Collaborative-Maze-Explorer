extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			$PauseMenu.resume_game()
		else:
			$PauseMenu.pause_game()
