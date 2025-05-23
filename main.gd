extends Node3D

var player:CharacterBody3D = null

@onready var level_node:Node3D = $Level
@onready var fade_rect:ColorRect = $ColorRect
@onready var music_player:AudioStreamPlayer = $MusicPlayer
@onready var pause_menu:Control = $UI/PauseMenu

var worldEnv

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("load_scene", load_scene)
	Globals.connect("load_level", load_level)
	Globals.connect("pause_main_toggle", pause_toggle)
	Globals.connect("freeze_pause_menu_toggle", freeze_pause_menu_toggle)
	Globals.connect("set_freeze_pause_menu", set_freeze_pause_menu)
	Globals.connect("brightness_set", brightness_set)
	Globals.connect("contrast_set", contrast_set)
	Globals.connect("saturation_set", saturation_set)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("save_level"):
		save_scene(level_node, "temp")
	
func pause_toggle():
	if Globals.paused:
		Globals.music_volume_adjust.emit(-Globals.pause_volume_adjustment)
		process_mode = PROCESS_MODE_DISABLED
		print("Paused")
	else:
		Globals.music_volume_adjust.emit(Globals.pause_volume_adjustment)
		process_mode = PROCESS_MODE_INHERIT
		print("Not paused")
		
func freeze_pause_menu_toggle():
	if pause_menu.process_mode == Node.PROCESS_MODE_ALWAYS:
		pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
		print("Pause menu frozen")
	else:
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		print("Pause menu active")
		
func set_freeze_pause_menu(freeze:bool):
	if freeze:
		pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
		print("Pause menu frozen")
	else:
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		print("Pause menu active")
		
func save_scene(base_node, name):
	if not DirAccess.dir_exists_absolute("res://persisted"):
		DirAccess.make_dir_absolute("res://persisted");
		
	var file_path = "res://persisted/" + name + ".tscn"
	for child in base_node.get_children():
		child.set_owner(base_node)
	var scene = PackedScene.new()
	scene.pack(base_node)
	var error = ResourceSaver.save(scene, file_path)
	if error != OK:
		push_error("An error occurred while saving the scene to disk.")
		print("Error saving scene: " + str(error))
	else:
		print("Scene saved")
		
func load_scene(scene_name:String):
	clear_current_level()
	Globals.clear_hud.emit()
	print("Cleared current level")
	
	var level_scene = load("res://levels/" + scene_name + ".tscn")
	var level_instance:Level = level_scene.instantiate()
	worldEnv = level_instance.get_node("WorldEnvironment")
	
	if is_instance_valid(worldEnv):
		worldEnv.environment.adjustment_brightness = Globals.brightness
		worldEnv.environment.adjustment_contrast = Globals.contrast
		worldEnv.environment.adjustment_saturation = Globals.saturation
	
	level_node.add_child(level_instance)
	print("Loaded scene named: " + scene_name)
	Globals.hud_level.emit(level_instance.display_name)

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
	spawn_player(player_spawn)
	print("Spawned player")
	
	if cam == "standard_cam":
		player.standardCam.make_current()
	else:
		player.chaseCam.make_current()
	
	Globals.hud_hint.emit(level_instance.display_description)
	
	await do_level_transition()
	
	if level_instance.display_name == "Foyer" and Globals.first_time_in_foyer:
		DialogueManager.show_dialogue_balloon(load("res://dialogue/main.dialogue"), "first_time_in_foyer")
	
func clear_current_level():
	save_scene(level_node, level_node.name)
	for l in level_node.get_children():
		l.queue_free()
		
func do_level_transition():
	print("Doing level transition")
	#player.process_mode = Node.PROCESS_MODE_DISABLED
	Globals.freeze_player.emit()
	#var screen_size = get_viewport().get_visible_rect().size
	#fade_rect.size = screen_size	
	var tween:Tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.5, 1.5).from(1.0)
	tween.play()
	await tween.finished
	
	# test for new music
	if music_player.current_track != 1:
		Globals.switch_track.emit(1)
		
	#player.process_mode = Node.PROCESS_MODE_INHERIT
	
	
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.5).from(0.5)
	tween.play()
	await tween.finished
	print("Transition finished")
	Globals.unfreeze_player.emit()
	
func spawn_player(player_spawn:Node3D):
	if not is_instance_valid(player):
		var player_scene = load("res://scenes/characters/player/player.tscn")
		player = player_scene.instantiate()
		add_child(player)
		
	var player_pos:Vector3 = player_spawn.get_node("PlayerSpawn").global_position
	var player_rot:Vector3 = Vector3(0, deg_to_rad(player_spawn.y_rot), 0)

	player.position = player_pos
	player.rotation = player_rot
	print("Player pos: " + str(player))
	

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
