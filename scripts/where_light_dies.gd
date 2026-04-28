extends Node2D

@export var current_map: PackedScene
@onready var map_location: Marker2D = $CurrentLevel
@onready var brightness_dark_overlay: ColorRect = $CanvasLayer/BrightnessDarkOverlay
@onready var brightness_light_overlay: ColorRect = $CanvasLayer/BrightnessLightOverlay
@onready var monster_cue = $CanvasLayer/MonsterCue
@onready var canvas_modulate = $CanvasModulate
@onready var monster_cue_material = monster_cue.material
@onready var player = $Player

var map_choice = []

func _ready():
	add_to_group("brightness_target")
	
	randomize()
	if GlobalStats.difficulty == "easy":
		map_choice = ["res://levels/Easy1.tscn", "res://levels/Easy2.tscn","res://levels/Easy3.tscn"]
	elif GlobalStats.difficulty == "medium":
		map_choice = ["res://levels/Med1.tscn"]
	else:
		map_choice = ["res://levels/Hard1.tscn"]
	
	var current_map_choice = map_choice.pick_random()
	current_map = load(current_map_choice)
	var pos = map_location.global_position
	var map = current_map.instantiate()
	map.global_position = pos
	add_child(map)
	
	move_child(brightness_dark_overlay, get_child_count() - 1)
	move_child(brightness_light_overlay, get_child_count() - 1)
	
	apply_settings()

func apply_settings() -> void:
	Settings.apply_volume()
	apply_brightness()
	
func apply_brightness() -> void:
	var brightness_value = Settings.brightness_value
	var max_darkness := 0.75
	
	var darkest := 0.0
	var brightest := 0.4

	if brightness_value < 50.0:
		var t = brightness_value / 50.0
		brightness_dark_overlay.color = Color(0, 0, 0, (1.0 - t) * max_darkness)
		brightness_light_overlay.color = Color(1, 1, 1, 0.0)
		canvas_modulate.color = Color(darkest, darkest, darkest)

	elif brightness_value > 50.0:
		var t = brightness_value / 100.0
		var gray = lerp(darkest, brightest, t)
		canvas_modulate.color = Color(gray, gray, gray)

		brightness_dark_overlay.color = Color(0, 0, 0, 0.0)
		brightness_light_overlay.color = Color(1, 1, 1, 0.0)

	else:
		canvas_modulate.color = Color(darkest, darkest, darkest)
		brightness_dark_overlay.color = Color(0, 0, 0, 0.0)
		brightness_light_overlay.color = Color(1, 1, 1, 0.0)
		
func _process(_delta: float) -> void:
	update_monster_cue()
	
func update_monster_cue() -> void:
	if not Settings.visual_cue_enabled:
		monster_cue_material.set_shader_parameter("intensity", 0.0)
		return
	
	var monster = get_tree().get_first_node_in_group("monster")
	if monster == null or player == null:
		monster_cue_material.set_shader_parameter("intensity", 0.0)
		return
		
	var distance = player.global_position.distance_to(monster.global_position)
	
	# Farthest distance for the visual cue to appear
	var max_distance := 200.0
	
	# closeness: 0 = far, 1 = very close
	var closeness = clamp(1.0 - (distance / max_distance), 0.0, 1.0)
	
	# Pulse speed increases as monster gets closer
	var pulse_speed = lerp(1.5, 6.0, closeness)
	
	# Pulse range gets stronger as monster gets closer
	var pulse = (sin(Time.get_ticks_msec() / 1000.0 * TAU * pulse_speed) + 1.0) * 0.5
	
	# Keep base visibility, then add pulse
	var intensity = closeness * (0.35 + pulse * 0.65)
	
	# Color shifts as monster approaches: yellow -> orange -> red
	var far_color = Color(1.0, 0.9, 0.2)
	var mid_color = Color(1.0, 0.5, 0.0)
	var near_color = Color(1.0, 0.1, 0.1)
	
	var color: Color
	if closeness < 0.5: 
		color = far_color.lerp(mid_color, closeness / 0.5)
	else:
		color = mid_color.lerp(near_color, (closeness - 0.5) / 0.5)
		
	monster_cue_material.set_shader_parameter("border_color", color)
	monster_cue_material.set_shader_parameter("intensity", intensity)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			$PauseMenu.resume_game()
		else:
			$PauseMenu.pause_game()
