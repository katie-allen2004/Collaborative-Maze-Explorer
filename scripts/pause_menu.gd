extends CanvasLayer

@onready var pause_panel = $PausePanel
@onready var options_panel = $OptionsPanel

@onready var brightness_slider = $OptionsPanel/VBoxContainer/BrightnessHSlider
@onready var volume_slider = $OptionsPanel/VBoxContainer/VolumeHSlider
@onready var visual_cue_checkbox = $OptionsPanel/VBoxContainer/VisualCueCheckBox

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	pause_panel.visible = true
	options_panel.visible = false
	
	brightness_slider.value = Settings.brightness_value
	volume_slider.value = Settings.volume_value
	visual_cue_checkbox.button_pressed = Settings.visual_cue_enabled

func pause_game() -> void:
	get_tree().paused = true
	visible = true
	pause_panel.visible = true
	options_panel.visible = false

func resume_game() -> void:
	get_tree().paused = false
	visible = false

func _on_resume_button_pressed() -> void:
	resume_game()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://start_menu.tscn")


func _on_options_button_pressed() -> void:
	pause_panel.visible = false
	options_panel.visible = true

func _on_back_button_pressed() -> void:
	options_panel.visible = false
	pause_panel.visible = true

func _on_brightness_h_slider_value_changed(value: float) -> void:
	Settings.brightness_value = value
	get_tree().call_group("brightness_target", "apply_brightness")

func _on_volume_h_slider_value_changed(value: float) -> void:
	Settings.volume_value = value
	Settings.apply_volume()

func _on_visual_cue_check_box_toggled(toggled_on: bool) -> void:
	Settings.visual_cue_enabled = toggled_on
