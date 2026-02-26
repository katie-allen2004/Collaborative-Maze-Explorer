extends CharacterBody2D


const SPEED = 130.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var last_facing := "down" # "up", "down", "side"

func _physics_process(delta: float) -> void:
	#
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	update_animation(direction)
	
func play_anim(name: StringName) -> void:
		if animated_sprite_2d.animation != name:
			animated_sprite_2d.play(name)
	
func update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		match last_facing:
			"side": play_anim(&"idle_side")
			"up": play_anim(&"idle_up")
			"down": play_anim(&"idle_down")
		return

	# Determine dominant direction
	if abs(direction.x) > abs(direction.y):
		last_facing = "side"
		animated_sprite_2d.flip_h = direction.x < 0
		play_anim(&"walk_side")
	else:
		animated_sprite_2d.flip_h = false
		if direction.y < 0:
			last_facing = "up"
			play_anim(&"walk_up")
		else:
			last_facing = "down"
			play_anim(&"walk_down")
