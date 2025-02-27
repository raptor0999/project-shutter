extends Control

@onready var fullOrWindowsOptions:OptionButton = $VBoxContainer/FullOrWindowOptions
@onready var resolutionOptions:OptionButton = $VBoxContainer/ResolutionOptions
@onready var musicVolSlider:HSlider = $VBoxContainer/MusicVolume
@onready var soundVolSlider:HSlider = $VBoxContainer/SoundVolume
@onready var colorRec:ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("option_menu_toggle", option_menu_toggle)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and visible:
		Globals.play_sound_2d.emit("ui_close")
		option_menu_toggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func option_menu_toggle():
	if visible:
		hide()
		Globals.throw_menu_focus.emit()
		#Globals.freeze_pause_menu_toggle.emit()
	else:
		if Globals.game_started:
			colorRec.hide()
		else:
			colorRec.show()
			
		if Globals.fullscreen:
			fullOrWindowsOptions.select(0)
		else:
			fullOrWindowsOptions.select(1)
		if Globals.resolution == Vector2(1152, 648):
			resolutionOptions.select(0)
		if Globals.resolution == Vector2(1280, 720):
			resolutionOptions.select(1)
		if Globals.resolution == Vector2(1920, 1080):
			resolutionOptions.select(2)
			
		fullOrWindowsOptions.grab_focus()
		show()
		#Globals.freeze_pause_menu_toggle.emit()

func _on_close_pressed() -> void:
	Globals.play_sound_2d.emit("ui_close")
	option_menu_toggle()
	
func _on_full_or_window_options_item_selected(index: int) -> void:
	if index == 0:
		# set full screen
		Globals.fullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		
	if index == 1:
		# set windowed screen
		Globals.fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func _on_resolution_options_item_selected(index: int) -> void:
	if index == 0:
		Globals.resolution = Vector2(1152, 648)
		DisplayServer.window_set_size(Vector2(1152, 648))
	if index == 1:
		Globals.resolution = Vector2(1280, 720)
		DisplayServer.window_set_size(Vector2(1280, 720))
	if index == 2:
		Globals.resolution = Vector2(1920, 1080)
		DisplayServer.window_set_size(Vector2(1920, 1080))

func _on_music_volume_value_changed(value: float) -> void:
	Globals.music_volume_set.emit(value)

func _on_sound_volume_value_changed(value: float) -> void:
	Globals.sound_volume_set.emit(value)

func _on_brightness_slider_value_changed(value: float) -> void:
	Globals.brightness_set.emit(value)

func _on_contrast_slider_value_changed(value: float) -> void:
	Globals.contrast_set.emit(value)

func _on_saturation_slider_value_changed(value: float) -> void:
	Globals.saturation_set.emit(value)
