extends AudioStreamPlayer

@export var tracks:Array[Resource]
@export var initial_track:int = 0

var current_track:int = initial_track
var previous_track:int = current_track

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = load(tracks[current_track].resource_path)
	Globals.connect("start_music", start_music)
	Globals.connect("switch_track", switch_track)
	Globals.connect("forward_track", forward_track)
	Globals.connect("back_track", back_track)
	Globals.connect("previous_track", prev_track)
	Globals.connect("stop_music", stop_music)
	Globals.connect("music_volume_set", music_volume_set)
	Globals.connect("music_volume_adjust",  music_volume_adjust)
	Globals.connect("sound_volume_set", sound_volume_set)
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
	
func back_track():
	stop()
	current_track -= 1
	
	if current_track < 0:
		current_track = tracks.size() - 1
		
	stream = load(tracks[current_track].resource_path)
	play()
	Globals.hud_text.emit(tracks[current_track].resource_path)
	print("Track Name: " + tracks[current_track].resource_path)
	
func forward_track():
	stop()
	current_track += 1
	
	if current_track >= tracks.size():
		current_track = 0
		
	stream = load(tracks[current_track].resource_path)
	play()
	Globals.hud_text.emit(tracks[current_track].resource_path)
	print("Track Name: " + tracks[current_track].resource_path)
	
func prev_track():
	switch_track(previous_track)
		
func stop_music():
	stop()
	
func music_volume_set(value):
	Globals.music_volume = value
	volume_db = Globals.music_volume
		
func music_volume_adjust(amt):
	Globals.music_volume += amt
	volume_db = Globals.music_volume
	
func sound_volume_set(value):
	Globals.sound_volume = value
	
func sound_volume_adjust(amt):
	Globals.sound_volume += amt
