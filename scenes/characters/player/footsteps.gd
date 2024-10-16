extends Node3D

var footstep_sounds_dict = {
	"player_step_1": load("res://assets/audio/sounds/steps/player/steps_1.mp3"),
	"player_step_2": load("res://assets/audio/sounds/steps/player/steps_2.mp3"),
	"player_step_3": load("res://assets/audio/sounds/steps/player/steps_3.mp3"),
}

var footstep_sounds = [
	footstep_sounds_dict["player_step_1"],
	footstep_sounds_dict["player_step_2"],
	footstep_sounds_dict["player_step_3"],
]

var timer = 0.8;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_footstep():
	var rng = RandomNumberGenerator.new()
	play_sound_3d(rng.randi_range(0, footstep_sounds.size()-1))

func play_sound_2d(track:int):
	var audio = AudioStreamPlayer.new()
	
	audio.process_mode = Node.PROCESS_MODE_ALWAYS
	audio.volume_db = Globals.sound_volume
	audio.stream = footstep_sounds[track]
	audio.autoplay = true
	audio.finished.connect(func(): audio.queue_free())
	get_tree().current_scene.add_child(audio)

func play_sound_3d(track:int):
	var audio = AudioStreamPlayer3D.new()
	
	audio.process_mode = Node.PROCESS_MODE_ALWAYS
	audio.volume_db = Globals.sound_volume
	audio.stream = footstep_sounds[track]
	audio.autoplay = true
	audio.position = global_position + Vector3(0, -1.8, 0)
	audio.finished.connect(func(): audio.queue_free())
	get_tree().current_scene.add_child(audio)
