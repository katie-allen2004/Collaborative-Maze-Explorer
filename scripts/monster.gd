extends CharacterBody2D


const SPEED = 75.0

var player: Node2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	makepath()
	
func _physics_process(_delta: float) -> void:
	if player == null:
		return

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_path_pos := nav_agent.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos)
	velocity = dir * SPEED
	move_and_slide()
	
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
