extends Node3D

var player:CharacterBody3D = null

@onready var level_node:Node3D = $Level
@onready var fade_rect:ColorRect = $ColorRect
@onready var music_player:AudioStreamPlayer = $MusicPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("load_level", load_level)
	Globals.connect("pause_main_toggle", pause_toggle)

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

func load_level(level_name: String, player_x: float):
	clear_current_level()
	print("Cleared current level")
	
	var level_scene = load("res://levels/" + level_name + ".tscn")
	var level_instance = level_scene.instantiate()
	
	level_node.add_child(level_instance)
	print("Loaded level named: " + level_name)
	
	spawn_player(player_x)
	print("Spawned player")
	
	do_level_transition()
	
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
	
func spawn_player(player_x: float):
	var player_scene = load("res://scenes/characters/player/player.tscn")
	var player_instance = player_scene.instantiate()
	player_instance.position.x = player_x
	print("Player X: " + str(player_x))
	
	player = player_instance
	
	level_node.add_child(player_instance)
