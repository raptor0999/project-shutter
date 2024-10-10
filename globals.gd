extends Node

signal freeze_player()
signal load_level(level_name, player_x)
signal start_music()
signal stop_music()
signal music_volume_adjust(amt)
signal sound_volume_adjust(amt)

@export var music_volume = 0
@export var sound_volume = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
