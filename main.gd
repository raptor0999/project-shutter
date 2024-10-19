extends Node3D

var player:CharacterBody3D = null

@onready var level_node:Node3D = $Level
@onready var fade_rect:ColorRect = $ColorRect
@onready var music_player:AudioStreamPlayer = $MusicPlayer
@onready var pause_menu:Control = $UI/PauseMenu

var worldEnv

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("load_level", load_level)
	Globals.connect("pause_main_toggle", pause_toggle)
	Globals.connect("freeze_pause_menu_toggle", freeze_pause_menu_toggle)
	Globals.connect("brightness_set", brightness_set)
	Globals.connect("contrast_set", contrast_set)
	Globals.connect("saturation_set", saturation_set)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func pause_toggle():
	if Globals.paused:
		Globals.music_volume_adjust.emit(-Globals.pause_volume_adjustment)
		process_mode = PROCESS_MODE_DISABLED
	else:
		Globals.music_volume_adjust.emit(Globals.pause_volume_adjustment)
		process_mode = PROCESS_MODE_INHERIT
		
func freeze_pause_menu_toggle():
	if pause_menu.process_mode == Node.PROCESS_MODE_ALWAYS:
		pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
		print("Pause menu frozen")
	else:
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		print("Pause menu active")

func load_level(level_name: String, cam:String, named_element:String):
	clear_current_level()
	Globals.clear_hud.emit()
	print("Cleared current level")
	
	var level_scene = load("res://levels/" + level_name + ".tscn")
	var level_instance:Level = level_scene.instantiate()
	worldEnv = level_instance.get_node("WorldEnvironment")
	
	if is_instance_valid(worldEnv):
		worldEnv.environment.adjustment_brightness = Globals.brightness
		worldEnv.environment.adjustment_contrast = Globals.contrast
		worldEnv.environment.adjustment_saturation = Globals.saturation
	
	level_node.add_child(level_instance)
	print("Loaded level named: " + level_name)
	Globals.hud_level.emit(level_instance.display_name)
	
	var player_spawn:Node3D = level_instance.get_node("Doors/"+named_element)
	var p:Node = spawn_player(player_spawn)
	print("Spawned player")
	
	if cam == "standard_cam":
		p.standardCam.make_current()
	else:
		p.chaseCam.make_current()
	
	do_level_transition()
	
	Globals.hud_hint.emit(level_instance.display_description)
	
func clear_current_level():
	for l in level_node.get_children():
		l.queue_free()
		
func do_level_transition():
	print("Doing level transition")
	player.process_mode = Node.PROCESS_MODE_DISABLED
	#var screen_size = get_viewport().get_visible_rect().size
	#fade_rect.size = screen_size	
	var tween:Tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.5, 1.5).from(1.0)
	tween.play()
	await tween.finished
	
	# test for new music
	if music_player.current_track != 1:
		Globals.switch_track.emit(1)
		
	player.process_mode = Node.PROCESS_MODE_INHERIT
	
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.5).from(0.5)
	tween.play()
	await tween.finished
	print("Transition finished")
	
func spawn_player(player_spawn:Node3D):
	var player_scene = load("res://scenes/characters/player/player.tscn")
	var player_instance = player_scene.instantiate()
	
	player = player_instance
	var player_pos:Vector3 = player_spawn.get_node("PlayerSpawn").global_position
	var player_rot:Vector3 = Vector3(0, deg_to_rad(player_spawn.y_rot), 0)
	level_node.add_child(player_instance)
	player_instance.position = player_pos
	player_instance.rotation = player_rot
	print("Player pos: " + str(player_pos))
	
	return player_instance

func brightness_set(value):
	Globals.brightness = value
	if is_instance_valid(worldEnv):
		worldEnv.environment.adjustment_brightness = value
	
func contrast_set(value):
	Globals.contrast = value
	if is_instance_valid(worldEnv):
		worldEnv.environment.adjustment_contrast = value
	
func saturation_set(value):
	Globals.saturation = value
	if is_instance_valid(worldEnv):
		worldEnv.environment.adjustment_saturation = value
