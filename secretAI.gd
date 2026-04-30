extends CharacterBody2D

const SPEED = 140.0

var player: Node2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("monster")
	player = get_tree().get_first_node_in_group("player")
	makepath()
	
func _physics_process(_delta: float) -> void:
	if player == null:
		return

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		update_animation()
		move_and_slide()
		return

	var next_path_pos := nav_agent.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos)
	velocity = dir * SPEED
	
	update_animation()
	move_and_slide()
	
func update_animation() -> void:
	if velocity.length() > 0.1:
		sprite.play("Run")
		
		if velocity.x > 0:
			sprite.flip_h = true
		elif velocity.x < 0:
			sprite.flip_h = false
	else:
		sprite.play("Idle")

func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	makepath()

func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if body != player:
		return
	print("player touched monster")
	get_tree().call_deferred("change_scene_to_file", "res://Lose.tscn")
