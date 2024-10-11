extends AudioStreamPlayer

@export var tracks:Array[Resource]
@export var initial_track = 0

var current_track = initial_track
var previous_track = current_track

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = load(tracks[current_track].resource_path)
	Globals.connect("start_music", start_music)
	Globals.connect("switch_track", switch_track)
	Globals.connect("previous_track", prev_track)
	Globals.connect("stop_music", stop_music)
	Globals.connect("music_volume_adjust",  music_volume_adjust)
	Globals.connect("sound_volume_adjust", sound_volume_adjust)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_music():
	if not playing:
		play()
		
func switch_track(track_num):
	stop()
	previous_track = current_track
	current_track = track_num
	stream = load(tracks[current_track].resource_path)
	play()
	
func prev_track():
	switch_track(previous_track)
		
func stop_music():
	stop()
		
func music_volume_adjust(amt):
	Globals.music_volume += amt
	volume_db = Globals.music_volume
	
func sound_volume_adjust(amt):
	Globals.sound_volume += amt
