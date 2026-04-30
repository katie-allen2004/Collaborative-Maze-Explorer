extends Control

@onready var start_menu = $StartMenu
@onready var difficulty_menu = $DifficultyMenu
@onready var how_to_play_menu = $HowToPlayMenu
@onready var options_menu = $OptionsMenu

@onready var move_up_button = $OptionsMenu/ControlsSection/UpButton
@onready var move_down_button = $OptionsMenu/ControlsSection/DownButton
@onready var move_left_button = $OptionsMenu/ControlsSection/LeftButton
@onready var move_right_button = $OptionsMenu/ControlsSection/RightButton

@onready var brightness_slider = $OptionsMenu/AccessibilitySection/BrightnessHSlider
@onready var volume_slider = $OptionsMenu/AccessibilitySection/VolumeHSlider
@onready var visual_cue_checkbox = $OptionsMenu/AccessibilitySection/VisualCueCheckBox

@onready var brightness_dark_overlay: ColorRect = $BrightnessDarkOverlay
@onready var brightness_light_overlay: ColorRect = $BrightnessLightOverlay
@onready var canvas_modulate = $CanvasModulate

var menu_width := 1152.0
var is_transitioning := false
var waiting_for_action := ""

func _ready():
	start_menu.position = Vector2(0, 0)
	difficulty_menu.position = Vector2(menu_width, 0)
	options_menu.position = Vector2(menu_width, 0)
	
	how_to_play_menu.visible = false
	
	brightness_slider.value = Settings.brightness_value
	volume_slider.value = Settings.volume_value
	visual_cue_checkbox.button_pressed = Settings.visual_cue_enabled
	
	apply_brightness()
	Settings.apply_volume()
	refresh_control_labels()
	

func slide_menus(menu_out: Control, menu_in: Control, out_target_x: float, in_target_x: float) -> void:
	if is_transitioning:
		return
	
	is_transitioning = true
	menu_in.visible = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(menu_out, "position:x", out_target_x, 0.8)
	tween.tween_property(menu_in, "position:x", in_target_x, 0.8)
	
	tween.finished.connect(func():
		is_transitioning = false
	)

func _on_start_game_pressed() -> void:
	$click.play()
	slide_menus(start_menu, difficulty_menu, -menu_width, 0)

func _on_options_pressed() -> void:
	$click.play()
	slide_menus(start_menu, options_menu, -menu_width, 0)

func _on_exit_pressed() -> void:
	$click.play()
	get_tree().quit()


func _on_how_to_play_pressed() -> void:
	$click.play()
	how_to_play_menu.visible = true

func _on_secret_pressed() -> void:
	$click.play()
	GlobalStats.difficulty = "secret"
	get_tree().change_scene_to_file("res://WhereLightDies.tscn")
	
func _on_easy_pressed() -> void:
	$click.play()
	GlobalStats.difficulty = "easy"
	get_tree().change_scene_to_file("res://WhereLightDies.tscn")


func _on_medium_pressed() -> void:
	$click.play()
	GlobalStats.difficulty = "medium"
	get_tree().change_scene_to_file("res://WhereLightDies.tscn")


func _on_hard_pressed() -> void:
	$click.play()
	GlobalStats.difficulty = "hard"
	get_tree().change_scene_to_file("res://WhereLightDies.tscn")


func _on_back_pressed() -> void:
	$click.play()
	slide_menus(difficulty_menu, start_menu, menu_width, 0)

func _on_close_htp_button_pressed():
	how_to_play_menu.visible = false


func _on_up_button_pressed() -> void:
	begin_rebind("move_up", move_up_button)


func _on_left_button_pressed() -> void:
	begin_rebind("move_left", move_left_button)


func _on_down_button_pressed() -> void:
	begin_rebind("move_down", move_down_button)


func _on_right_button_pressed() -> void:
	begin_rebind("move_right", move_right_button)
	
func begin_rebind(action_name: String, button: Button) -> void:
	waiting_for_action = action_name
	button.release_focus()
	refresh_control_labels()
	button.text = "Press a key..."
	
func _input(event: InputEvent) -> void:
	if waiting_for_action == "":
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			waiting_for_action = ""
			refresh_control_labels()
			get_viewport().set_input_as_handled()
			return

		remap_action(waiting_for_action, event)
		waiting_for_action = ""
		refresh_control_labels()
		get_viewport().set_input_as_handled()
		
func remap_action(action_name: String, new_event: InputEventKey) -> void:
	remove_event_from_actions(new_event, [
		"move_up",
		"move_down",
		"move_left",
		"move_right"
	])
		
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, new_event)

func remove_event_from_actions(event_to_remove: InputEventKey, actions: Array[String]) -> void:
	for action in actions:
		var events = InputMap.action_get_events(action)
		for old_event in events:
			if old_event is InputEventKey and old_event.keycode == event_to_remove.keycode:
				InputMap.action_erase_event(action, old_event)
				
func get_action_text(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	for event in events:
		if event is InputEventKey:
			if event.keycode != 0:
				return OS.get_keycode_string(event.keycode)
			elif event.physical_keycode != 0:
				return OS.get_keycode_string(event.physical_keycode)
	return "Unbound"
	
func refresh_control_labels() -> void:
	move_up_button.text = "Up: " + get_action_text("move_up")
	move_down_button.text = "Down: " + get_action_text("move_down")
	move_left_button.text = "Left: " + get_action_text("move_left")
	move_right_button.text = "Right: " + get_action_text("move_right")
	
func set_default_controls() -> void:
	InputMap.action_erase_events("move_up")
	InputMap.action_erase_events("move_down")
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_right")
	
	var up := InputEventKey.new()
	up.keycode = KEY_W
	InputMap.action_add_event("move_up", up)
		
	var down := InputEventKey.new()
	down.keycode = KEY_S
	InputMap.action_add_event("move_down", down)
	
	var left := InputEventKey.new()
	left.keycode = KEY_A
	InputMap.action_add_event("move_left", left)
	
	var right := InputEventKey.new()
	right.keycode = KEY_D
	InputMap.action_add_event("move_right", right)

func _on_reset_controls_button_pressed() -> void:
	$click.play()
	Settings.set_default_controls()
	refresh_control_labels()


func _on_brightness_slider_value_changed(value: float) -> void:
	Settings.brightness_value = value
	apply_brightness()

func apply_brightness() -> void:
	var brightness_value = Settings.brightness_value

	var darkest := 0.25
	var brightest := 1.15

	var t = brightness_value / 100.0
	t = pow(t, 0.8)

	var gray = lerp(darkest, brightest, t)

	canvas_modulate.color = Color(gray, gray, gray)

	brightness_dark_overlay.color = Color(0, 0, 0, 0.0)
	brightness_light_overlay.color = Color(1, 1, 1, 0.0)

func _on_visual_cue_check_box_toggled(toggled_on: bool) -> void:
	Settings.visual_cue_enabled = toggled_on

func _on_volume_slider_value_changed(value: float) -> void:
	Settings.volume_value = value
	Settings.apply_volume()

func _on_options_back_button_pressed() -> void:
	$click.play()
	slide_menus(options_menu, start_menu, menu_width, 0)
