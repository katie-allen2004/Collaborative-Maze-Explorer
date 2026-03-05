extends CharacterBody2D


const SPEED = 130.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var last_facing := "down" # "up", "down", "side"
var has_key = false

@onready var label = $Camera2D/Label

func _physics_process(_delta: float) -> void:
	#
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	update_animation(direction)
	
func play_anim(anim_name: StringName) -> void:
		if animated_sprite_2d.animation != anim_name:
			animated_sprite_2d.play(anim_name)
	
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
var fade_tween
func show_message(text):
	label.text = text
	label.modulate.a = 1.0
	
	if fade_tween:
		fade_tween.kill()
	
	await get_tree().create_timer(1.5).timeout
	
	fade_tween = create_tween()
	fade_tween.tween_property(label, "modulate:a", 0.0, 1.0)
