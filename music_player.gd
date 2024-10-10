extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("start_music", start_music)
	Globals.connect("stop_music", stop_music)
	Globals.connect("music_volume_adjust",  music_volume_adjust)
	Globals.connect("sound_volume_adjust", sound_volume_adjust)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_music():
	if not playing:
		play()
		
func stop_music():
	stop()
		
func music_volume_adjust(amt):
	Globals.music_volume += amt
	
func sound_volume_adjust(amt):
	Globals.sound_volume += amt
