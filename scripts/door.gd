extends Area2D

func _on_body_entered(body):
	if body.has_key == true:
		get_tree().call_deferred("change_scene_to_file", "res://EndScreen.tscn")
	else:
		body.show_message("I need a key")
		$Deny.play()
