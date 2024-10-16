extends Node

var sounds_dict = {
	"ui_accept": load("res://assets/audio/sounds/ui/ui_accept.mp3"),
	"ui_select": load("res://assets/audio/sounds/ui/ui_select.mp3"),
	"ui_close": load("res://assets/audio/sounds/ui/ui_cancel_ext.mp3"),
	"clue_pick_up": load("res://assets/audio/sounds/clues/clue_pick_up_ext.mp3"),
	"clue_open": load("res://assets/audio/sounds/clues/clue_open_ext.mp3"),
	"clue_select": load("res://assets/audio/sounds/clues/clue_select.mp3"),
	"door_open": load("res://assets/audio/sounds/doors/door_open_1.mp3"),
	"door_close": load("res://assets/audio/sounds/doors/door_close_1.mp3")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("play_sound_2d", play_sound_2d)
	Globals.connect("play_sound_3d", play_sound_3d)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sound_2d(name:String):
	var audio = AudioStreamPlayer.new()
	
	audio.process_mode = Node.PROCESS_MODE_ALWAYS
	audio.volume_db = Globals.sound_volume
	audio.stream = sounds_dict[name]
	audio.autoplay = true
	audio.finished.connect(func(): audio.queue_free())
	get_tree().current_scene.add_child(audio)

func play_sound_3d(name:String, position:Vector3):
	var audio = AudioStreamPlayer3D.new()
	
	audio.process_mode = Node.PROCESS_MODE_ALWAYS
	audio.volume_db = Globals.sound_volume
	audio.stream = sounds_dict[name]
	audio.autoplay = true
	audio.position = position
	audio.finished.connect(func(): audio.queue_free())
	get_tree().current_scene.add_child(audio)
