extends Node

signal freeze_player()
signal load_level(level_name, player_x)

signal pause_toggle()
signal main_menu_toggle()
signal pause_main_toggle()
signal option_menu_toggle()
signal credits_menu_toggle()

signal start_music()
signal stop_music()
signal switch_track(number)
signal music_volume_adjust(amt)
signal sound_volume_adjust(amt)

var game_started = false
var paused = false

@export var music_volume = 0
@export var sound_volume = 0
@export var pause_volume_adjustment = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
