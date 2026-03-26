extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickup_sound: AudioStreamPlayer2D = $pickup_sound
# Called when the node enters the scene tree for the first time.


func _on_body_entered(body) -> void:
	if body.name == "Player":
		body.show_message("I found the key")
		pickup_sound.play()
		body.has_key = true
		animation_player.play("key_pickup")
		

		
