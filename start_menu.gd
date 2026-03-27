extends Control

@onready var start_menu = $StartMenu
@onready var difficulty_menu = $DifficultyMenu
@onready var how_to_play_menu = $HowToPlayMenu

var menu_width := 1152.0
var is_transitioning := false

func _ready():
	start_menu.position = Vector2(0, 0)
	difficulty_menu.position = Vector2(menu_width, 0)
	how_to_play_menu.visible = false

# Called when the node enters the scene tree for the first time.

func _on_start_game_pressed():
	if is_transitioning:
		return
	is_transitioning = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(start_menu, "position:x", -menu_width, 0.8)
	tween.tween_property(difficulty_menu, "position:x", 0, 0.8)
	
	tween.finished.connect(func():
		is_transitioning = false
	)
	# $click.play()
	# get_tree().change_scene_to_file("res://WhereLightDies.tscn")

func _on_options_pressed() -> void:
	$click.play()
	print("options")

func _on_exit_pressed() -> void:
	$click.play()
	get_tree().quit()


func _on_how_to_play_pressed() -> void:
	how_to_play_menu.visible = true


func _on_easy_pressed() -> void:
	pass # Replace with function body.


func _on_medium_pressed() -> void:
	pass # Replace with function body.


func _on_hard_pressed() -> void:
	pass # Replace with function body.


func _on_back_pressed() -> void:
	if is_transitioning:
		return
	is_transitioning = true
		
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
		
	tween.tween_property(difficulty_menu, "position:x", menu_width, 0.8)
	tween.tween_property(start_menu, "position:x", 0, 0.8)
		
	tween.finished.connect(func():
		is_transitioning = false
	) # Replace with function body.


func _on_close_htp_button_pressed():
	how_to_play_menu.visible = false
