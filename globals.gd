extends Node

signal freeze_player()
signal load_level(level_name, player_x)

signal freeze_pause_menu_toggle()
signal pause_menu_toggle()
signal main_menu_toggle()
signal pause_main_toggle()
signal option_menu_toggle()
signal credits_menu_toggle()
signal throw_menu_focus()

signal clue_menu_toggle()
signal pick_up_clue(clue)
signal add_clue(clue)
signal remove_clue(clue)
signal show_clue_description(clue)

signal start_music()
signal stop_music()
signal switch_track(number)
signal previous_track()
signal music_volume_set(value)
signal music_volume_adjust(amt)
signal sound_volume_set(value)
signal sound_volume_adjust(amt)

signal play_sound_2d(name)
signal play_sound_3d(name, position)

signal brightness_set(value)
signal contrast_set(value)
signal saturation_set(value)

signal clear_hud()
signal hud_level(level)
signal hud_text(text)
signal hud_hint(hint)

var game_started = false
var paused = false

var brightness = 1
var contrast = 1
var saturation = 1

@export var music_volume = 0
@export var sound_volume = 0
@export var pause_volume_adjustment = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
